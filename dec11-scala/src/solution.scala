import scala.io.Source

object Solution {

  sealed trait ElementType
  case object Generator extends ElementType
  case object Microchip extends ElementType

  class Element(val caption: String, val kind: ElementType, var floor: Int) {
    override def toString(): String =
      s"${caption.toUpperCase.slice(0, 2)}${kind.toString.toUpperCase.head}[${floor}]"
  }

  def parseElements(lines: Seq[String]): Array[Element] = {
    val pattern = "([^\\s]+) generator|([^\\s]+)-compatible microchip".r
    lines.zipWithIndex.flatMap { case (line, floor) =>
      pattern.findAllIn(line).matchData map { m =>
        val (n, kind) = if (m.group(2) == null) (1, Generator) else (2, Microchip)
        new Element(m.group(n), kind, floor + 1)
      }
    }.toArray
  }

  def main(args: Array[String]): Unit = {
    val file = if (args.length > 0) args(0) else "test.txt"
    val lines = Source.fromFile(file).getLines.toList

    val elems = parseElements(lines)

    for (el <- elems) {
      println(el.toString)
    }
  }
}
