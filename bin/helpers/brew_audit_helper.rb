# brew_audit_helper.rb
# Computes the diff between installed Homebrew packages (Set A) and packages
# tracked in Brewfiles (Set B). Called by bin/brew_audit — not executable.
#
# Usage:
#   ruby helpers/brew_audit_helper.rb \
#     --installed=<brew_bundle_dump_output_file> \
#     --brewfiles=<path1>,<path2>,... \
#     [--types=brew,cask,...]
#
# Output (STDOUT): JSON array of diff objects:
#   [{ "name": "git", "type": "brew", "description": "...", "status": "+"|"-" }, ...]
#
# Exits non-zero on failure.

require 'json'
require_relative 'brewfile'

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
installed_file = nil
brewfile_paths = []
filter_types   = nil

ARGV.each do |arg|
  case arg
  when /\A--installed=(.+)\z/
    installed_file = $1
  when /\A--brewfiles=(.+)\z/
    brewfile_paths = $1.split(',')
  when /\A--types=(.+)\z/
    filter_types = $1.split(',')
  end
end

abort '--installed=<path> is required' unless installed_file
abort '--brewfiles=<paths> is required' if brewfile_paths.empty?
abort "Installed dump not found: #{installed_file}" unless File.exist?(installed_file)

# ---------------------------------------------------------------------------
# Parse brew bundle dump output → Set A (installed)
# ---------------------------------------------------------------------------
# brew bundle dump --describe produces lines like:
#   # Description of the package
#   brew "package-name"
# We treat the preceding comment as the description.

set_a = []
pending_desc = nil

File.readlines(installed_file, chomp: true).each do |raw|
  if raw.match?(/\A#/) && !raw.match?(/\A##/)
    pending_desc = raw.sub(/\A#\s*/, '').strip
    next
  end

  if (m = raw.match(/\A(brew|cask|mas|vscode|tap|npm)\s+"([^"]+)"/))
    type = m[1]
    name = m[2]
    next if filter_types && !filter_types.include?(type)
    set_a << { name: name, type: type, description: pending_desc }
  end

  pending_desc = nil
end

# ---------------------------------------------------------------------------
# Parse all Brewfiles → Set B (tracked)
# ---------------------------------------------------------------------------
# Deduplicate: prefer first uncommented; fall back to first commented.

seen_b   = {}   # "type:name" => hash
set_b_raw = []

brewfile_paths.each do |path|
  next unless File.exist?(path)
  bf = Brewfile.from_string(File.read(path), path: path)
  bf.entries.each do |e|
    next if filter_types && !filter_types.include?(e[:type])
    key = "#{e[:type]}:#{e[:name]}"
    existing = seen_b[key]
    if existing.nil?
      seen_b[key] = e
    elsif existing[:commented_out] && !e[:commented_out]
      seen_b[key] = e  # prefer uncommented
    end
  end
end

set_b = seen_b.values

# ---------------------------------------------------------------------------
# Compute diff
# ---------------------------------------------------------------------------
a_keys = set_a.map { |p| "#{p[:type]}:#{p[:name]}" }.to_set
b_keys = set_b.map { |p| "#{p[:type]}:#{p[:name]}" }.to_set

results = []

set_a.each do |p|
  key = "#{p[:type]}:#{p[:name]}"
  unless b_keys.include?(key)
    results << { 'name' => p[:name], 'type' => p[:type], 'description' => p[:description], 'status' => '+' }
  end
end

set_b.each do |p|
  key = "#{p[:type]}:#{p[:name]}"
  unless a_keys.include?(key)
    results << { 'name' => p[:name], 'type' => p[:type], 'description' => p[:description]&.to_s, 'status' => '-' }
  end
end

puts JSON.generate(results)
