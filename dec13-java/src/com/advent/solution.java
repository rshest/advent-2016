package com.advent;

import java.awt.*;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;

public class solution {



  static boolean hasWall(int x, int y, int seed) {
    int d = x*x + 3*x + 2*x*y + y + y*y + seed;
    return Integer.bitCount(d)%2 == 1;
  }

  static String printMaze(int w, int h, int seed, ArrayList<Point> path) {
    StringBuilder builder = new StringBuilder();

    builder.append(' ');
    for (int i = 0; i < w; i++) builder.append(i%10);
    builder.append("\n");

    for (int j = 0; j < h; j++) {
      builder.append(j%10);
      for (int i = 0; i < w; i++) {
        builder.append(hasWall(i, j, seed) ? '#' : '.');
      }
      builder.append("\n");
    }
    return builder.toString();
  }

  static class Node {
    final Point position;
    final Node prevNode;
    final int cost;

    Node(Point position, Node prevNode, int cost) {
      this.position = position;
      this.prevNode = prevNode;
      this.cost = cost;
    }
  }

  static ArrayList<Point> solve(Point start, Point target) {
    return new ArrayList<Point>();
  }

  public static void main(String[] args) throws IOException {
    String fname = "input.txt";
    int tx = 31, ty = 39;
    if (args.length > 0) fname = args[0];
    if (args.length > 1) tx = Integer.parseInt(args[1]);
    if (args.length > 2) ty = Integer.parseInt(args[2]);

    String text = new String(Files.readAllBytes(Paths.get(fname)));
    int seed = Integer.parseInt(text);
    System.out.println(printMaze(10, 10, seed));

    Point start = new Point(1, 1);
    Point target = new Point(tx, ty);
    ArrayList<Point> solution = solve(start, target);
    System.out.println(String.format("Seed %1$d, number of steps (%2$d, %3$d) -> (%4$d, %5$d): %6$d",
            seed, start.x, start.y, target.x, target.y, solution.size()));
  }
}
