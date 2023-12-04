package day3

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

/*
    Resitev:
        1. 544664
        2. 84495585
*/

gear :: struct {
	col, row, count, mul: int,
}

main :: proc() {
	file := "inputs/day3.input"
	part1(file)
	part2(file)
}

part1 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read input file")
		return
	}
	defer delete(data, context.allocator)


	lines := strings.split(string(data), "\n")

	sum := 0
	current := ""

	for line, i in lines {
		j := 0
		for j < len(line) {
			if line[j] >= '0' && line[j] <= '9' {
				start := j
				for j < len(line) && line[j] >= '0' && line[j] <= '9' {
					j += 1
				}
				current = line[start:j]


				if (i > 0 && valid(lines[i - 1][start:j])) {
					sum += strconv.atoi(current)
				}
				if (i < len(lines) - 2 && valid(lines[i + 1][start:j])) {
					sum += strconv.atoi(current)
				}


				if (start > 0 && valid(lines[i][start - 1:start])) {
					sum += strconv.atoi(current)
				}
				if (j < len(lines[i]) - 2 && valid(lines[i][j:j + 1])) {
					sum += strconv.atoi(current)
				}


				if (i > 0 && start > 0 && valid(lines[i - 1][start - 1:start])) {
					sum += strconv.atoi(current)
				}
				if (i > 0 && j < len(lines[i - 1]) - 1 && valid(lines[i - 1][j:j + 1])) {
					sum += strconv.atoi(current)
				}
				if (i < len(lines) - 2 && start > 0 && valid(lines[i + 1][start - 1:start])) {
					sum += strconv.atoi(current)
				}
				if (i < len(lines) - 2 &&
					   j < len(lines[i + 1]) - 1 &&
					   valid(lines[i + 1][j:j + 1])) {
					sum += strconv.atoi(current)
				}
			}
			j += 1
		}
	}
	fmt.println(sum)
}

part2 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read input file")
		return
	}
	defer delete(data, context.allocator)


	lines := strings.split(string(data), "\n")

	sum := 0
	current := ""
	gears := [dynamic]gear{}

	for line, i in lines {
		j := 0
		for j < len(line) {
			if line[j] >= '0' && line[j] <= '9' {
				start := j
				for j < len(line) && line[j] >= '0' && line[j] <= '9' {
					j += 1
				}
				num := strconv.atoi(line[start:j])

				if (i > 0 && valid(lines[i - 1][start:j])) {
					for k in start ..< j {
						if (lines[i - 1][k] == '*') {
							increase_gear(i - 1, k, &gears, num)
						}
					}
				}
				if (i < len(lines) - 2 && valid(lines[i + 1][start:j])) {
					for k in start ..< j {
						if (lines[i + 1][k] == '*') {
							increase_gear(i + 1, k, &gears, num)
						}
					}
				}


				if (start > 0 && valid(lines[i][start - 1:start])) {
					if (lines[i][start - 1] == '*') {
						increase_gear(i, start - 1, &gears, num)
					}
				}
				if (j < len(lines[i]) - 2 && valid(lines[i][j:j + 1])) {
					if (lines[i][j] == '*') {
						increase_gear(i, j, &gears, num)
					}
				}


				if (i > 0 && start > 0 && valid(lines[i - 1][start - 1:start])) {
					if (lines[i - 1][start - 1] == '*') {
						increase_gear(i - 1, start - 1, &gears, num)
					}
				}
				if (i > 0 && j < len(lines[i - 1]) - 1 && valid(lines[i - 1][j:j + 1])) {
					if (lines[i - 1][j] == '*') {
						increase_gear(i - 1, j, &gears, num)
					}
				}
				if (i < len(lines) - 2 && start > 0 && valid(lines[i + 1][start - 1:start])) {
					if (lines[i + 1][start - 1] == '*') {
						increase_gear(i + 1, start - 1, &gears, num)
					}
				}
				if (i < len(lines) - 2 &&
					   j < len(lines[i + 1]) - 1 &&
					   valid(lines[i + 1][j:j + 1])) {
					if (lines[i + 1][j] == '*') {
						increase_gear(i + 1, j, &gears, num)
					}
				}
			}
			j += 1
		}
	}
	sum = 0
	for g in gears {
		if g.count == 2 {
			sum += g.mul
		}
	}
	fmt.println(sum)
}

increase_gear :: proc(i: int, j: int, gears: ^[dynamic]gear, num: int) {
	for k := 0; k < len(gears); k += 1 {
		if (gears[k].col == j && gears[k].row == i) {
			gears[k].count += 1
			gears[k].mul *= num
			return
		}
	}
	append(gears, gear{col = j, row = i, count = 1, mul = num})
}


valid :: proc(text: string) -> bool {
	for c in text {
		if c != '.' && (c < '0' || c > '9') {
			return true
		}
	}
	return false
}
