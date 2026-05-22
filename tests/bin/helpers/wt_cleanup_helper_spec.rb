# tests/bin/helpers/wt_cleanup_helper_spec.rb
# Tests for bin/helpers/wt_cleanup_helper.rb
#
# Run with: ruby tests/bin/helpers/wt_cleanup_helper_spec.rb

require 'minitest/autorun'
require 'minitest/spec'
require 'json'
require 'stringio'

HELPERS_DIR = File.expand_path('../../../bin/helpers', __dir__) unless defined?(HELPERS_DIR)
require File.join(HELPERS_DIR, 'wt_cleanup_helper')

# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------
NOW = 1_700_001_000

WORKTREE_DIRTY = {
  'branch'      => 'feature-a',
  'path'        => '/tmp/repo.feature-a',
  'kind'        => 'worktree',
  'commit'      => {
    'sha'        => 'aaa',
    'short_sha'  => 'aaa1234',
    'message'    => "add feature A\n\nlong body",
    'timestamp'  => 1_700_000_000
  },
  'working_tree' => {
    'staged'    => true,
    'modified'  => true,
    'untracked' => true,
    'renamed'   => false,
    'deleted'   => false,
    'diff'      => { 'added' => 3, 'deleted' => 1 }
  },
  'main_state' => 'diverged',
  'main'       => { 'ahead' => 2, 'behind' => 1, 'diff' => { 'added' => 5, 'deleted' => 2 } },
  'remote'     => { 'name' => 'origin', 'branch' => 'feature-a', 'ahead' => 2, 'behind' => 0 },
  'worktree'   => { 'detached' => false },
  'is_main' => false, 'is_current' => true, 'is_previous' => false
}.freeze

BRANCH_INTEGRATED = {
  'branch' => 'old-cleanup',
  'kind'   => 'branch',
  'commit' => { 'sha' => 'bbb', 'short_sha' => 'bbb', 'message' => 'merged', 'timestamp' => 1_699_900_000 },
  'main_state'         => 'integrated',
  'integration_reason' => 'ancestor',
  'main'   => { 'ahead' => 0, 'behind' => 50 },
  'is_main' => false, 'is_current' => false, 'is_previous' => false
}.freeze

BRANCH_GONE_REMOTE = {
  'branch' => 'stale-remote',
  'kind'   => 'branch',
  'commit' => { 'sha' => 'ccc', 'short_sha' => 'ccc', 'message' => 'stale', 'timestamp' => 1_650_000_000 },
  'main_state' => 'unknown',
  'remote' => { 'name' => 'origin', 'branch' => 'stale-remote', 'gone' => true },
  'is_main' => false, 'is_current' => false, 'is_previous' => false
}.freeze

WORKTREE_CLEAN_MAIN = {
  'branch' => 'main',
  'path'   => '/tmp/repo',
  'kind'   => 'worktree',
  'commit' => { 'sha' => 'ddd', 'short_sha' => 'ddd', 'message' => 'tip', 'timestamp' => 1_700_000_500 },
  'working_tree' => {
    'staged' => false, 'modified' => false, 'untracked' => false, 'renamed' => false, 'deleted' => false,
    'diff' => { 'added' => 0, 'deleted' => 0 }
  },
  'main_state' => 'is_main',
  'remote' => { 'name' => 'origin', 'branch' => 'main', 'ahead' => 0, 'behind' => 0 },
  'is_main' => true, 'is_current' => false, 'is_previous' => false
}.freeze

LOCAL_ONLY_WORKTREE = {
  'branch' => 'no-remote',
  'path'   => '/tmp/repo.no-remote',
  'kind'   => 'worktree',
  'commit' => { 'sha' => 'eee', 'short_sha' => 'eee', 'message' => 'local', 'timestamp' => 1_700_000_900 },
  'working_tree' => {
    'staged' => false, 'modified' => false, 'untracked' => false, 'renamed' => false, 'deleted' => false,
    'diff' => { 'added' => 0, 'deleted' => 0 }
  },
  'main_state' => 'integrated',
  'integration_reason' => 'committed_trees_match',
  'is_main' => false, 'is_current' => false, 'is_previous' => false
}.freeze

ANSI = /\e\[[0-9;]*m/.freeze
def strip_ansi(str)
  str.to_s.gsub(ANSI, '')
end

# ---------------------------------------------------------------------------
# humanize_age
# ---------------------------------------------------------------------------
describe 'WtCleanupHelper.humanize_age' do
  it 'reports seconds when diff < 1 minute' do
    _(WtCleanupHelper.humanize_age(NOW - 30, now: NOW)).must_equal '30s'
  end

  it 'reports minutes' do
    _(WtCleanupHelper.humanize_age(NOW - (60 * 22), now: NOW)).must_equal '22m'
  end

  it 'reports hours' do
    _(WtCleanupHelper.humanize_age(NOW - (60 * 60 * 3), now: NOW)).must_equal '3h'
  end

  it 'reports days' do
    _(WtCleanupHelper.humanize_age(NOW - (60 * 60 * 24 * 2), now: NOW)).must_equal '2d'
  end

  it 'reports weeks' do
    _(WtCleanupHelper.humanize_age(NOW - (60 * 60 * 24 * 10), now: NOW)).must_equal '1w'
  end

  it 'reports months' do
    _(WtCleanupHelper.humanize_age(NOW - (60 * 60 * 24 * 60), now: NOW)).must_equal '2mo'
  end

  it 'reports years' do
    _(WtCleanupHelper.humanize_age(NOW - (60 * 60 * 24 * 400), now: NOW)).must_equal '1y'
  end

  it 'returns "-" when timestamp is nil' do
    _(WtCleanupHelper.humanize_age(nil, now: NOW)).must_equal '-'
  end

  it 'returns "0s" for future timestamps' do
    _(WtCleanupHelper.humanize_age(NOW + 100, now: NOW)).must_equal '0s'
  end
end

# ---------------------------------------------------------------------------
# remote_token
# ---------------------------------------------------------------------------
describe 'WtCleanupHelper.remote_token' do
  it 'returns local + gray when no remote tracking' do
    _(WtCleanupHelper.remote_token(LOCAL_ONLY_WORKTREE)).must_equal ['local', :gray]
  end

  it 'returns gone + magenta when remote was deleted upstream' do
    _(WtCleanupHelper.remote_token(BRANCH_GONE_REMOTE)).must_equal ['gone', :magenta]
  end

  it 'returns synced + green when in sync' do
    _(WtCleanupHelper.remote_token(WORKTREE_CLEAN_MAIN)).must_equal ['synced', :green]
  end

  it 'returns ↑N + yellow when ahead only' do
    _(WtCleanupHelper.remote_token(WORKTREE_DIRTY)).must_equal ['↑2', :yellow]
  end

  it 'returns ↓N + yellow when behind only' do
    entry = { 'remote' => { 'ahead' => 0, 'behind' => 3 } }
    _(WtCleanupHelper.remote_token(entry)).must_equal ['↓3', :yellow]
  end

  it 'returns diverged label + yellow when both' do
    entry = { 'remote' => { 'ahead' => 2, 'behind' => 5 } }
    _(WtCleanupHelper.remote_token(entry)).must_equal ['↕2/5', :yellow]
  end
end

# ---------------------------------------------------------------------------
# changes_token
# ---------------------------------------------------------------------------
describe 'WtCleanupHelper.changes_token' do
  it 'returns "-" + gray for branch-only entries' do
    _(WtCleanupHelper.changes_token(BRANCH_INTEGRATED)).must_equal ['-', :gray]
  end

  it 'returns clean + green when worktree is clean' do
    _(WtCleanupHelper.changes_token(WORKTREE_CLEAN_MAIN)).must_equal ['clean', :green]
  end

  it 'returns dirty + yellow when any working-tree flag is set' do
    _(WtCleanupHelper.changes_token(WORKTREE_DIRTY)).must_equal ['dirty', :yellow]
  end
end

# ---------------------------------------------------------------------------
# merged_token
# ---------------------------------------------------------------------------
describe 'WtCleanupHelper.merged_token' do
  it 'returns main + cyan for the main branch itself' do
    _(WtCleanupHelper.merged_token(WORKTREE_CLEAN_MAIN)).must_equal ['main', :cyan]
  end

  it 'returns merged + green for integrated branches (any reason)' do
    _(WtCleanupHelper.merged_token(BRANCH_INTEGRATED)).must_equal ['merged', :green]
  end

  it 'returns merged + green for squash-merged branches (committed_trees_match)' do
    _(WtCleanupHelper.merged_token(LOCAL_ONLY_WORKTREE)).must_equal ['merged', :green]
  end

  it 'returns unmerged + yellow for diverged / non-integrated states' do
    _(WtCleanupHelper.merged_token(WORKTREE_DIRTY)).must_equal ['unmerged', :yellow]
  end

  it 'returns ? + gray when main_state is missing' do
    _(WtCleanupHelper.merged_token({ 'is_main' => false })).must_equal ['?', :gray]
  end
end

# ---------------------------------------------------------------------------
# colorize / padded_token
# ---------------------------------------------------------------------------
describe 'WtCleanupHelper.colorize' do
  it 'wraps text in ANSI codes for the given color' do
    out = WtCleanupHelper.colorize('hi', :green)
    _(out).must_include 'hi'
    _(out).must_include "\e[32m"
    _(out).must_include "\e[0m"
  end

  it 'leaves text unchanged for unknown colors' do
    _(WtCleanupHelper.colorize('hi', :neon)).must_equal 'hi'
  end
end

describe 'WtCleanupHelper.padded_token' do
  it 'pads visible text to the given width before applying color' do
    out = WtCleanupHelper.padded_token(['ok', :green], 6)
    visible = strip_ansi(out)
    _(visible).must_equal 'ok    ' # 2 chars + 4 spaces
  end
end

# ---------------------------------------------------------------------------
# format_row
# ---------------------------------------------------------------------------
describe 'WtCleanupHelper.format_row' do
  it 'lays out: id | branch | remote | changes | merged | age | message' do
    row = WtCleanupHelper.format_row(WORKTREE_DIRTY, now: NOW)
    fields = row.split("\t").map { |f| strip_ansi(f).rstrip }
    _(fields[0]).must_equal 'feature-a'
    _(fields[1]).must_equal 'feature-a'
    _(fields[2]).must_equal '↑2'
    _(fields[3]).must_equal 'dirty'
    _(fields[4]).must_equal 'unmerged'
    _(fields[5]).must_equal '16m'
    _(fields[6]).must_equal 'add feature A'
  end

  it 'preserves ANSI color codes in the row' do
    row = WtCleanupHelper.format_row(WORKTREE_DIRTY, now: NOW)
    fields = row.split("\t")
    _(fields[2]).must_include "\e[33m" # remote ahead → yellow
    _(fields[3]).must_include "\e[33m" # dirty → yellow
    _(fields[4]).must_include "\e[33m" # unmerged → yellow
  end

  it 'shows green + merged for integrated branch-only entries' do
    row = WtCleanupHelper.format_row(BRANCH_INTEGRATED, now: NOW)
    fields = row.split("\t").map { |f| strip_ansi(f).rstrip }
    _(fields[0]).must_equal 'old-cleanup'
    _(fields[2]).must_equal 'local'    # no remote tracking on this fixture
    _(fields[3]).must_equal '-'        # not a worktree
    _(fields[4]).must_equal 'merged'   # main_state == integrated
  end

  it 'shows gone + magenta when remote was deleted upstream' do
    row = WtCleanupHelper.format_row(BRANCH_GONE_REMOTE, now: NOW)
    raw_fields = row.split("\t")
    fields = raw_fields.map { |f| strip_ansi(f).rstrip }
    _(fields[2]).must_equal 'gone'
    _(raw_fields[2]).must_include "\e[35m"
  end
end

# ---------------------------------------------------------------------------
# preview
# ---------------------------------------------------------------------------
describe 'WtCleanupHelper.preview' do
  it 'includes branch, kind, path, commit, working tree, main, remote, flags' do
    out = WtCleanupHelper.preview(WORKTREE_DIRTY, now: NOW)
    _(out).must_include 'Branch:   feature-a'
    _(out).must_include 'Kind:     worktree'
    _(out).must_include 'Path:     /tmp/repo.feature-a'
    _(out).must_include 'Commit:   aaa1234'
    _(out).must_include 'Working tree:'
    _(out).must_include 'modified:  yes'
    _(out).must_include 'staged:    yes'
    _(out).must_include 'untracked: yes'
    _(out).must_include 'diff:      +3 -1'
    _(out).must_include 'vs main:  ↑2  ↓1'
    _(out).must_include 'State:    diverged'
    _(out).must_include 'vs origin/feature-a: ↑2  ↓0'
    _(out).must_include 'Flags:    current'
  end

  it 'omits worktree section for branch-only entries and surfaces reason' do
    out = WtCleanupHelper.preview(BRANCH_INTEGRATED, now: NOW)
    _(out).wont_include 'Working tree:'
    _(out).must_include 'Branch:   old-cleanup'
    _(out).must_include 'Kind:     branch'
    _(out).must_include 'State:    integrated'
    _(out).must_include 'Reason:   ancestor'
  end

  it 'reports a gone remote' do
    out = WtCleanupHelper.preview(BRANCH_GONE_REMOTE, now: NOW)
    _(out).must_include 'vs origin/stale-remote: gone'
  end
end

# ---------------------------------------------------------------------------
# run
# ---------------------------------------------------------------------------
describe 'WtCleanupHelper.run' do
  let(:json_input) { JSON.generate([WORKTREE_DIRTY, BRANCH_INTEGRATED, BRANCH_GONE_REMOTE]) }

  it 'format mode emits one row per entry, branch in field 1' do
    stdout = StringIO.new
    rc = WtCleanupHelper.run(['format'], stdin: StringIO.new(json_input), stdout: stdout, now: NOW)
    _(rc).must_equal 0
    rows = stdout.string.lines.map(&:chomp)
    _(rows.length).must_equal 3
    _(rows[0]).must_match(/\Afeature-a\t/)
    _(rows[1]).must_match(/\Aold-cleanup\t/)
    _(rows[2]).must_match(/\Astale-remote\t/)
  end

  it 'preview mode finds the entry by branch name' do
    stdout = StringIO.new
    rc = WtCleanupHelper.run(['preview', 'old-cleanup'], stdin: StringIO.new(json_input), stdout: stdout, now: NOW)
    _(rc).must_equal 0
    _(stdout.string).must_include 'Branch:   old-cleanup'
  end

  it 'preview mode fails when the branch is missing' do
    stderr = StringIO.new
    rc = WtCleanupHelper.run(['preview', 'nope'], stdin: StringIO.new(json_input), stdout: StringIO.new, stderr: stderr, now: NOW)
    _(rc).must_equal 1
    _(stderr.string).must_include 'No entry found'
  end

  it 'preview mode fails without a branch arg' do
    stderr = StringIO.new
    rc = WtCleanupHelper.run(['preview'], stdin: StringIO.new(json_input), stdout: StringIO.new, stderr: stderr, now: NOW)
    _(rc).must_equal 1
    _(stderr.string).must_include 'Usage'
  end

  it 'unknown mode prints usage and fails' do
    stderr = StringIO.new
    rc = WtCleanupHelper.run(['nope'], stdin: StringIO.new('[]'), stdout: StringIO.new, stderr: stderr)
    _(rc).must_equal 1
    _(stderr.string).must_include 'Usage'
  end
end
