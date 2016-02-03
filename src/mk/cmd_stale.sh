_re() {
	local name=$1
	local ver=$2
	local pre='(?:[-_]?(?:src|source))?'
	local tag='(?:[-_](?:src|source|asc|orig))?'
	local ext='\.(?:tar|t[bglx]z|tbz2|zip)'

	printf '%s%s[-_]%s(?i)%s%s' $name $pre $ver $tag $ext
}

_versort() {
	sort -t. -k1,1n -k2,2n -k3,3n -k4,4n -k5,5n
}

_verignore() {
	if [ "$PKG_STALE_IGNORE" ]; then
		grep -v "$PKG_STALE_IGNORE" || :
	else
		cat
	fi
}

_latest() {
	local url=$PKG_STALE_URL
	[ "$url" ] || url=${PKG_DIST%/*}

	local re="$PKG_STALE_RE"
	[ "$re" ] || {
		local name_re=$(_re '([^\/]+)' '(?:[^-\/_\s]+?)')
		local name=$(printf '%s' $PKG_DIST |
			perl -ne 'if (/'$name_re'/) { print "$1\n" }')
		re=$(_re $name '([^-\/_\s]+?)')
	}

	curl -sL $url |
		perl -ne 'if (/'"$re"'/) { print "$1\n" }' |
		_versort | _verignore
}

cmd_stale() {
	local v1 v2 v

	[ "$PKG_NAME" ] || {
		list_pkgs | xargs -L1 ./mk stale
		return 0
	}

	[ "$PKG_DIST" ] || return 0
	[ "$PKG_PARENT_NAME" = "$PKG_NAME" ] || return 0

	v1=$(_latest)

	[ "$v1" ] || {
		msg "$PKG_NAME: no upstream version"
		return 0
	}

	v2=$(printf '%s\n%s\n' $v1 $PKG_VER | _versort | uniq | awk "
		{
			if (found) {
				print;
			}
		}
		/^$PKG_VER\$/ {
			found = 1;
		}
	")

	[ -z "$v2" ] || {
		for v in $v2; do
			msg "$PKG_NAME: $PKG_VER -> $v"
		done
	}
}
