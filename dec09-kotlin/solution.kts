import java.io.File

val PATTERN = """^\((\d+)x(\d+)\)""".toRegex()

fun decompress(s: String): String {
    if (s.length == 0) return ""
    val parts = PATTERN.find(s)?.groupValues
    if (parts != null) {
        val markerLen = parts[0].length
        val patLen = parts[1].toInt()
        val len = markerLen + patLen
        val repeat = parts[2].toInt()
        return s.substring(markerLen, len).repeat(repeat) +
                decompress(s.substring(len))
    } else {
        return s[0] + decompress(s.substring(1))
    }
}

fun getDecompressedSize(s: String): Long {
    if (s.length == 0) return 0
    val parts = PATTERN.find(s)?.groupValues
    if (parts != null) {
        val markerLen = parts[0].length
        val patLen = parts[1].toInt()
        val len = markerLen + patLen
        val repeat = parts[2].toInt()
        return repeat*getDecompressedSize(s.substring(markerLen, len)) +
                getDecompressedSize(s.substring(len))
    } else {
        return 1 + getDecompressedSize(s.substring(1))
    }
}

//  read data
val file = if (args.size > 0) args[0] else "input.txt"
val lines = File(file).readLines()
for (line in lines) {
    println("Decompressed length v1: ${decompress(line).length}")
    println("Decompressed length v2: ${getDecompressedSize(line)}")
}

