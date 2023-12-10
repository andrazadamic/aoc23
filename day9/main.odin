package day9

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	file := "inputs/day9.input"
	part1(file)
    part2(file)
}

part1 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read file")
		return
	}

	sum := 0
	for line in strings.split(string(data), "\n") {
		nums := [dynamic]int{}
		for num in strings.split(line, " ") {
            append(&nums, strconv.atoi(num))
		}
        _, r := carry(nums)
        sum += r
	}
    fmt.println(sum)
}

part2 :: proc(file: string) {
    data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read file")
		return
	}

	sum := 0
	for line in strings.split(string(data), "\n") {
		nums := [dynamic]int{}
		for num in strings.split(line, " ") {
            append(&nums, strconv.atoi(num))
		}
        l, _ := carry(nums)
        sum += l
	}
    fmt.println(sum)
}

allZero :: proc(nums: [dynamic]int) -> bool {
	for num in nums {
		if num != 0 {
			return false
		}
	}
	return true
}

carry :: proc(nums: [dynamic]int) -> (int, int) {
    if allZero(nums) {
        return 0, 0
    }
    n := [dynamic]int{}
    for i in 0..<len(nums)-1 {
        append(&n, nums[i+1] - nums[i])
    }
    l, r := carry(n)
    return nums[0] - l, r + nums[len(nums)-1]
}