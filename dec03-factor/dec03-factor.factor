USING: io io.files io.encodings.ascii kernel command-line splitting formatting
  sets assocs sequences grouping namespaces
  math math.vectors math.parser math.combinatorics ;
IN: dec03-factor

CONSTANT: INPUT-FILE "vocab:dec03-factor/input.txt"

: parse-triangle ( line -- side-list ) " " split harvest [ string>number ] map ;
: load-triangles ( file -- tris ) ascii file-lines [ parse-triangle ] map ;
: regroup-triples ( tris -- tris ) 3 <groups> [ flip ] map concat ;

: valid? ( tri -- valid ) <permutations> [ first3 + < ] all? ;
: count-valid ( tris -- number ) [ valid? ] filter length ;

: main ( -- )
  command-line get dup empty? [ drop INPUT-FILE ] [ first ] if load-triangles
  dup count-valid "Valid triangles 1: %d\n" printf
  regroup-triples count-valid "Valid triangles 2: %d\n" printf ;


MAIN: main
