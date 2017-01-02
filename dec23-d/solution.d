import std.stdio;

void main(string[] args) {
    string fname = args.length > 1 ? args[1] : "input.txt";
    
    auto file = File(fname);
    auto lines = file.byLine();
    foreach (line; lines) writeln(line);
}