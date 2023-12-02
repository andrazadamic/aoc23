package main

import "core:fmt"
import "core:os"

import "day1"
import "day2"

main :: proc() {
	if (len(os.args)) == 2 {
		fmt.println("You need to add argument if you want to run part 1 or part 2")
		return
	}

	switch (os.args[1]) {
	case "1":
		if (os.args[2] == "1") {
			day1.part1()
		} else {
			day1.part2()
		}
	case "2":
		if (os.args[2] == "1") {
			day2.part1()
		} else {
			day2.part2()
		}
	case:
		fmt.println("You need to add argument if you want to run part 1 or part 2")

	}
}
