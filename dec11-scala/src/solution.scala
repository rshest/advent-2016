import scala.io.Source

object Solution {

  sealed trait ElementType
  case object Generator extends ElementType
  case object Microchip extends ElementType

  class Element(val caption: String, val kind: ElementType, var currentFloor: Int) {
  }

  def parse(lines: Array[String]): Array[Element] = {

  }


  def main(args: Array[String]): Unit = {
    val file = if (args.length > 0) args(0) else "test.txt"
    val lines = Source.fromFile(file).getLines.toList

    val pattern = "([^\\s]+) generator|([^\\s]+)-compatible microchip".r

    for (line <- lines) {
      pattern.findAllIn(line).matchData foreach {
        m => println(s"G: ${m.group(1)}, M: ${m.group(2)}")
      }
      println("---")
    }
  }
}
