package com.e4net.wolfmanblog

import java.text.SimpleDateFormat

class Rfc822Codec {

	static encode = { date ->
		def RFC822DATEFORMAT= "EEE, dd MMM yyyy HH:mm:ss Z"
		date.format(RFC822DATEFORMAT)
	}

}
