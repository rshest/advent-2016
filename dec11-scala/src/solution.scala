import scala.io.Source
import scala.collection.mutable

object Solution {
  case class Move(item1: Int, item2: Int, direction: Int)

  //  elements are ordered, such that at even positions we have microchips
  //  amd at odd positions we have corresponding generators
  case class Layout(elements: Array[String], maxFloor: Int,
                    locations: Array[Int], curFloor: Int = 1)
  {
    def isAtGoal: Boolean = locations.forall {_ == maxFloor}

    def isValidMove(move: Move) : Boolean = {
      val newFloor = curFloor + move.direction

      def loc(k: Int) =
        if (k == move.item1 || k == move.item2) newFloor else locations(k)

      //  for each generator, check if there is a non-paired microchip on the floor
      for (i <- elements.indices by 2;
           j <- 1 until elements.length by 2 if j != i + 1)
      {
        if (loc(j) == loc(i) && loc(j - 1) != loc(i)) return false
      }
      true
    }

    def applyMove(move: Move): Layout = {
      val newFloor = curFloor + move.direction
      var newLoc = locations.clone()
      newLoc(move.item1) = newFloor
      newLoc(move.item2) = newFloor
      Layout(elements, maxFloor, newLoc, newFloor)
    }

    //  enumerates all possible moves from this layout
    def getPossibleMoves: Seq[Move] = {
      for (i <- elements.indices if locations(i) == curFloor;
           j <- i until elements.length if locations(j) == curFloor;
           dir <- List(-1, 1) if curFloor + dir > 0 && curFloor + dir <= maxFloor;
           move = Move(i, j, dir) if isValidMove(move)) yield move
    }

    override def equals(a: Any): Boolean = {
      val rhs = a.asInstanceOf[Layout]
      curFloor == rhs.curFloor && locations.sameElements(rhs.locations)
    }

    override def toString: String = {
      var res = ""
      for (floor <- maxFloor to 1 by -1) {
        val floorStr = if (floor == curFloor) " E " else "   "
        res += s"\nF$floor$floorStr"
        for (i <- elements.indices) {
          res += " " + (if (locations(i) == floor) elements(i) else ".. ")
        }
      }
      res
    }
  }

  object Layout {
    def parse(lines: Seq[String]): Layout = {
      val pattern = "([^\\s]+) generator|([^\\s]+)-compatible microchip".r
      val (el, loc) = lines.zipWithIndex.flatMap { case (line, floor) =>
        pattern.findAllIn(line).matchData map { m =>
          val (n, kind) = if (m.group(2) == null) (1, "G") else (2, "M")
          val caption = m.group(n).toUpperCase.slice(0, 2)
          (s"$caption$kind", floor + 1)
        }
      }.toArray.sorted.unzip
      new Layout(el, lines.length, loc)
    }

    def solve(start: Layout) : Seq[Layout] = {

      case class Node(layout: Layout, prev: Node, cost: Int,
                      var inQueue: Boolean = false) extends Ordered[Node]
      {
        def compare(a: Node): Int = a.costEstimate - costEstimate
        override def equals(a: Any): Boolean = layout.equals(a.asInstanceOf[Node].layout)
        override val hashCode: Int = layout.hashCode
        val costEstimate: Int = cost + layout.locations.map(layout.maxFloor - _).sum/2
      }

      val startNode = Node(start, null, 0, inQueue = true)
      var pq = mutable.PriorityQueue(startNode)
      var visited = mutable.HashSet(startNode)
      var iter = 1
      val t0 = System.currentTimeMillis

      //  the main A* loop
      while (pq.nonEmpty) {
        var node: Node = null
        do {
          node = pq.dequeue()
        } while (!node.inQueue)
        node.inQueue = false

        if (iter % 1000 == 0) {
          val t = System.currentTimeMillis
          println(s"#$iter. visited: ${visited.size}, queued: ${pq.size}," +
            s" depth: ${node.cost}, time: ${(t - t0)/1000}s")
        }
        iter += 1

        if (node.layout.isAtGoal) {
          //  reached the destination
          var res = Array[Layout]()
          while (node != null) {
            res = res :+ node.layout
            node = node.prev
          }
          return res.reverse
        }

        val moves = node.layout.getPossibleMoves
        for (move <- moves) {
          val newNode = Node(node.layout.applyMove(move), node, node.cost + 1, inQueue = true)
          visited.find(_ == newNode) match {
            case Some(vnode) =>
              if (vnode.cost > newNode.cost) {
                //  visited it before, update the cost, since it's better
                vnode.inQueue = false
                pq += newNode
                visited += newNode
              }
            case None =>
              //  a new node, never visited before
              visited += newNode
              pq += newNode
          }
        }
      }
      Seq()
    }
  }

  def main(args: Array[String]): Unit = {
    val file = if (args.length > 0) args(0) else "test.txt"
    val lines = Source.fromFile(file).getLines.toList

    val layout = Layout.parse(lines)
    val solution = Layout.solve(layout)

    for (layout <- solution) println(layout)
    println(s"Minimal amount of moves: ${solution.length - 1}")
  }
}
