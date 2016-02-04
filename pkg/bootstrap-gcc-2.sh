inherit gcc

configure \
	--disable-libmudflap \
	--disable-libsanitizer \
	--disable-multilib \
	--disable-nls \
	--enable-checking=release \
	--enable-languages=c,c++ \
	--enable-shared \
	--target=$MK_TARGET_TRIPLE

post_install() {
	:
}
