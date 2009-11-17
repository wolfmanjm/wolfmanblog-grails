package com.e4net.wolfmanblog;
/**
 ** turn the string into a permalink
 */
class PermalinkCodec {

    static stripHtmlTags(String str, boolean leave_whitespace = false) {
        def name = /[\w:_-]+/
        def value = /([A-Za-z0-9]+|(\'[^\']*?'|\"[^\"]*?"))/
        def attr = /($name(\s*=\s*$value)?)/
        def rx = /<[!\/?\[]?($name|--)(\s+($attr(\s+$attr)*))?\s*([!\/?\]]+|--)?>/
        (leave_whitespace) ?  str.replaceAll(rx, "").trim() : str.replaceAll(rx, "").replaceAll(/\s+/, " ").trim()
    }

    static collapse(str, character = " ") {
        str.replaceFirst(/^($character)*/, "").replaceFirst(/($character)*$/, "").replaceAll(/($character)+/, character)
    }

    static convertMiscCharacters(str) {
        def dummy = str.replaceAll(/\.{3,}/, " dot dot dot ") // Catch ellipses before single dot rule!
          [
            /\s*&\s*/: "and",
            /\s*#/: "number",
            /\s*@\s*/: "at",
            /(\S+|^)\.(\S+)/: '$1 dot $2',
            /(\s|^)\$(\d*)(\s|$)/: '$2 dollars',
            /\s*\*\s*/: "star",
            /\s*%\s*/: "percent",
            /\s*(\\|\/)\s*/: "slash"
          ].each { found, replaced ->
            if(! (replaced =~ /\$1/)) {
              replaced = " $replaced " 
            }
            dummy= dummy.replaceAll(found, replaced)
          }
          dummy.replaceAll(/(^|\w)\'(\w|$)/, '$1$2').replaceAll(/[\.,:;()\[\]\/\?!\^\'\"_]/, " ")
    } 

    static removeFormatting(str) {
        str= stripHtmlTags(str)
        convertMiscCharacters(str)
    }

    static encode = { str ->
        collapse(removeFormatting(str).toLowerCase().replaceAll(" ", "-"), "-")
    }
}

/*
and alternative...

private static final Pattern NONLATIN = Pattern.compile("[^\\w-]");
  private static final Pattern WHITESPACE = Pattern.compile("[\\s]");

  public static String toSlug(String input) {
    String nowhitespace = WHITESPACE.matcher(input).replaceAll("-");
    String normalized = Normalizer.normalize(nowhitespace, Form.NFD);
    String slug = NONLATIN.matcher(normalized).replaceAll("");
    return slug.toLowerCase(Locale.ENGLISH);
  }

*/