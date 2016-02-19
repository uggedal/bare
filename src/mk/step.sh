is_step() {
	[ "$(command -v step_$1)" ]
}

is_host_step() {
	local step=$1
	local s

	for s in $MK_HOST_STEPS; do
		if [ "$s" = "$step" ]; then
			return 0
		fi
	done

	return 1
}

_exec_step() {
	local step=$1
	local log=$MK_LOG/${step}.log
	local e

	if [ -f $MK_BUILD_ROOT/.${step}.done ]; then
		progress $step "'$PKG_NAME' cached"
	else
		if is_host_step $step || ! use_contain; then
			mkdir -p $MK_LOG
			exec 3> $log
			step_$step || {
				e=$?
				tail -n20 $log
				exit $e
			}
			touch $MK_BUILD_ROOT/.${step}.done
			[ -s "$log" ] || rm $MK_LOG/${step}.log
		else
			contain_mk -n$MK_FLAGS $step $PKG_NAME
		fi
	fi
}

_run_step_for_pkg() {
	local step=$1
	local pkg=$2
	local s

	read_pkg $pkg

	if [ $step = pkg ] &&
		[ "$MK_FORCE" != yes ] &&
		[ -s $_REPO/${PKG_QUALIFIED_NAME}$PKG_EXT ]; then
		progress pkg "'$PKG_NAME' complete"
		return
	fi

	if [ "$MK_NO_STEP_DEP" ]; then
		_exec_step $step
	else
		for s in $MK_STEPS; do
			_exec_step $s

			if [ "$step" = "$s" ]; then
				break
			fi
		done

		if [ $step = pkg ] && [ "$MK_KEEP" != yes ]; then
			if use_contain; then
				contain_mk clean $PKG_NAME
				_clean_contain
			else
				run_cmd clean $PKG_NAME
			fi
		fi
	fi
}

_gen_deps_makefile() {
	local all deps p pr d dr

	for p in $(list_pkgs); do
		if [ "$MK_FORCE" ]; then
			pr=$p
		else
			pr=$(relative $(name_to_repo_pkg $p) $_ROOT)
		fi
		all="$all $pr"
		for d in $(./mk query $p bdep) $(./mk query $p rdep); do
			if [ "$MK_FORCE" ]; then
				dr=$(sub_to_main $d)
			else
				dr=$(relative $(name_to_repo_pkg \
				    $(sub_to_main $d)) $_ROOT)
			fi
			deps="$deps
$pr: $dr"
		done
	done

	cat <<-EOF
	PKGS = $all

	all: \$(PKGS)

	\$(PKGS):
	EOF

	if [ "$MK_FORCE" ]; then
		printf '\t%s\n' './mk -f pkg $@'
	else
		printf '\t%s\n' './mk pkg $(shell f=$$(basename $@); echo $${f%-*})'
	fi

	printf '%s\n' "$deps"
}

run_step() {
	local step=$1
	local pkg=$2

	if [ "$pkg" ]; then
		_run_step_for_pkg "$@"
	elif [ "$step" = pkg ]; then
		_gen_deps_makefile | make -f-
	fi
}
