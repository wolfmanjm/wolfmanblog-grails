package com.e4net.wolfmanblog;
class PasswordCodec {

	static encode = { arr ->
		String str = arr.join('-')
		str.encodeAsSHA1()
	}

}
