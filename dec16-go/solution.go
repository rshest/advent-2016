package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

func solve(seed string, length int) string {
	b := make([]byte, length)

	// initialize with the seed
	k := len(seed)
	for i := 0; i < k; i++ {
		if seed[i] == '1' {
			b[i] = 1
		}
	}

	// do the memory fill
	for k < length {
		b[k] = 0 // "0" in the middle
		end := k*2 + 1
		if end > length {
			end = length
		}
		for j := k + 1; j < end; j++ {
			b[j] = 1 - b[2*k-j]
		}
		k = end
	}

	// compute the checksum
	for k%2 == 0 {
		for j := 0; j < k; j += 2 {
			if b[j] == b[j+1] {
				b[j/2] = 1
			} else {
				b[j/2] = 0
			}
		}
		k = k / 2
	}

	// compose the result
	s := ""
	for i := 0; i < k; i++ {
		if b[i] == 1 {
			s += "1"
		} else {
			s += "0"
		}
	}
	return s
}


func main() {
	fname := "input1.txt"
	if len(os.Args) > 1 {
		fname = os.Args[1]
	}

	data, _ := ioutil.ReadFile(fname)
	str := strings.Split(string(data), " ")

	length, _ := strconv.Atoi(str[0])
	seed := str[1]

	fmt.Printf("Correct checksum: %s\n", solve(seed, length))
}
