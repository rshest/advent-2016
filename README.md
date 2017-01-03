
My solutions to [Advent of Code 2016](http://adventofcode.com/2016) problems.

The goal is to use a different programming language for every problem:

1. [Day 01](http://adventofcode.com/2016/day/1):  Python
    ```bash
    $ python solution.py < input.txt
    ```

2. [Day 02](http://adventofcode.com/2016/day/2): C++
    ```bash
    $ g++ -std=c++11 solution.cpp -o solution
    $ ./solution < input.txt
    ```

3. [Day 03](http://adventofcode.com/2016/day/3): Factor

    In the listener:
    ```bash
    IN: scratchpad "<path>/<to>/<parent>/<folder>" add-vocab-root
    IN: scratchpad USE: dec03-factor
    IN: scratchpad main
    ```

4. [Day 04](http://adventofcode.com/2016/day/4): Nim
    ```bash
    $ nim c --opt:speed solution.nim && ./solution < input.txt
    ```

5. [Day 05](http://adventofcode.com/2016/day/5): TypeScript
    ```bash
    $ npm install @types/node
    $ npm install crypto``
    $ tsc --lib es6 solution.ts && node solution.js < input.txt
    ```

6. [Day 06](http://adventofcode.com/2016/day/6): Julia
    ```bash
    $ julia solution.jl input.txt
    ```

7. [Day 07](http://adventofcode.com/2016/day/7): F#
    ```bash
    $ fsi solution.fsx input.txt
    ```

8. [Day 08](http://adventofcode.com/2016/day/8): Lua
    ```bash
    $ lua5.1 solution.lua input.txt
    ```

9. [Day 09](http://adventofcode.com/2016/day/9): Kotlin
    ```bash
    $ kotlinc -script solution.kts input.txt
    ```

10. [Day 10](http://adventofcode.com/2016/day/10): Elm
    ```bash
    $ elm-reactor
    ```
    Then, open http://localhost:8000/solution.elm in a browser.

11. [Day 11](http://adventofcode.com/2016/day/11): Scala
    ```bash
    $ scala solution.scala input1.txt
    $ scala -J"-Xmx2048m" solution.scala input2.txt
    ```

12. [Day 12](http://adventofcode.com/2016/day/12): Dart
    ```bash
    $ dart solution.dart input.txt
    ```

13. [Day 13](http://adventofcode.com/2016/day/13): Java
    ```bash
    $ cd src && javac solution.java && java solution ../input.txt
    ```

14. [Day 14](http://adventofcode.com/2016/day/14): Ruby
    ```bash
    $ ruby solution.rb input.txt
    ```

15. [Day 15](http://adventofcode.com/2016/day/15): Haskell
    ```bash
    $ ghc solution.hs && ./solution input1.txt && ./solution input2.txt
    ```

16. [Day 16](http://adventofcode.com/2016/day/16): Go
    ```bash
    $ go run solution.go input1.txt
    $ go run solution.go input2.txt
    ```

17. [Day 17](http://adventofcode.com/2016/day/17): Clojure
    ```bash
    $ lein run input.txt
    ```

18. [Day 18](http://adventofcode.com/2016/day/18): Elixir
    ```bash
    $ elixir solution.exs input.txt 40
    $ elixir solution.exs input.txt 400000
    ```

19. [Day 19](http://adventofcode.com/2016/day/19): Crystal
    ```bash
    $ crystal solution.cr
    ```

20. [Day 20](http://adventofcode.com/2016/day/20): C#
     ```bash
     $ mcs Solution.cs && mono Solution.exe
     ```

21. [Day 21](http://adventofcode.com/2016/day/21): Ada
    ```bash
    $ gnatmake -gnata solution.adb && ./solution
    ```

22. [Day 22](http://adventofcode.com/2016/day/22): Rust
     ```bash
     $ cargo run --release solution.rs input.txt
     ```

23. [Day 23](http://adventofcode.com/2016/day/23): D
    ```bash
    $ rdmd -release solution input.txt 7
    $ rdmd -release solution input.txt 12
    ```

24. [Day 24](http://adventofcode.com/2016/day/24): Ceylon
    ```bash    
    $ ceylon run --compile=force solution
    ```

25. [Day 25](http://adventofcode.com/2016/day/25): Swift
    ```bash    
    $ swift solution.swift input.txt
    ```
