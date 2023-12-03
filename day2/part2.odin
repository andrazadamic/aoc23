package day2

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
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

	sum1 := 0
	sum2 := 0

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
            sum1 += id
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

		sum2 += minPull.red * minPull.green * minPull.blue
	}

	fmt.println("Prvi del:", sum1)
	fmt.println("Drugi del:", sum2)
}
