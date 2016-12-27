import ceylon.file { parsePath, File, Resource, lines }
import ceylon.collection { PriorityQueue, HashMap, HashSet }

class Maze(Integer width, Integer height,
  Integer start, HashSet<Integer> walls, HashSet<Integer> checkpoints)
{
  shared Boolean isAtTarget(Integer position, {Integer*} nodecp, Integer mode = 1) {
    if (mode == 1) {
      return nodecp.size == checkpoints.size;
    } else {
      return (nodecp.size == checkpoints.size) && position == start;
    }
  }

  Integer distance(Integer x, Integer y) {
    return (x%width - y%width).magnitude + (x/width - y/width).magnitude;
  }

  shared {Integer*} solve(Integer mode) {
    class Node(shared Integer position, shared Integer[] checkpoints,
      shared Node|Null prev, shared Integer cost, shared variable Boolean inQueue = true)
    {
      shared actual default Boolean equals(Object that) {
        if (is Node that) {
          return position == that.position && checkpoints.equals(that.checkpoints);
        }
        return false;
      }
      shared actual default Integer hash = position.hash*31 + checkpoints.hash;
      shared Integer costEstimate =
              cost + (min(checkpoints.map((x) => distance(x, position))) else 0);
    }

    value pq = PriorityQueue<Node>((x, y) => x.cost.compare(y.cost));
    value visited = HashMap<Node, Node>();
    value startNode = Node(start, [], null, 0);

    pq.offer(startNode);
    visited[startNode] = startNode;

    //  A* loop
    while (!pq.empty) {
      Node? node = pq.accept();
      if (!exists node) {
        continue;
      }
      if (!node.inQueue) {
        continue;
      }

      if (isAtTarget(node.position, node.checkpoints, mode)) {
        //  reached target
        variable [Integer*] res = [ node.position ];
        variable Node cnode = node;
        while (exists pnode = cnode.prev) {
          res = res.append([pnode.position]);
          cnode = pnode;
        }
        return res.reversed;
      }

      for (offs in [-1, 1, -width, width]) {
        Integer newPos = node.position + offs;
        if (walls.contains(newPos)) {
          continue;
        }

        variable Integer[] newCP = node.checkpoints;
        if (checkpoints.contains(newPos) && !node.checkpoints.contains(newPos)) {
          newCP = node.checkpoints.append([newPos]);
          newCP.sort(byIncreasing((Integer i) => i));
        }

        Node newNode = Node(newPos, newCP, node, node.cost + 1);
        value vnode = visited.get(newNode);
        variable Boolean betterNode = false;
        if (exists vnode) {
          betterNode = vnode.cost > node.cost + 1;
          if (betterNode) {
            vnode.inQueue = false;
          }
        } else {
          betterNode = true;
        }

        if (betterNode) {
          pq.offer(newNode);
          visited[newNode] = newNode;
        }
      }
    }
    return {};
  }
}

Maze? parseMaze(String[] lines) {
  Integer width = lines[0] ?. size else 0;
  variable Integer start = - 1;
  value walls = HashSet<Integer>();
  value checkpoints = HashSet<Integer>();

  for (j->line in lines.indexed) {
    for (i->c in line.indexed) {
      value idx = i + j * width;
      switch (c)
      case ('#') {
        walls.add(idx);
      }
      case ('0') {
        start = idx;
      }
      case ('.') { /* free space, skip */ }
      else {
        checkpoints.add(idx);
      }
    }
  }
  return Maze(width, lines.size, start, walls, checkpoints);
}

shared void run() {
  String fname = process.arguments[0] else "input.txt";
  Resource resource = parsePath(fname).resource;
  if (!is File resource) {
    print("File not found: ``fname``");
    return;
  }

  value maze = parseMaze(lines(resource));
  value path1 = maze?.solve(1);
  print("Minimum steps 1: ``(path1?.size else 0) - 1``");

  value path2 = maze?.solve(2);
  print("Minimum steps 2: ``(path2?.size else 0) - 1``");
}

