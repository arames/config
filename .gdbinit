# Custom gdbinit.
# Use `help user`
# A lot of stuff is imported from
# https://github.com/gdbinit/Gdbinit/blob/master/gdbinit

# Documentation pointers:
# Convenience variables:
# 	https://sourceware.org/gdb/current/onlinedocs/gdb/Convenience-Vars.html

# General options =========================================================={{{1
# Use command history.
# Assuming that different projects have different locations, keeping the history
# file local helps differentiate the commands for different projects.
set history filename ./.gdb_history
set history save on
set history size 100000

# Allow completion from history.
set history expansion on


# Helpers =================================================================={{{1

define msg_error
	printf "=== ERROR (gdbinit) ========================================\n"
	if $argc > 0
		echo $arg0
	end
	printf "==================================== (gdbinit) ERROR END ===\n"
end
document msg_error
[utils function] Syntax: msg_error <string>
| Print <string>, surrounded by an error wrapper.
end

# Architecture configuration ==============================================={{{1

# Set to 1 to have ARM as the default debugging target.
# Use the `arm` and `intel` commands to switch between debugging target.
set $ARM = 0
set $INTEL = 1

define check_arch_conf
	if $ARM + $INTEL > 1
		msg_error "More than one debugging architecture configured."
	end
end
document check_arch_conf
[utils function] Syntax: check_arch_conf
| Check that the gdb scripts debugging arch configuration is correct.
end

define arm
	$INTEL = 0
	$ARM = 1
end
document arm
Syntax: arm
| Set the debbugging architecture to ARM.
end

define intel
	$INTEL = 1
	$ARM = 0
end
document intel
Syntax: intel
| Set the debbugging architecture to Intel.
end

check_arch_conf

# Other configuration ======================================================{{{1

# Color codes.
set $BLACK = 0
set $RED = 1
set $GREEN = 2
set $YELLOW = 3
set $BLUE = 4
set $MAGENTA = 5
set $CYAN = 6
set $WHITE = 7


define bpl
info breakpoints
end
document bpl
Syntax: bpl
| List all breakpoints. (Alias for `info breakpoints`.)
end


define disasm
	set $disasm_n = 10
	set $disasm_address = $pc
	if $argc >= 1
		set $disasm_n = $arg0
	end
	if $argc >= 2
		set $disasm_address = $arg1
	end
	eval "x /%di $disasm_address", $disasm_n
end
document disasm
Syntax: disasm [n=10] [address=$pc]
| Disassemble <n> instructions at <address>
end


define skip
	set $skip_n = 1
	if $argc >= 1
		set $skip_n = $arg0
	end
	printf "Skipping down to\n"
	disasm $skip_n+1
	# The $_ convenience variable is set by the `x` command in the disasm
	# function.
	set $pc = $_
	printf "Now at\n"
	disasm 1
end
document skip
Syntax: skip [n=1]
| Skip over the next <n> instructions. Useful to execute past a breakpoint.
end


define skipc
	set $skip_n = 1
	if $argc >= 1
		set $skip_n = $arg0
	end
	skip $skip_n
	printf "Continuing execution from there\n"
	continue
end
document skipc
Syntax: skipc [n=1]
| Skip over the next <n> instructions and continue execution from there.
| See also the `skip` command.
end


# .vimrc specific options =================================================={{{1
# vim: set foldmethod=marker:
