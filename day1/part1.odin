package day1

import "core:fmt"
import "core:os"
import "core:strings"


part1 :: proc() {
	data, ok := os.read_entire_file("inputs/day1.input", context.allocator)
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