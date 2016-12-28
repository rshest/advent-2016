use std::env;
use std::fs::File;
use std::io::Read;

fn main() {
  let args: Vec<_> = env::args().collect();
  let fname = if args.len() > 1 { &args[1] } else { "input.txt" };

  let mut file = File::open(fname).unwrap();
  let mut input = String::new();
  file.read_to_string(&mut input).unwrap();

  println!("{}", seed);
}