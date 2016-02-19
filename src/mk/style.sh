detect_style() {
	local style=noop

	if [ -x $MK_DIST/configure ]; then
		style=configure
	elif [ -r $MK_DIST/Makefile ] || [ -r $MK_DIST/makefile ]; then
		style=make
	fi
		
	printf '%s' $style
}

run_style() {
	local func=$1
	local style=$PKG_STYLE
	[ "$style" ] || style=$(detect_style)

	progress $func "using $style"

	. $_SRC/mk/style_${style}.sh

	{
		if [ "$(command -v pre_$func)" ]; then
			pre_$func
		fi

		if [ "$(command -v do_$func)" ]; then
			do_$func
		else
			${style}_default_$func
		fi

		if [ "$(command -v post_$func)" ]; then
			post_$func
		fi
	} >&3 2>&3
}
