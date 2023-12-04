package day1

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

/*
    Resitev:
        1. 54951
        2. 55218
*/

main :: proc() {
    file := "inputs/day1.input"
    part1(file)
    part2(file)
}

part1 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.print("Failed to read file")
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	sum := 0

	for line in strings.split_lines_iterator(&it) {
		numbers: [dynamic]rune
		for c in line {
			if c >= '0' && c <= '9' {
                append(&numbers, c)
            }
		}
		
		sum += 10 * (int(numbers[0]) - 48) + int(numbers[len(numbers) - 1] - 48)
	}
	fmt.println(sum)
}

part2 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.print("Failed to read file")
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	sum := 0
	con := false

	for line in strings.split_lines_iterator(&it) {
		numbers: [dynamic]rune
		curr := [dynamic]rune{}
		for c in line {
			if con {
				if (string_to_digit(curr) > '0') {
					append(&numbers, string_to_digit(curr))
					con = false
				} else {
					if c >= '0' && c <= '9' {
						con = false
						append(&numbers, c)
					} else {
						append(&curr, c)
					}
					continue
				}
			}

			if c >= '0' && c <= '9' {
				append(&numbers, c)
			} else if (c >= 'a' && c <= 'z') {
				append(&curr, c)
				con = true
			}
		}
		if (con) {
			if (string_to_digit(curr) > '0') {
				append(&numbers, string_to_digit(curr))
			}
		}
		sum += 10 * (int(numbers[0]) - 48) + int(numbers[len(numbers) - 1] - 48)
	}
	fmt.println(sum)
}

string_to_digit :: proc(t: [dynamic]rune) -> rune {
	for i in 0 ..< len(t) {
		switch utf8.runes_to_string(t[i:]) {
		case "one":
			return '1'
		case "two":
			return '2'
		case "three":
			return '3'
		case "four":
			return '4'
		case "five":
			return '5'
		case "six":
			return '6'
		case "seven":
			return '7'
		case "eight":
			return '8'
		case "nine":
			return '9'
		}
	}
	return '0'
}
