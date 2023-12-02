package day2

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

part2 :: proc() {
	data, ok := os.read_entire_file("inputs/day2.input", context.allocator)

	if !ok {
		fmt.println("Failed to read file.")
		return
	}
	defer delete(data, context.allocator)

	it := string(data)

	sum := 0

	for line in strings.split_lines_iterator(&it) {
		input, _ := strings.split(line, ":")

		id, ok := strconv.parse_int(strings.split(input[0], " ")[1])
		inputs := strings.split(input[1], "; ")

		pulls := [dynamic]Pull{}

		for pull, i in inputs {
			append(&pulls, createPull(pull, id))
		}

		minPull := Pull {
			id    = 0,
			red   = 1,
			green = 1,
			blue  = 1,
		}

		for pull, i in pulls {
			if pull.red > minPull.red { minPull.red = pull.red }
			if pull.green > minPull.green { minPull.green = pull.green }
			if pull.blue > minPull.blue { minPull.blue = pull.blue }
		}

		sum += minPull.red * minPull.green * minPull.blue
	}

	fmt.println(sum)
}
