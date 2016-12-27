import ceylon.file { parsePath, File, Resource, lines }

shared void run() {
  String fname = process.arguments[0] else "input.txt";

  Resource resource = parsePath(fname).resource;
  if (is File resource) {
    String[] allLines = lines(resource);
    print(allLines);
  }

  print("Argument: ``fname``");
}

