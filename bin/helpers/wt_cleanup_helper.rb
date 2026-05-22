# wt_cleanup_helper.rb
# Formats `wt list --full --branches --format json` output for an fzf picker.
# Called by bin/wt_cleanup — not executable.
#
# Modes:
#   format       Reads wt list JSON from STDIN, prints one tab-separated row
#                per entry on STDOUT. Columns:
#                  <id>\t<symbols>\t<branch>\t<kind>\t<main_state>\t<remote>\t<dirty>\t<age>\t<message>
#                The <id> is the branch name and is used by the preview mode
#                to find the matching entry.
#
#   preview      Reads wt list JSON from STDIN, then renders a detailed
#                description of the entry whose branch matches ARGV[1].
#
# Usage:
#   wt list --full --branches --format json | ruby wt_cleanup_helper.rb format
#   wt list --full --branches --format json | ruby wt_cleanup_helper.rb preview <branch>

require 'json'

module WtCleanupHelper
  module_function

  AGE_UNITS = [
    [60 * 60 * 24 * 365, 'y'],
    [60 * 60 * 24 * 30,  'mo'],
    [60 * 60 * 24 * 7,   'w'],
    [60 * 60 * 24,       'd'],
    [60 * 60,            'h'],
    [60,                 'm']
  ].freeze

  COLORS = {
    reset:   "\e[0m",
    bold:    "\e[1m",
    red:     "\e[31m",
    green:   "\e[32m",
    yellow:  "\e[33m",
    blue:    "\e[34m",
    magenta: "\e[35m",
    cyan:    "\e[36m",
    gray:    "\e[90m"
  }.freeze

  # Humanize a unix timestamp into a short relative-age string like "22m", "3h", "2d".
  def humanize_age(timestamp, now: Time.now.to_i)
    return '-' unless timestamp.is_a?(Integer)
    diff = now - timestamp
    return '0s' if diff <= 0
    AGE_UNITS.each do |seconds, suffix|
      return "#{diff / seconds}#{suffix}" if diff >= seconds
    end
    "#{diff}s"
  end

  def colorize(text, color)
    return text if color.nil? || !COLORS.key?(color)
    "#{COLORS[color]}#{text}#{COLORS[:reset]}"
  end

  # Pad a [text, color] token to fixed visible width, then apply color.
  # ANSI codes are applied after padding so visible alignment is preserved.
  def padded_token(token, width)
    text, color = token
    colorize(text.to_s.ljust(width), color)
  end

  # [text, color] for remote tracking state.
  #   synced  — local matches remote
  #   ↑N/↓N/↕N/M — ahead/behind/diverged
  #   gone    — remote branch deleted upstream
  #   local   — no remote tracking
  def remote_token(entry)
    remote = entry['remote']
    return ['local', :gray]     unless remote
    return ['gone', :magenta]   if remote['gone']
    ahead  = remote['ahead']  || 0
    behind = remote['behind'] || 0
    return ['synced', :green]   if ahead.zero? && behind.zero?
    return ["↕#{ahead}/#{behind}", :yellow] if ahead.positive? && behind.positive?
    return ["↑#{ahead}", :yellow] if ahead.positive?
    ["↓#{behind}", :yellow]
  end

  # [text, color] for uncommitted changes state.
  #   clean   — nothing modified/staged/untracked
  #   dirty   — anything in the working tree changed
  #   -       — no worktree (branch-only entry)
  def changes_token(entry)
    return ['-', :gray] unless entry['kind'] == 'worktree'
    wt = entry['working_tree'] || {}
    dirty = wt['modified'] || wt['staged'] || wt['untracked'] || wt['renamed'] || wt['deleted']
    dirty ? ['dirty', :yellow] : ['clean', :green]
  end

  # [text, color] for merge state relative to main.
  # Worktrunk's `integrated` covers fast-forward, regular merge, squash merge,
  # cherry-pick, and content-equivalent commits — so any "integrated" → merged.
  def merged_token(entry)
    return ['main', :cyan] if entry['is_main']
    case entry['main_state']
    when 'integrated' then ['merged', :green]
    when nil, ''      then ['?', :gray]
    else                   ['unmerged', :yellow]
    end
  end

  # Shorten the commit message to the first line, truncated to width.
  def short_message(message, width: 60)
    return '-' unless message.is_a?(String) && !message.empty?
    line = message.lines.first.to_s.strip
    line.length > width ? "#{line[0, width - 1]}…" : line
  end

  # Stable identifier used by fzf to round-trip selection through the preview
  # pane and back to the shell. Branch name is unique within a repo.
  def id_for(entry)
    entry['branch'].to_s
  end

  # Single row for the fzf picker.
  # Columns: id | branch | remote | changes | merged | age | message
  # The remote/changes/merged tokens are colored and padded to fixed visible
  # widths so they align across rows despite ANSI escape codes.
  def format_row(entry, now: Time.now.to_i)
    [
      id_for(entry),
      entry['branch'].to_s.ljust(40),
      padded_token(remote_token(entry),  9),
      padded_token(changes_token(entry), 5),
      padded_token(merged_token(entry),  8),
      humanize_age(entry.dig('commit', 'timestamp'), now: now).ljust(5),
      short_message(entry.dig('commit', 'message'))
    ].join("\t")
  end

  # Full preview text for a single entry.
  def preview(entry, now: Time.now.to_i)
    lines = []
    lines << "Branch:   #{entry['branch']}"
    lines << "Kind:     #{entry['kind']}"
    lines << "Path:     #{entry['path']}" if entry['path']

    commit = entry['commit'] || {}
    if commit['short_sha']
      lines << ''
      lines << "Commit:   #{commit['short_sha']}  (#{humanize_age(commit['timestamp'], now: now)} ago)"
      lines << "Message:  #{short_message(commit['message'], width: 80)}"
    end

    if entry['kind'] == 'worktree'
      wt = entry['working_tree'] || {}
      diff = wt['diff'] || {}
      lines << ''
      lines << 'Working tree:'
      lines << "  modified:  #{wt['modified']  ? 'yes' : 'no'}"
      lines << "  staged:    #{wt['staged']    ? 'yes' : 'no'}"
      lines << "  untracked: #{wt['untracked'] ? 'yes' : 'no'}"
      lines << "  renamed:   #{wt['renamed']   ? 'yes' : 'no'}"
      lines << "  deleted:   #{wt['deleted']   ? 'yes' : 'no'}"
      lines << "  diff:      +#{diff['added'] || 0} -#{diff['deleted'] || 0}"
      worktree = entry['worktree'] || {}
      lines << "  detached:  #{worktree['detached'] ? 'yes' : 'no'}" if worktree.key?('detached')
    end

    main = entry['main']
    if main
      lines << ''
      lines << "vs main:  ↑#{main['ahead'] || 0}  ↓#{main['behind'] || 0}"
      mdiff = main['diff'] || {}
      lines << "  diff:    +#{mdiff['added'] || 0} -#{mdiff['deleted'] || 0}" if mdiff['added'] || mdiff['deleted']
    end

    if entry['main_state']
      lines << "State:    #{entry['main_state'].to_s.tr('_', ' ')}"
      lines << "Reason:   #{entry['integration_reason']}" if entry['integration_reason']
    end

    remote = entry['remote']
    if remote
      lines << ''
      label = "#{remote['name'] || 'remote'}/#{remote['branch'] || entry['branch']}"
      if remote['gone']
        lines << "vs #{label}: gone"
      else
        lines << "vs #{label}: ↑#{remote['ahead'] || 0}  ↓#{remote['behind'] || 0}"
      end
    end

    lines << ''
    flags = []
    flags << 'main'    if entry['is_main']
    flags << 'current' if entry['is_current']
    flags << 'previous' if entry['is_previous']
    lines << "Flags:    #{flags.empty? ? '-' : flags.join(', ')}"

    lines.join("\n")
  end

  def run(argv, stdin: $stdin, stdout: $stdout, stderr: $stderr, now: Time.now.to_i)
    mode = argv[0]
    case mode
    when 'format'
      data = JSON.parse(stdin.read)
      data.each { |entry| stdout.puts format_row(entry, now: now) }
      0
    when 'preview'
      branch = argv[1]
      if branch.nil? || branch.empty?
        stderr.puts 'Usage: wt_cleanup_helper.rb preview <branch>'
        return 1
      end
      data = JSON.parse(stdin.read)
      entry = data.find { |e| e['branch'].to_s == branch }
      if entry.nil?
        stderr.puts "No entry found for branch: #{branch}"
        return 1
      end
      stdout.puts preview(entry, now: now)
      0
    else
      stderr.puts 'Usage: wt_cleanup_helper.rb {format|preview <branch>}'
      1
    end
  end
end

if $PROGRAM_NAME == __FILE__
  exit WtCleanupHelper.run(ARGV)
end
