
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
    
9. Elm
    ```bash
    $ elm-reactor
    ```
    Then, open http://localhost:8000/solution.elm in a browser.
