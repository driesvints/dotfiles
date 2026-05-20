# tests/bin/helpers/brewfile_spec.rb
# Tests for bin/helpers/brewfile.rb
#
# Run with: ruby tests/bin/helpers/brewfile_spec.rb

require 'minitest/autorun'
require 'minitest/spec'

HELPERS_DIR = File.expand_path('../../../bin/helpers', __dir__) unless defined?(HELPERS_DIR)
require File.join(HELPERS_DIR, 'brewfile')

# ---------------------------------------------------------------------------
# Fixture helpers
# ---------------------------------------------------------------------------
def brewfile(content)
  Brewfile.from_string(content)
end

SIMPLE = <<~RUBY
  ## Formulae
  brew "git" # Distributed revision control system
  brew "wget" # Internet file retriever

  ## Casks
  cask "iterm2" # Terminal emulator
RUBY

MULTI_SECTION = <<~RUBY
  ## Formulae
  brew "git" # VCS

  ## Casks
  cask "alfred" # Launcher

  ## Formulae
  brew "zsh" # Shell
RUBY

COMMENTED_ENTRY = <<~RUBY
  ## Formulae
  # brew "git" # Distributed revision control system
  brew "wget" # Internet file retriever
RUBY

# ---------------------------------------------------------------------------
# Brewfile — type/header mapping
# ---------------------------------------------------------------------------
describe Brewfile do
  describe '.header_for_type' do
    it 'maps brew to Formulae'             do _(Brewfile.header_for_type('brew')).must_equal 'Formulae' end
    it 'maps cask to Casks'               do _(Brewfile.header_for_type('cask')).must_equal 'Casks' end
    it 'maps mas to MAS'                  do _(Brewfile.header_for_type('mas')).must_equal 'MAS' end
    it 'maps vscode to VS Code Extensions' do _(Brewfile.header_for_type('vscode')).must_equal 'VS Code Extensions' end
    it 'maps tap to Taps'                 do _(Brewfile.header_for_type('tap')).must_equal 'Taps' end
    it 'maps npm to NPM'                  do _(Brewfile.header_for_type('npm')).must_equal 'NPM' end
    it 'uses titlecased fallback for unknown types' do
      _(Brewfile.header_for_type('go')).must_equal 'Go Packages'
    end
  end

  describe '.type_for_header' do
    it 'maps Formulae to brew'             do _(Brewfile.type_for_header('Formulae')).must_equal 'brew' end
    it 'maps Casks to cask'               do _(Brewfile.type_for_header('Casks')).must_equal 'cask' end
    it 'maps NPM to npm'                  do _(Brewfile.type_for_header('NPM')).must_equal 'npm' end
    it 'returns nil for unknown headers'  do _(Brewfile.type_for_header('Unknown')).must_be_nil end
  end

  # ---------------------------------------------------------------------------
  # Parsing
  # ---------------------------------------------------------------------------
  describe '#entries' do
    it 'parses brew entries' do
      bf = brewfile(SIMPLE)
      brew_entries = bf.entries(types: ['brew'])
      _(brew_entries.map { |e| e[:name] }).must_equal %w[git wget]
    end

    it 'parses cask entries' do
      bf = brewfile(SIMPLE)
      cask_entries = bf.entries(types: ['cask'])
      _(cask_entries.map { |e| e[:name] }).must_equal %w[iterm2]
    end

    it 'parses npm entries' do
      bf = brewfile(<<~RUBY)
        ## NPM
        npm "eslint" # JavaScript linter
        npm "prettier" # Code formatter
      RUBY
      npm_entries = bf.entries(types: ['npm'])
      _(npm_entries.map { |e| e[:name] }).must_equal %w[eslint prettier]
    end

    it 'captures inline description' do
      bf = brewfile(SIMPLE)
      git = bf.entries.find { |e| e[:name] == 'git' }
      _(git[:description]).must_equal 'Distributed revision control system'
    end

    it 'marks commented-out entries as commented_out: true' do
      bf = brewfile(COMMENTED_ENTRY)
      git = bf.entries.find { |e| e[:name] == 'git' }
      _(git[:commented_out]).must_equal true
    end

    it 'marks active entries as commented_out: false' do
      bf = brewfile(SIMPLE)
      git = bf.entries.find { |e| e[:name] == 'git' }
      _(git[:commented_out]).must_equal false
    end
  end

  # ---------------------------------------------------------------------------
  # find
  # ---------------------------------------------------------------------------
  describe '#find' do
    it 'finds an active entry by name and type' do
      bf = brewfile(SIMPLE)
      _(bf.find(name: 'git', type: 'brew').length).must_equal 1
    end

    it 'finds a commented-out entry' do
      bf = brewfile(COMMENTED_ENTRY)
      matches = bf.find(name: 'git', type: 'brew')
      _(matches.length).must_equal 1
      _(matches.first.commented_out).must_equal true
    end

    it 'returns empty array when not found' do
      bf = brewfile(SIMPLE)
      _(bf.find(name: 'nonexistent', type: 'brew')).must_be_empty
    end

    it 'does not match wrong type' do
      bf = brewfile(SIMPLE)
      _(bf.find(name: 'git', type: 'cask')).must_be_empty
    end
  end

  # ---------------------------------------------------------------------------
  # add — already present
  # ---------------------------------------------------------------------------
  describe '#add already present' do
    it 'returns :already_present when package is active' do
      bf = brewfile(SIMPLE)
      _(bf.add(name: 'git', type: 'brew')).must_equal :already_present
    end

    it 'does not change the file when already present' do
      bf     = brewfile(SIMPLE)
      before = bf.to_s
      bf.add(name: 'git', type: 'brew')
      _(bf.to_s).must_equal before
    end
  end

  # ---------------------------------------------------------------------------
  # add — uncomment
  # ---------------------------------------------------------------------------
  describe '#add uncomment' do
    it 'returns :uncommented when package is commented out' do
      bf = brewfile(COMMENTED_ENTRY)
      _(bf.add(name: 'git', type: 'brew', description: 'VCS')).must_equal :uncommented
    end

    it 'removes the comment prefix from the line' do
      bf = brewfile(COMMENTED_ENTRY)
      bf.add(name: 'git', type: 'brew')
      entry = bf.find(name: 'git', type: 'brew').first
      _(entry.commented_out).must_equal false
    end
  end

  # ---------------------------------------------------------------------------
  # add — insert new entry
  # ---------------------------------------------------------------------------
  describe '#add insert' do
    it 'returns :added for a new package' do
      bf = brewfile(SIMPLE)
      _(bf.add(name: 'fzf', type: 'brew', description: 'Fuzzy finder')).must_equal :added
    end

    it 'inserts alphabetically before a later entry' do
      bf = brewfile(SIMPLE)
      bf.add(name: 'curl', type: 'brew', description: 'URL tool')
      names = bf.entries(types: ['brew']).map { |e| e[:name] }
      _(names.index('curl')).must_be :<, names.index('git')
    end

    it 'inserts alphabetically after an earlier entry' do
      bf = brewfile(SIMPLE)
      bf.add(name: 'zsh', type: 'brew', description: 'Shell')
      names = bf.entries(types: ['brew']).map { |e| e[:name] }
      _(names.index('wget')).must_be :<, names.index('zsh')
    end

    it 'creates a new section when no matching type section exists' do
      content = <<~RUBY
        ## Formulae
        brew "git" # VCS
      RUBY
      bf = brewfile(content)
      bf.add(name: 'iterm2', type: 'cask', description: 'Terminal')
      _(bf.to_s).must_include '## Casks'
      _(bf.to_s).must_include 'cask "iterm2"'
    end

    it 'new section header uses correct title case (Formulae not Brews)' do
      bf = brewfile("## Casks\ncask \"iterm2\" # Terminal\n")
      bf.add(name: 'git', type: 'brew', description: 'VCS')
      _(bf.to_s).must_include '## Formulae'
      _(bf.to_s).wont_include '## Brews'
    end

    it 'new section is separated from previous content by exactly one blank line' do
      content = "## Casks\ncask \"iterm2\" # Terminal"
      bf      = brewfile(content)
      bf.add(name: 'git', type: 'brew', description: 'VCS')
      lines = bf.to_s.lines.map(&:chomp)
      casks_idx = lines.index { |l| l.start_with?('cask') }
      brew_header_idx = lines.index('## Formulae')
      # Exactly one blank line between them
      between = lines[(casks_idx + 1)...brew_header_idx]
      _(between.length).must_equal 1
      _(between.first).must_be_empty
    end

    it 'does not add trailing blank lines after new section' do
      content = "## Casks\ncask \"iterm2\" # Terminal"
      bf      = brewfile(content)
      bf.add(name: 'git', type: 'brew', description: 'VCS')
      _(bf.to_s.rstrip).must_equal bf.to_s.chomp
    end

    it 'uses the bottommost section when multiple sections of same type exist' do
      bf = brewfile(MULTI_SECTION)
      bf.add(name: 'curl', type: 'brew', description: 'URL tool')
      lines = bf.to_s.lines.map(&:chomp)
      # 'zsh' is in the bottommost Formulae section; 'curl' must come after 'git'
      # in that same section
      curl_idx = lines.index { |l| l.include?('"curl"') }
      zsh_idx  = lines.index { |l| l.include?('"zsh"') }
      git_idx  = lines.rindex { |l| l.include?('"git"') }
      _(curl_idx).must_be :>, git_idx
      _(zsh_idx).wont_be_nil
    end

    it 'includes description as inline comment' do
      bf = brewfile("## Formulae\nbrew \"git\" # VCS\n")
      bf.add(name: 'fzf', type: 'brew', description: 'Fuzzy finder')
      _(bf.to_s).must_include 'fzf'
      _(bf.to_s).must_include '# Fuzzy finder'
    end

    it 'adds entry without comment when description is nil' do
      bf   = brewfile("## Formulae\nbrew \"git\" # VCS\n")
      bf.add(name: 'fzf', type: 'brew', description: nil)
      line = bf.to_s.lines.find { |l| l.include?('"fzf"') }
      _(line.chomp).must_equal 'brew "fzf"'
    end
  end

  # ---------------------------------------------------------------------------
  # remove
  # ---------------------------------------------------------------------------
  describe '#remove' do
    it 'returns :not_found when package is absent' do
      bf = brewfile(SIMPLE)
      _(bf.remove(name: 'nonexistent', type: 'brew')).must_equal :not_found
    end

    it 'returns :removed when package is present' do
      bf = brewfile(SIMPLE)
      _(bf.remove(name: 'git', type: 'brew')).must_equal :removed
    end

    it 'removes the entry from the output' do
      bf = brewfile(SIMPLE)
      bf.remove(name: 'git', type: 'brew')
      _(bf.to_s).wont_include '"git"'
    end

    it 'removes commented-out instances' do
      bf = brewfile(COMMENTED_ENTRY)
      bf.remove(name: 'git', type: 'brew')
      _(bf.to_s).wont_include '"git"'
    end

    it 'removes all instances when a package appears multiple times' do
      content = <<~RUBY
        ## Formulae
        brew "git" # VCS
        brew "wget" # Retriever

        ## Formulae
        brew "git" # VCS duplicate
      RUBY
      bf = brewfile(content)
      bf.remove(name: 'git', type: 'brew')
      _(bf.entries.none? { |e| e[:name] == 'git' }).must_equal true
    end

    it 'does not remove an entry of a different type' do
      content = "## Formulae\nbrew \"iterm2\" # Not the cask\n## Casks\ncask \"iterm2\" # Terminal\n"
      bf      = brewfile(content)
      bf.remove(name: 'iterm2', type: 'cask')
      _(bf.to_s).must_include 'brew "iterm2"'
    end

    it 'removes empty section header after last entry is removed' do
      content = "## Formulae\nbrew \"git\" # VCS\n\n## Casks\ncask \"iterm2\" # Terminal\n"
      bf      = brewfile(content)
      bf.remove(name: 'iterm2', type: 'cask')
      _(bf.to_s).wont_include '## Casks'
    end

    it 'does not leave consecutive blank lines after section removal' do
      content = "## Formulae\nbrew \"git\" # VCS\n\n## Casks\ncask \"iterm2\" # Terminal\n"
      bf      = brewfile(content)
      bf.remove(name: 'iterm2', type: 'cask')
      _(bf.to_s).wont_match(/\n{3,}/)
    end

    it 'does not remove section header when other entries of that type remain' do
      content = "## Casks\ncask \"alfred\" # Launcher\ncask \"iterm2\" # Terminal\n"
      bf      = brewfile(content)
      bf.remove(name: 'iterm2', type: 'cask')
      _(bf.to_s).must_include '## Casks'
    end
  end

  # ---------------------------------------------------------------------------
  # align_section
  # ---------------------------------------------------------------------------
  describe '#align_section' do
    it 'aligns # column to 1 space after longest token in section' do
      content = <<~RUBY
        ## Casks
        cask "fizbin" # Description of fizbin
        cask "foo" # Description of foo
      RUBY
      bf = brewfile(content)
      bf.align_section(type: 'cask')
      lines = bf.to_s.lines.select { |l| l.start_with?('cask') }.map(&:chomp)
      # "cask \"fizbin\"" is longest; "cask \"foo\"" should get extra spaces
      _(lines.find { |l| l.include?('"fizbin"') }).must_match(/cask "fizbin" # /)
      _(lines.find { |l| l.include?('"foo"') }).must_match(/cask "foo"\s{4}# /)
    end

    it 'does not touch entries in other sections' do
      content = <<~RUBY
        ## Formulae
        brew "bar" # Desc of bar
        brew "longername" # Desc of longername

        ## Casks
        cask "x" # Short
      RUBY
      bf     = brewfile(content)
      before = bf.to_s.lines.find { |l| l.include?('cask "x"') }.chomp
      bf.align_section(type: 'brew')
      after = bf.to_s.lines.find { |l| l.include?('cask "x"') }.chomp
      _(after).must_equal before
    end

    it 'aligns all sections independently' do
      content = <<~RUBY
        ## Formulae
        brew "bar" # Desc
        brew "longername" # Desc

        ## Casks
        cask "x" # Short
        cask "longer-cask" # Longer
      RUBY
      bf = brewfile(content)
      bf.align_section  # align all
      lines = bf.to_s.lines.map(&:chomp)

      formula_hashes = lines.select { |l| l.start_with?('brew') }.map { |l| l.index('#') }
      cask_hashes    = lines.select { |l| l.start_with?('cask') }.map { |l| l.index('#') }

      # All # within formulae section at same column
      _(formula_hashes.uniq.length).must_equal 1
      # All # within casks section at same column
      _(cask_hashes.uniq.length).must_equal 1
      # But the two columns need not be the same
    end
  end

  # ---------------------------------------------------------------------------
  # round-trip: to_s
  # ---------------------------------------------------------------------------
  describe '#to_s' do
    it 'round-trips a simple Brewfile without modification' do
      bf = brewfile(SIMPLE)
      _(bf.to_s).must_equal SIMPLE
    end
  end
end
