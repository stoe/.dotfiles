# Self-derive DFH from this file's real location instead of hardcoding a path.
# ~/.config is a symlink to $DFH/config, so resolving this file's real path
# and walking up three directories (conf.d -> fish -> config -> DFH) recovers
# the repo root regardless of where it's cloned.
set -gx DFH (realpath (dirname (status current-filename))/../../..)
