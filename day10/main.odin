package day10

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
	file := "inputs/day10.input"
	part1(file)
}

part1 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read file")
		return
	}

	lines := strings.split(string(data), "\n")

	count := 0
	x := 0
	y := 0
	lx := 0
	ly := 0

	for line, i in lines {
		y = i
		for c, j in line {
			x = j
			if c == 'S' {
				if y > 0 &&
				   (lines[y - 1][x] == '|' || lines[y - 1][x] == 'F' || lines[y - 1][x] == '7') {
					count += 1
					y -= 1
				} else if x > 0 &&
				   (lines[y][x - 1] == '-' || lines[y][x - 1] == 'L' || lines[y][x - 1] == 'F') {
					count += 1
					x -= 1
				} else if x < len(lines[y]) - 1 &&
				   (lines[y][x + 1] == '-' || lines[y][x + 1] == '7' || lines[y][x + 1] == 'J') {
					count += 1
					x += 1
				} else if y < len(lines) - 1 &&
				   (lines[y + 1][x] == '|' || lines[y + 1][x] == 'L' || lines[y + 1][x] == 'J') {
					count += 1
					y += 1
				}
				for lines[y][x] != 'S' && (x != lx || y != ly) {
					fmt.println(rune(lines[y][x]), y, x, ly, lx, count)
					switch lines[y][x] {
					case '|':
						if y > 0 &&
						   y - 1 != ly &&
						   (lines[y - 1][x] == '|' ||
								   lines[y - 1][x] == 'F' ||
								   lines[y - 1][x] == '7' ||
								   lines[y - 1][x] == 'S') {
							count += 1
							ly = y
							lx = x
							y -= 1
						} else if y < len(lines) - 1 &&
						   y + 1 != ly &&
						   (lines[y + 1][x] == '|' ||
								   lines[y + 1][x] == 'L' ||
								   lines[y + 1][x] == 'J' ||
								   lines[y + 1][x] == 'S') {
							count += 1
							ly = y
							lx = x
							y += 1
						}
					case '-':
						if x > 0 &&
						   x - 1 != lx &&
						   (lines[y][x - 1] == '-' ||
								   lines[y][x - 1] == 'L' ||
								   lines[y][x - 1] == 'F' ||
								   lines[y][x - 1] == 'S') {
							count += 1
							ly = y
							lx = x
							x -= 1
						} else if x < len(lines[y]) - 1 &&
						   x + 1 != lx &&
						   (lines[y][x + 1] == '-' ||
								   lines[y][x + 1] == '7' ||
								   lines[y][x + 1] == 'J' ||
								   lines[y][x + 1] == 'S') {
							count += 1
							ly = y
							lx = x
							x += 1
						}
					case 'L':
						if x < len(lines[y]) &&
						   x + 1 != lx &&
						   (lines[y][x + 1] == '-' ||
								   lines[y][x + 1] == '7' ||
								   lines[y][x + 1] == 'J' ||
								   lines[y][x + 1] == 'S') {
							count += 1
							ly = y
							lx = x
							x += 1
						} else if y > 0 &&
						   y - 1 != ly &&
						   (lines[y - 1][x] == '|' ||
								   lines[y - 1][x] == 'F' ||
								   lines[y - 1][x] == '7' ||
								   lines[y - 1][x] == 'S') {
							count += 1
							ly = y
							lx = x
							y -= 1
						}
					case 'J':
						if x > 0 &&
						   x - 1 != lx &&
						   (lines[y][x - 1] == '-' ||
								   lines[y][x - 1] == 'F' ||
								   lines[y][x - 1] == 'L' ||
								   lines[y][x - 1] == 'S') {
							count += 1
							ly = y
							lx = x
							x -= 1
						} else if y > 0 &&
						   y - 1 != ly &&
						   (lines[y - 1][x] == '|' ||
								   lines[y - 1][x] == 'F' ||
								   lines[y - 1][x] == '7' ||
								   lines[y - 1][x] == 'S') {
							count += 1
							ly = y
							lx = x
							y -= 1
						}
					case 'F':
						if x < len(lines[y]) &&
						   x + 1 != lx &&
						   (lines[y][x + 1] == '-' ||
								   lines[y][x + 1] == '7' ||
								   lines[y][x + 1] == 'J' ||
								   lines[y][x + 1] == 'S') {
							count += 1
							ly = y
							lx = x
							x += 1
						} else if y < len(lines) &&
						   y + 1 != ly &&
						   (lines[y + 1][x] == '|' ||
								   lines[y + 1][x] == 'L' ||
								   lines[y + 1][x] == 'J' ||
								   lines[y + 1][x] == 'S') {
							count += 1
							ly = y
							lx = x
							y += 1
						}
					case '7':
						if x > 0 &&
						   x - 1 != lx &&
						   (lines[y][x - 1] == '-' ||
								   lines[y][x - 1] == 'L' ||
								   lines[y][x - 1] == 'F' ||
								   lines[y][x - 1] == 'S') {
							count += 1
							ly = y
							lx = x
							x -= 1
						} else if y < len(lines) &&
						   y + 1 != ly &&
						   (lines[y + 1][x] == '|' ||
								   lines[y + 1][x] == 'L' ||
								   lines[y + 1][x] == 'J' ||
								   lines[y + 1][x] == 'S') {
							count += 1
							ly = y
							lx = x
							y += 1
						}
					}
				}
				fmt.println(rune(lines[y][x]), y, x, ly, lx, count)
				fmt.println(count / 2.0)
				return
			}
		}
	}
}
