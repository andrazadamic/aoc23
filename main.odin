package main

import "core:fmt"
import "core:os"

import "day1"
import "day10"
import "day2"
import "day3"
import "day4"
import "day5"
import "day6"
import "day7"
import "day8"
import "day9"

main :: proc() {
	if (len(os.args)) == 1 {
		fmt.println("You need to add argument if you want to run part 1 or part 2")
		return
	}

	switch (os.args[1]) {
	case "1":
		day1.main()
	case "2":
		day2.main()
	case "3":
		day3.main()
	case "4":
		day4.main()
	case "5":
		day5.main()
	case "6":
		day6.main()
	case "7":
		day7.main()
	case "8":
		day8.main()
	case "9":
		day9.main()
	case "10":
		day10.main()
	case:
		fmt.println("You need to add argument if you want to run part 1 or part 2")

	}
}
