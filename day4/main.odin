package day4

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"

/*
	Resitev:
		1. 26426
		2. 6227972
*/


card :: struct {
	id, count, winnings: int,
}

main :: proc() {
    file := "inputs/day4.input"
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

	sum := 0

	for line, i in strings.split(string(data), "\n") {
		nums := strings.split(line, ":")[1]
		winning := string_to_list(strings.split(nums, "|")[0])
		my := string_to_list(strings.split(nums, "|")[1])

        count := check_equal(winning, my)
        if count == 0 { continue }
		sum += int(math.pow_f16(2.0, f16(count - 1))) 
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

	sum := 0
    cards := [dynamic]card{}

	for line, i in strings.split(string(data), "\n") {
		nums := strings.split(line, ":")[1]
		winning := string_to_list(strings.split(nums, "|")[0])
		my := string_to_list(strings.split(nums, "|")[1])

        winnings := check_equal(winning, my)
        if winnings < 1 { winnings = 0}

        append(&cards, card{id = i, count = 1, winnings = winnings})
	}

    for c, i in cards {
        sum += c.count
        for p in i+1..=i+c.winnings {
            cards[p].count += c.count
        }
    }

	fmt.println(sum)
}

string_to_list :: proc(str: string) -> [dynamic]int {
	list: [dynamic]int
	for i in strings.split(strings.trim(str, " "), " ") {
		if i != "" {
			append(&list, strconv.atoi(i))
		}
	}
	return list
}

check_equal :: proc(winning: [dynamic]int, my: [dynamic]int) -> int {
	count := 0
	for w, i in winning {
		for j in my {
			if w == j {
				count += 1
			}
		}
	}
	return count
}
