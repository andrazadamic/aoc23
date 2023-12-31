package day2

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

/*
    Resitev:
        1. 2207
        2. 62241
*/

Pull :: struct {
	id, red, green, blue: int
}

main :: proc() {
    file := "inputs/day2.input"
    part1(file)
    part2(file)
}

part1 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)

	if !ok {
		fmt.println("Failed to read file.")
		return
	}
	defer delete(data, context.allocator)

	it := string(data)

	maxPull := Pull {
        id    = 0,
		red   = 12,
		green = 13,
		blue  = 14,
	}

	sum := 0

	for line in strings.split_lines_iterator(&it) {
		input, _ := strings.split(line, ":")

		id, ok := strconv.parse_int(strings.split(input[0], " ")[1])
		inputs := strings.split(input[1], "; ")

		pulls := [dynamic]Pull{}

		for pull, i in inputs {
			append(&pulls, createPull(pull, id))
		}

        valid := true
		for pull, i in pulls {
			valid &= validate(pull, maxPull)
		}

        if valid {
            sum += id
        }
	}

	fmt.println(sum)
}

part2 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)

	if !ok {
		fmt.println("Failed to read file.")
		return
	}
	defer delete(data, context.allocator)

	it := string(data)

	maxPull := Pull {
        id    = 0,
		red   = 12,
		green = 13,
		blue  = 14,
	}

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


createPull :: proc(input: string, id: int) -> Pull {
	ret := Pull{
		id = id,
	}

	for c in strings.split(strings.trim(input, " "), ", ") {
		value, ok := strconv.parse_int(strings.split(c, " ")[0])
		colour := strings.split(c, " ")[1]

		switch colour {
		case "red":
			ret.red = value
		case "green":
			ret.green = value
		case "blue":
			ret.blue = value
		}
	}
	return ret
}

validate :: proc(pull: Pull, maxPull: Pull) -> bool {
	return pull.blue <= maxPull.blue && pull.green <= maxPull.green && pull.red <= maxPull.red
}
