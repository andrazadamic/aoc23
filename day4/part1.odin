package day4

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"

part1 :: proc() {
	data, ok := os.read_entire_file("inputs/day4.input", context.allocator)
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
		sum += int(math.pow_f16(f16(check_equal(winning, my)), 2)) 
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
