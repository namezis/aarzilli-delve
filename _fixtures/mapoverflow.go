package main

import "runtime"

func main() {
	m := map[int]int{}
	for i := 0; i < 800; i++ {
		m[i] = i
	}
	runtime.Breakpoint()
}
