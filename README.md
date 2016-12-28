
My solutions to [Advent of Code 2016](http://adventofcode.com/2016) problems.

The goal is to use a different programming language for every problem:

1. Python
    ```bash
    $ python solution.py < input.txt
    ```

2. C++
    ```bash
    $ g++ -std=c++11 solution.cpp -o solution
    $ ./solution < input.txt
    ```

3. Factor

    In the listener:
    ```bash
    IN: scratchpad "<path>/<to>/<parent>/<folder>" add-vocab-root
    IN: scratchpad USE: dec03-factor
    IN: scratchpad main
    ```

4. Nim
    ```bash
    $ nim c --opt:speed solution.nim && ./solution < input.txt
    ```
    
5. TypeScript
    ```bash
    $ npm install @types/node
    $ npm install crypto
    $ tsc --lib es6 solution.ts && node solution.js < input.txt
    ```
    
6. Julia
    ```bash
    $ julia solution.jl input.txt
    ```

7. F#
    ```bash
    $ fsi solution.fsx input.txt
    ```
    
8. Lua
    ```bash
    $ lua5.1 solution.lua input.txt
    ```

9. Kotlin
    ```bash
    $ kotlinc -script solution.kts input.txt
    ```
    
10. Elm
    ```bash
    $ elm-reactor
    ```
    Then, open http://localhost:8000/solution.elm in a browser.
    
11. Scala
    ```bash
    $ scala solution.scala input1.txt
    $ scala -J"-Xmx2048m" solution.scala input2.txt
    ```

12. Dart
    ```bash
    $ dart solution.dart input.txt
    ```

13. Java
    ```bash
    $ cd src && javac solution.java && java solution ../input.txt
    ```
  
14. Ruby
    ```bash
    $ ruby solution.rb input.txt
    ```

15. Haskell
    ```bash
    $ ghc solution.hs && ./solution input1.txt && ./solution input2.txt
    ```

16. Go
    ```bash
    $ go run solution.go input1.txt
    $ go run solution.go input2.txt
    ```

17. Clojure
    ```bash
    $ lein run input.txt
    ```


18. Elixir
    ```bash
    $ elixir solution.exs
    ```


20. C#
     ```bash
     $ mcs Solution.cs && mono Solution.exe
     ```

 ...  
     
     
22. Rust
     ```bash
     $ rustc solution.rs && ./solution input.txt
     ```

... 


24. Ceylon
    ```bash    
    $ ceylon run --compile=force solution
    ```

