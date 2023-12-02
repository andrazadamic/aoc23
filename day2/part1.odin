package day2

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

Pull :: struct {
	id, red, green, blue: int
}

part1 :: proc() {
	data, ok := os.read_entire_file("inputs/day2.input", context.allocator)

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
