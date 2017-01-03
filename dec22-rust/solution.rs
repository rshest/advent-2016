use std::env;
use std::collections::{BinaryHeap, HashMap, HashSet};
use std::cmp::Ordering;
use std::fs::File;
use std::io::Read;
use std::hash::{Hash, Hasher};

use regex::Regex;

#[macro_use]
extern crate lazy_static;
extern crate regex;

type Coord = (i32, i32);

#[derive(Debug)]
struct Node {
  pub pos : Coord,
  pub size : u32,
  pub used : u32,
  pub avail : u32,
  pub use_percent : u32
}

const NODE_REGEX: &'static str =
r".*node-x(\d+)-y(\d+)\D+(\d+)T+\D+(\d+)T+\D+(\d+)T+\D+(\d+)%";

fn parse_node(str: &str) -> Option<Node> {
  lazy_static! {
    static ref RE: Regex = Regex::new(NODE_REGEX).unwrap();
  }

  if RE.is_match(str) {
    let cap = RE.captures(str).unwrap();
    let part = |i: usize| cap[i + 1].parse::<u32>().unwrap();
    Some(Node {pos : (part(0) as i32, part(1) as i32),
      size : part(2), used : part(3), avail : part(4), use_percent : part(5)
    })
  } else {
    None
  }
}

fn is_viable_pair(a: &Node, b: &Node) -> bool {
  a.used > 0 && a.pos != b.pos && a.used <= b.avail
}

fn count_viable_pairs(nodes: &Vec<Node>) -> u32 {
  let mut res = 0;
  let n = nodes.len();
  for i in 0..n {
    for j in 0..n {
      if is_viable_pair(&nodes[i], &nodes[j]) {
        res += 1;
      }
    }
  }
  res
}

fn find_extents(nodes: &Vec<Node>) -> Coord {
  (nodes.iter().map(|n| n.pos.0).max().unwrap() + 1,
   nodes.iter().map(|n| n.pos.1).max().unwrap() + 1)
}

fn find_blank(nodes: &Vec<Node>) -> Coord {
  nodes.iter().find(|n| n.used == 0).unwrap().pos
}

fn find_path(nodes: &Vec<Node>, from: Coord, to: Coord) -> Vec<Coord> {
  #[derive(Copy, Clone)]
  struct State {
    cost: u32,
    blank_pos: Coord,
    data_pos: Coord,
    prev: i32,
    index: i32
  }

  impl Ord for State {
    fn cmp(&self, other: &State) -> Ordering {
      other.cost.cmp(&self.cost)
    }
  }

  impl PartialOrd for State {
    fn partial_cmp(&self, other: &State) -> Option<Ordering> {
      Some(self.cmp(other))
    }
  }

  impl  PartialEq for State {
    fn eq(&self, other: &State) -> bool {
      self.blank_pos == other.blank_pos && self.data_pos == other.data_pos
    }
  }

  impl Eq for State {}

  impl Hash for State {
    fn hash<H: Hasher>(&self, state: &mut H) {
      self.blank_pos.hash(state);
      self.data_pos.hash(state);
    }
  }

  let start_state = State {
    cost: 0,
    blank_pos: find_blank(nodes),
    data_pos: from,
    prev: -1,
    index: 0
  };

  let node_reg: HashMap<Coord, &Node> = nodes.iter().map(|n| (n.pos.clone(), n)).collect();

  let mut states = Vec::new();
  let mut open = BinaryHeap::new();
  let mut closed = HashSet::new();

  open.push(start_state.clone());
  closed.insert(start_state.clone());
  states.push(start_state);

  while !open.is_empty() {
    let state = open.pop().unwrap();
    let node = node_reg.get(&state.blank_pos).unwrap();

    if state.data_pos == to {
      //  reached the target
      let mut cs = &state;
      let mut res = Vec::new();
      while cs.prev != -1 {
        res.push(cs.blank_pos.clone());
        cs = &states[cs.prev as usize];
      }
      return res;
    }

    for offs in [(-1, 0), (0, -1), (1, 0), (0, 1)].iter() {
      let pos = (state.blank_pos.0 + offs.0, state.blank_pos.1 + offs.1);
      let new_node = match node_reg.get(&pos) {
        Some(neighbor) if neighbor.used <= node.size => neighbor,
        _ => continue
      };

      let new_idx = states.len() as i32;
      let new_state = State {
        cost: state.cost + 1,
        blank_pos: new_node.pos,
        data_pos: if state.data_pos == pos { state.blank_pos } else { state.data_pos },
        prev: state.index,
        index: new_idx
      };

      let better_state = match closed.get(&new_state) {
        Some(vs) => vs.cost > new_state.cost,
        None => true
      };

      if better_state {
        open.push(new_state.clone());
        closed.insert(new_state.clone());
      }
      states.push(new_state.to_owned());
    }
  }
  Vec::new()
}

fn main() {
  let args: Vec<_> = env::args().collect();
  let fname = if args.len() > 2 { &args[2] } else { "input.txt" };

  let mut file = File::open(fname).unwrap();
  let mut input = String::new();
  file.read_to_string(&mut input).unwrap();

  let nodes: Vec<Node> =
    input.split("\n").map(|s| parse_node(s)).filter_map(|x| x).collect();

  println!("Number of viable pairs: {}", count_viable_pairs(&nodes));

  let (w, _) = find_extents(&nodes);
  let path = find_path(&nodes, (w - 1, 0), (0, 0));
  println!("Shortest from top-right to top-left: {}", path.len());
}