# Use command history.
# Assuming that different projects have different locations, keeping the history
# file local helps differentiate the commands for different projects.
set history filename ./.gdb_history
set history save on
set history size 100000

# Allow completion from history.
set history expansion on
