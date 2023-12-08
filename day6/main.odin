package day6

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

/*
	Rezultati:
		1. 220320
		2. 34454849
*/

main :: proc() {
	file := "inputs/day6.input"
	part1(file)
	part2(file)
}

part1 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read file!")
		return
	}

	timesTemp := strings.split(
		strings.trim(strings.split(strings.split(string(data), "\n")[0], ":")[1], " "),
		" ",
	)
	dist2beatTemp := strings.split(
		strings.trim(strings.split(strings.split(string(data), "\n")[1], ":")[1], " "),
		" ",
	)

	times := [dynamic]int{}
	dist2beat := [dynamic]int{}

	for t in timesTemp {
		if t != "" {
			append(&times, strconv.atoi(t))
		}
	}

	for t in dist2beatTemp {
		if t != "" {
			append(&dist2beat, strconv.atoi(t))
		}
	}

	sum := 1

	for i in 0 ..< len(times) {
		innSum := 0
		for j in 0 ..= times[i] {
			if j + j * (times[i] - j - 1) > dist2beat[i] {
				innSum += 1
			}
		}
		if innSum > 0 {
			sum *= innSum
		}
	}

	fmt.println(sum)
}

part2 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read file!")
		return
	}

	timesTemp := strings.split(
		strings.trim(strings.split(strings.split(string(data), "\n")[0], ":")[1], " "),
		" ",
	)
	dist2beatTemp := strings.split(
		strings.trim(strings.split(strings.split(string(data), "\n")[1], ":")[1], " "),
		" ",
	)

	time := strconv.atoi(strings.join(timesTemp, ""))
	dist := strconv.atoi(strings.join(dist2beatTemp, ""))

	sum := 0
	for j in 0 ..= time / 2 {
		if j + j * (time - j - 1) > dist {
			sum += 2
		}
	}

	fmt.println(sum-1)
}
