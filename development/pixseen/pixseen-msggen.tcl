#!/bin/sh
# the next line restarts using tclsh \
exec tclsh8.5 "$0" "$@"

encoding system {utf-8}

set fd [open pixseen.tcl r]
set data [read $fd]
close $fd

set msgList {}
foreach {- item} [regexp -all -inline -- {\[mc \{([^\}]+)\}} $data] {
	if {[lsearch -exact $msgList $item] == -1} {
		lappend msgList $item
	}
}

# generate en.msg

set fd [open pixseen-msgs/en.msg w]
fconfigure $fd -translation lf -encoding {utf-8}
puts $fd "# en.msg - automatically generated by pixseen-msggen.tcl on [clock format [clock seconds] -timezone UTC]\n"
puts $fd "namespace eval ::pixseen \{"
puts $fd "\tvariable lang \"en\""
foreach item $msgList {
	puts $fd "\n\tmcset \$lang \\"
	puts $fd "\t\t\{$item\} \\"
	puts $fd "\t\t\{$item\}"
}
puts $fd "\n\}"
close $fd

# generate en_US_bork.msg

proc chef {args} {
	set subs [list {a([nu])} {u\1}\
	{A([nu])} {U\1}\
	{a\Y} e\
	{A\Y} E\
	{en\y} ee\
	{\Yew} oo\
	{\Ye\y} e-a\
	{\ye} i\
	{\yE} I\
	{\Yf} ff\
	{\Yir} ur\
	{(\w+?)i(\w+?)$} {\1ee\2}\
	{\Yow} oo\
	{\yo} oo\
	{\yO} Oo\
	{^the$} zee\
	{^The$} Zee\
	{th\y} t\
	{\Ytion} shun\
	{\Yu} {oo}\
	{\YU} {Oo}\
	v f\
	V F\
	w w\
	W W\
	{([a-z])[.]} {\1. Bork Bork Bork!}]
	foreach word $args {
		foreach {exp subSpec} $subs {
			set word [regsub -all -- $exp $word $subSpec]
#			puts "$exp || $subSpec -> $word"
		}
		lappend retval $word
	}
	return [join $retval]
}

set fd [open pixseen-msgs/en_us_bork.msg w]
fconfigure $fd -translation lf -encoding {utf-8}
puts $fd "# en_US_bork.msg - automatically generated by pixseen-msggen.tcl on [clock format [clock seconds] -timezone UTC]\n"
puts $fd "namespace eval ::pixseen \{"
puts $fd "\tvariable lang \"en_us_bork\""
foreach item $msgList {
	puts $fd "\n\tmcset \$lang \\"
	puts $fd "\t\t\{$item\} \\"
	puts $fd "\t\t\{[chef $item]\}"
}
puts $fd "\n\}"

close $fd

