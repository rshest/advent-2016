import java.awt.*;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

public class solution {

  private static boolean hasWall(int x, int y, int seed) {
    if (x < 0 || y < 0) return true;
    int d = x*x + 3*x + 2*x*y + y + y*y + seed;
    return Integer.bitCount(d)%2 == 1;
  }

  private static String printMaze(int w, int h, int seed, ArrayList<Point> path) {
    StringBuilder builder = new StringBuilder();

    builder.append(' ');
    for (int i = 0; i < w; i++) builder.append(i%10);
    builder.append("\n");

    for (int j = 0; j < h; j++) {
      builder.append(j%10);
      for (int i = 0; i < w; i++) {
        boolean onPath = false;
        for (Point p: path) {
          if (p.x == i && p.y == j) {
            onPath = true;
            break;
          }
        }
        if (onPath) {
          builder.append('O');
        } else {
          builder.append(hasWall(i, j, seed) ? '#' : '.');
        }
      }
      builder.append("\n");
    }
    return builder.toString();
  }

  static class Solver {
    final int seed;
    final Point start, target;

    Comparator<Node> comparator = new NodeComparator();
    PriorityQueue<Node> open = new PriorityQueue<>(comparator);
    HashMap<Point, Node> closed = new HashMap<>();

    Solver(Point start, Point target, int seed) {
      this.seed = seed;
      this.start = start;
      this.target = target;
    }

    class Node {
      final Point position;
      final Node prevNode;
      final int cost;
      boolean inQueue = true;

      Node(Point position, Node prevNode, int cost) {
        this.position = position;
        this.prevNode = prevNode;
        this.cost = cost;
      }

      int pathLength() {
        if (prevNode == null) return 0;
        return prevNode.pathLength() + 1;
      }
    }

    static class NodeComparator implements Comparator<Node> {
      @Override
      public int compare(Node x, Node y) {
        return x.cost - y.cost;
      }
    }

    ArrayList<Point> solve() {
      final Point[] OFFSETS = {
              new Point(1, 0), new Point(0, 1),
              new Point(-1, 0), new Point(0, -1)};

      Node startNode = new Node(start, null, 0);

      open.add(startNode);
      closed.put(start, startNode);

      //  main Dijkstra loop
      while (!open.isEmpty()) {
        Node node;
        do {
          node = open.poll();
        } while (!node.inQueue);
        node.inQueue = false;

        if (node.position.equals(target)) {
          //  reached the target
          ArrayList<Point> res = new ArrayList<>();
          while (node != null) {
            res.add(node.position);
            node = node.prevNode;
          }
          Collections.reverse(res);
          return res;
        }

        for (Point offs : OFFSETS) {
          Point pos = new Point(offs.x + node.position.x, offs.y + node.position.y);
          if (hasWall(pos.x, pos.y, seed)) continue;

          Node vnode = closed.get(pos);
          boolean betterCost = false;

          if (vnode != null) {
            betterCost = vnode.cost > node.cost + 1;
            if (betterCost) vnode.inQueue = false;
          }

          if (vnode == null || betterCost) {
            Node newNode = new Node(pos, node, node.cost + 1);
            open.add(newNode);
            closed.put(pos, newNode);
          }
        }
      }
      return new ArrayList<Point>();
    }

    int countReachableNodes(int maxSteps) {
      int res = 0;
      for (Node node : closed.values()) {
        if (node.pathLength() <= maxSteps) res++;
      }
      return res;
    }
  }

  public static void main(String[] args) throws IOException {
    String fname = "input.txt";
    int tx = 31, ty = 39;
    int maxSteps = 50;

    if (args.length > 0) fname = args[0];
    if (args.length > 1) tx = Integer.parseInt(args[1]);
    if (args.length > 2) ty = Integer.parseInt(args[2]);
    if (args.length > 3) maxSteps = Integer.parseInt(args[3]);

    String text = new String(Files.readAllBytes(Paths.get(fname)));
    int seed = Integer.parseInt(text);

    Point start = new Point(1, 1);
    Point target = new Point(tx, ty);

    Solver solver = new Solver(start, target, seed);
    ArrayList<Point> solution = solver.solve();
    System.out.println(printMaze(tx + 1, ty + 1, seed, solution));

    System.out.println(String.format(
      "Seed %1$d, number of steps (%2$d, %3$d) -> (%4$d, %5$d): %6$d",
      seed, start.x, start.y, target.x, target.y, solution.size() - 1));

    System.out.println(String.format(
      "Number of reachable in %1$d steps: %2$d.",
      maxSteps, solver.countReachableNodes(maxSteps)));
  }
}
