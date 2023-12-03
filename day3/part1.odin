package day3

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

// solution: 544664
part1 :: proc() {
	data, ok := os.read_entire_file("../inputs/day3.input", context.allocator)
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

valid :: proc(text: string) -> bool {
	for c in text {
		if c != '.' && (c < '0' || c > '9') {
			return true
		}
	}
	return false
}
