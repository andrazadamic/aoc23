package day8

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:math"

/*
    Rezultati:
        1. 20513
        2. 15995167053923
*/

instruction :: struct {
	L, R: string,
}

main :: proc() {
	file := "inputs/day8.input"
	// file := "inputs/test"
	part1(file)
	part2(file)
}

part1 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Error reading file")
		return
	}
	defer delete(data, context.allocator)

	lines := strings.split(string(data), "\n")
	path := lines[0]
	instructions := make(map[string]instruction)

	for i in 1 ..< len(lines) {
		if lines[i] == "" {continue}
		parts := strings.split(lines[i], " = ")
		LR := strings.split(strings.trim(parts[1], "()"), ", ")
		instructions[parts[0]] = instruction{LR[0], LR[1]}
	}

	cont := true
	curr := "AAA"
	count := 0

	for cont {
		for p in path {
			if p == 'L' {
				curr = instructions[curr].L
			} else {
				curr = instructions[curr].R
			}
			count += 1
			if curr == "ZZZ" {
				cont = false
				break
			}
		}
	}

	fmt.println(count)
}

part2 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Error reading file")
		return
	}
	defer delete(data, context.allocator)

	lines := strings.split(string(data), "\n")
	path := lines[0]
	instructions := make(map[string]instruction)

	for i in 1 ..< len(lines) {
		if lines[i] == "" {continue}
		parts := strings.split(lines[i], " = ")
		LR := strings.split(strings.trim(parts[1], "()"), ", ")
		instructions[parts[0]] = instruction{LR[0], LR[1]}
	}

	cont := true
	counts := [dynamic]int{}
	curr := [dynamic]string{}

	for i in instructions {
		if i[2] == 'A' {
			append(&curr, i)
		}
	}

	for c in instructions {
        curr := c
        if curr[2] == 'A' {
            count := 0
            for curr[2] != 'Z' {
                p := path[(count) % len(path)]
                if p == 'L' {
                    curr = instructions[curr].L
                } else {
                    curr = instructions[curr].R
                }
                count += 1
            }
            append(&counts, count)
        }
	}

    lcm := counts[0]
    for i in 1..< len(counts) {
        lcm = math.lcm(lcm, counts[i])
    }
    fmt.println(lcm)
}
