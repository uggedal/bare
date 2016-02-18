cmd_list() {
	find $_PKG  -type f |
	    sed 's|\.sh$||;s|.*/||' | 
	    grep -v '^bootstrap-' |
	    sort
}
