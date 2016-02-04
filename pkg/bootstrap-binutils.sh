inherit binutils

configure \
	--disable-multilib \
	--disable-nls \
	--disable-werror \
	--target=$MK_TARGET_TRIPLE
