
object AlphanumComparator {
  private def isDigit(ch: Char): Boolean = {
    return ch >= 48 && ch <= 57
  }

  /** Length of string is passed in for improved efficiency (only need to calculate it once) * */
  private def getChunkOffset(s: String, slength: Int, mark: Int): Int = {
    var marker = mark
    var c: Char = s.charAt(marker)
    marker += 1
    if (isDigit(c)) {
      while (marker < slength) {
        c = s.charAt(marker)
        if (!isDigit(c)) return marker
        marker += 1
      }
    }
    else {
      while (marker < slength) {
        c = s.charAt(marker)
        if (isDigit(c)) return marker
        marker += 1
      }
    }
    marker
  }

  private def compareRegion(s1: String, off1: Int, len1: Int, s2: String, off2: Int, len2: Int): Int = {
    val lim: Int = Math.min(len1, len2)
    var i: Int = 0
    while (i < lim) {
      val c1: Char = s1.charAt(off1 + i)
      val c2: Char = s2.charAt(off2 + i)
      if (c1 != c2) {
        return c1 - c2
      }
      i += 1
    }
    return len1 - len2
  }

  def compare(s1: String, s2: String): Int = {
    if ((s1 == null) || (s2 == null)) return 0

    var thisMarker = 0
    var thatMarker: Int = 0
    val s1Length: Int = s1.length
    val s2Length: Int = s2.length
    while (thisMarker < s1Length && thatMarker < s2Length) {
      if (s1.charAt(thisMarker) == s2.charAt(thatMarker)) {
        thisMarker += 1
        thatMarker += 1
      } else {
        var result: Int = 0
        val thisChunk: Int = getChunkOffset(s1, s1Length, thisMarker)
        val thatChunk: Int = getChunkOffset(s2, s2Length, thatMarker)
        val thisChunkLength: Int = thisChunk - thisMarker
        val thatChunkLength: Int = thatChunk - thatMarker
        if (isDigit(s1.charAt(thisMarker)) && isDigit(s2.charAt(thatMarker))) {
          result = thisChunkLength - thatChunkLength
          if (result == 0) {
            var i: Int = thisMarker
            var j: Int = thatMarker
            while (i < thisChunk) {
              result = s1.charAt(i) - s2.charAt(j)
              if (result != 0) {
                return result
              }
              i += 1
              j += 1
            }
          }
        } else {
          result = compareRegion(s1, thisMarker, thisChunkLength, s2, thatMarker, thatChunkLength)
        }
        if (result != 0) return result
        thisMarker = thisChunk
        thatMarker = thatChunk
      }
    }
    s1Length - s2Length
  }
}