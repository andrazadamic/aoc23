package day4

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"

card :: struct {
	id, count, winnings: int,
}

main :: proc() {
	data, ok := os.read_entire_file("../inputs/test", context.allocator)
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
