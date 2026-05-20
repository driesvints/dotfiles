# brewfile.rb
# Parses, manipulates, and writes Homebrew Brewfiles.
#
# Usage (as a library):
#   require_relative 'brewfile'
#   bf = Brewfile.new(path)
#   bf.add(name: 'git', type: 'brew', description: 'Distributed revision control system')
#   bf.remove(name: 'wget', type: 'brew')
#   bf.write(path)
#
# Not executable — called via `require_relative` from brew_add, brew_remove,
# and brew_audit.

class Brewfile
  # Maps Brewfile type keywords to section header labels and back.
  TYPE_TO_HEADER = {
    'brew'   => 'Formulae',
    'cask'   => 'Casks',
    'mas'    => 'MAS',
    'vscode' => 'VS Code Extensions',
    'tap'    => 'Taps',
    'npm'    => 'NPM',
  }.freeze

  HEADER_TO_TYPE = TYPE_TO_HEADER.invert.freeze

  # Returns the section header string for a given type keyword.
  # Falls back to "<Titlecased Type> Packages" for unknown types.
  def self.header_for_type(type)
    TYPE_TO_HEADER[type] || "#{type.split('-').map(&:capitalize).join(' ')} Packages"
  end

  # Returns the type keyword for a given section header string, or nil.
  def self.type_for_header(header)
    HEADER_TO_TYPE[header]
  end

  # Represents one parsed line from a Brewfile.
  # kind: :blank, :comment, :section_header, :entry, :other
  Line = Struct.new(:raw, :kind, :entry_type, :entry_name, :entry_description, :commented_out, :inline_comment)

  attr_reader :lines

  def initialize(path)
    @path  = path
    @lines = parse(File.read(path))
  end

  # Alternate constructor from a raw string (useful for tests).
  def self.from_string(content, path: '(string)')
    obj       = allocate
    obj.instance_variable_set(:@path, path)
    obj.instance_variable_set(:@lines, obj.send(:parse, content))
    obj
  end

  # Returns all entry lines for (name, type), including commented-out ones.
  def find(name:, type:)
    @lines.select do |l|
      l.kind == :entry && l.entry_type == type && l.entry_name == name
    end
  end

  # Adds a package to the Brewfile.
  # - If already present and NOT commented out → no-op (returns :already_present)
  # - If present but commented out → uncomments (returns :uncommented)
  # - Otherwise inserts alphabetically in the bottommost matching section,
  #   or creates a new section at EOF (returns :added)
  def add(name:, type:, description: nil)
    existing = find(name: name, type: type)
    active   = existing.reject(&:commented_out)

    return :already_present unless active.empty?

    if (commented = existing.select(&:commented_out)).any?
      uncomment_entry(commented.last)
      align_section(type: type)
      return :uncommented
    end

    insert_entry(name: name, type: type, description: description)
    align_section(type: type)
    :added
  end

  # Removes ALL instances of a package (commented or not) from the Brewfile.
  # Cleans up empty sections after removal. Returns :removed or :not_found.
  def remove(name:, type:)
    targets = find(name: name, type: type)
    return :not_found if targets.empty?

    targets.each { |l| @lines.delete(l) }
    cleanup_empty_sections
    align_section(type: type)
    :removed
  end

  # Aligns the inline `#` comment column within all sections of a given type.
  # The `#` is placed so that:
  #   - there is at most 1 space after the longest package token in the section
  #   - every other entry has at least 1 space before its `#`
  # Sections of OTHER types are not touched.
  # If type is nil, aligns all sections.
  def align_section(type: nil)
    each_section do |section_lines, section_type|
      next if type && section_type != type

      # Collect only uncommented entry lines that have inline comments.
      commentable = section_lines.select { |l| l.kind == :entry && !l.commented_out && l.inline_comment }
      next if commentable.empty?

      max_token_len = commentable.map { |l| entry_token(l).length }.max

      commentable.each do |l|
        token  = entry_token(l)
        spaces = (max_token_len - token.length) + 1
        l.raw  = "#{token} #{' ' * (spaces - 1)}# #{l.inline_comment}"
      end
    end
  end

  # Serializes lines back to a string.
  # split("\n", -1) preserves a trailing newline as a trailing empty element,
  # so join("\n") faithfully reconstructs the original — no suffix needed.
  def to_s
    @lines.map(&:raw).join("\n")
  end

  # Writes the Brewfile back to disk.
  def write(path = @path)
    File.write(path, to_s)
  end

  # Returns a flat array of entry hashes for all (or filtered) types.
  # Each hash: { name:, type:, description:, commented_out: }
  def entries(types: nil)
    @lines.select { |l| l.kind == :entry }.filter_map do |l|
      next if types && !Array(types).include?(l.entry_type)
      { name: l.entry_name, type: l.entry_type, description: l.entry_description, commented_out: l.commented_out }
    end
  end

  private

  # -------------------------------------------------------------------------
  # Parsing
  # -------------------------------------------------------------------------

  ENTRY_RE = /\A(\s*#\s*)?(brew|cask|mas|vscode|tap|npm)\s+"([^"]+)"(?:\s*,\s*id:\s*(\d+))?(?:\s+#\s*(.*))?\z/

  def parse(content)
    content.split("\n", -1).map do |raw|
      parse_line(raw)
    end
  end

  def parse_line(raw)
    line = Line.new(raw)

    if raw.strip.empty?
      line.kind = :blank
      return line
    end

    if (m = raw.match(ENTRY_RE))
      line.kind             = :entry
      line.commented_out    = !m[1].nil?
      line.entry_type       = m[2]
      line.entry_name       = m[3]
      line.inline_comment   = m[5]&.strip
      line.entry_description = line.inline_comment
      return line
    end

    if raw.match?(/\A##\s+\S/)
      line.kind = :section_header
      return line
    end

    line.kind = raw.start_with?('#') ? :comment : :other
    line
  end

  # -------------------------------------------------------------------------
  # Section iteration
  # -------------------------------------------------------------------------

  # Yields (array_of_lines, type_string) for each section (delimited by
  # ## headers). Lines before any header get type nil.
  def each_section
    current_type  = nil
    current_lines = []

    @lines.each do |l|
      if l.kind == :section_header
        yield current_lines, current_type unless current_lines.empty?
        current_type  = self.class.type_for_header(header_text(l)) || current_type
        current_lines = [l]
      else
        current_lines << l
      end
    end

    yield current_lines, current_type unless current_lines.empty?
  end

  def header_text(line)
    line.raw.sub(/\A##\s+/, '').strip
  end

  # -------------------------------------------------------------------------
  # Insertion
  # -------------------------------------------------------------------------

  def insert_entry(name:, type:, description: nil)
    new_line = build_entry_line(name: name, type: type, description: description)

    # Find the bottommost section of the matching type.
    last_section_end = find_last_section_end(type)

    if last_section_end
      insert_alphabetically_at(new_line, last_section_end[:start], last_section_end[:end], type)
    else
      append_new_section(new_line, type)
    end
  end

  def find_last_section_end(type)
    # Returns { start: index_after_header, end: last_entry_index } for the
    # bottommost section matching type.
    result     = nil
    in_section = false
    sec_start  = nil

    @lines.each_with_index do |l, i|
      if l.kind == :section_header
        sec_type = self.class.type_for_header(header_text(l))
        if sec_type == type
          in_section = true
          sec_start  = i + 1
        else
          if in_section
            # End of current matching section
            result     = { start: sec_start, end: i - 1 }
          end
          in_section = false
        end
      end
    end

    if in_section
      result = { start: sec_start, end: @lines.length - 1 }
    end

    result
  end

  def insert_alphabetically_at(new_line, sec_start, sec_end, type)
    # Find insertion point: first entry line whose name > new_line.entry_name
    entry_indices = (sec_start..sec_end).select { |i| @lines[i].kind == :entry && @lines[i].entry_type == type }

    insert_before = entry_indices.find { |i| @lines[i].entry_name > new_line.entry_name }

    if insert_before
      @lines.insert(insert_before, new_line)
    else
      # Append after last entry in the section (before trailing blanks/next header)
      last_entry_idx = entry_indices.last
      insert_at = last_entry_idx ? last_entry_idx + 1 : sec_end + 1
      @lines.insert(insert_at, new_line)
    end
  end

  def append_new_section(new_line, type)
    header_line = Line.new("## #{self.class.header_for_type(type)}", :section_header)
    blank_line  = Line.new('', :blank)

    # Strip trailing blank lines from end of file before appending.
    @lines.pop while @lines.last&.kind == :blank

    @lines << blank_line
    @lines << header_line
    @lines << new_line
  end

  def build_entry_line(name:, type:, description: nil)
    raw = if description && !description.strip.empty?
      "#{type} \"#{name}\" # #{description.strip}"
    else
      "#{type} \"#{name}\""
    end
    l = parse_line(raw)
    l
  end

  # -------------------------------------------------------------------------
  # Uncommenting
  # -------------------------------------------------------------------------

  def uncomment_entry(line)
    line.raw          = line.raw.sub(/\A\s*#\s*/, '')
    line.commented_out = false
    # Re-parse inline comment
    if (m = line.raw.match(ENTRY_RE))
      line.inline_comment    = m[5]&.strip
      line.entry_description = line.inline_comment
    end
  end

  # -------------------------------------------------------------------------
  # Empty section cleanup
  # -------------------------------------------------------------------------

  def cleanup_empty_sections
    # Collect indices of section headers whose sections have no entry lines.
    to_delete = Set.new

    each_section do |section_lines, _type|
      next unless section_lines.first&.kind == :section_header
      has_entries = section_lines.any? { |l| l.kind == :entry }
      unless has_entries
        section_lines.each { |l| to_delete << l }
      end
    end

    @lines.reject! { |l| to_delete.include?(l) }

    # Normalize multiple consecutive blank lines to at most one.
    result = []
    prev_blank = false
    @lines.each do |l|
      if l.kind == :blank
        result << l unless prev_blank
        prev_blank = true
      else
        prev_blank = false
        result << l
      end
    end
    @lines = result

    # Strip trailing blank lines.
    @lines.pop while @lines.last&.kind == :blank
  end

  # -------------------------------------------------------------------------
  # Alignment helpers
  # -------------------------------------------------------------------------

  # Returns the full token portion of an entry line (everything before the comment).
  # e.g. `brew "git"` or `cask "visual-studio-code"`
  def entry_token(line)
    line.raw.sub(/\s*#.*\z/, '').rstrip
  end
end

require 'set'
