package day5

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:time"

/*
	Ne gledat prvega dela, nism su popravlat po tem k sm drugo naredu
	Rezulati:
		1. 240320250
		2. 28580589
*/


seed :: struct {
	seed, soil, fertilizer, water, light, temperature, humidity, location: int,
}

range :: struct {
	start, len: int,
}

trans :: struct {
	type:              stage,
	start, len, trans: int,
}

stage :: enum {
	s2s,
	s2f,
	f2w,
	w2l,
	l2t,
	t2h,
	h2l,
}

thread_args :: struct {
	id:              int,
	seeds:           [^]range,
	transformations: [dynamic]trans,
	min:             ^[8]int,
	len:             int,
}

main :: proc() {
	file := "inputs/day5.input"
	part1(file)
	part2(file)
}

part1 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read file")
		return
	}
	defer delete(data, context.allocator)

	seeds := [dynamic]seed{}

	lines, _ := strings.split(string(data), "\n")

	for line, i in lines {

		switch strings.split(line, ":")[0] {
		case "seeds":
			temp := strings.split(strings.split(line, ": ")[1], " ")
			for t in temp {
				s := strconv.atoi(t)
				append(
					&seeds,
					seed{
						seed = s,
						soil = s,
						fertilizer = s,
						water = s,
						light = s,
						temperature = s,
						humidity = s,
						location = s,
					},
				)
			}
		case "seed-to-soil map":
			j := i + 1

			for lines[j] != "" {
				temp := strings.split(lines[j], " ")

				for s, i in seeds {
					if s.seed >= strconv.atoi(temp[1]) &&
					   s.seed < strconv.atoi(temp[1]) + strconv.atoi(temp[2]) {
						seeds[i].soil = s.seed - strconv.atoi(temp[1]) + strconv.atoi(temp[0])
					}
				}
				j += 1
			}
			for s, i in seeds {
				if s.soil == s.seed {
					seeds[i].soil = s.seed
				}
			}

		case "soil-to-fertilizer map":
			j := i + 1

			for lines[j] != "" {
				temp := strings.split(lines[j], " ")

				for s, i in seeds {
					if s.soil >= strconv.atoi(temp[1]) &&
					   s.soil < strconv.atoi(temp[1]) + strconv.atoi(temp[2]) {
						seeds[i].fertilizer =
							s.soil - strconv.atoi(temp[1]) + strconv.atoi(temp[0])
					}
				}
				j += 1
			}
			for s, i in seeds {
				if s.fertilizer == s.seed {
					seeds[i].fertilizer = s.soil
				}
			}

		case "fertilizer-to-water map":
			j := i + 1

			for lines[j] != "" {
				temp := strings.split(lines[j], " ")

				for s, i in seeds {
					if s.fertilizer >= strconv.atoi(temp[1]) &&
					   s.fertilizer < strconv.atoi(temp[1]) + strconv.atoi(temp[2]) {
						seeds[i].water =
							s.fertilizer - strconv.atoi(temp[1]) + strconv.atoi(temp[0])
					}
				}
				j += 1
			}
			for s, i in seeds {
				if s.water == s.seed {
					seeds[i].water = s.fertilizer
				}
			}

		case "water-to-light map":
			j := i + 1

			for lines[j] != "" {
				temp := strings.split(lines[j], " ")

				for s, i in seeds {
					if s.water >= strconv.atoi(temp[1]) &&
					   s.water < strconv.atoi(temp[1]) + strconv.atoi(temp[2]) {
						seeds[i].light = s.water - strconv.atoi(temp[1]) + strconv.atoi(temp[0])
					}
				}
				j += 1
			}
			for s, i in seeds {
				if s.light == s.seed {
					seeds[i].light = s.water
				}
			}

		case "light-to-temperature map":
			j := i + 1

			for lines[j] != "" {
				temp := strings.split(lines[j], " ")

				for s, i in seeds {
					if s.light >= strconv.atoi(temp[1]) &&
					   s.light < strconv.atoi(temp[1]) + strconv.atoi(temp[2]) {
						seeds[i].temperature =
							s.light - strconv.atoi(temp[1]) + strconv.atoi(temp[0])
					}
				}
				j += 1
			}
			for s, i in seeds {
				if s.temperature == s.seed {
					seeds[i].temperature = s.light
				}
			}

		case "temperature-to-humidity map":
			j := i + 1

			for lines[j] != "" {
				temp := strings.split(lines[j], " ")

				for s, i in seeds {
					if s.temperature >= strconv.atoi(temp[1]) &&
					   s.temperature < strconv.atoi(temp[1]) + strconv.atoi(temp[2]) {
						seeds[i].humidity =
							s.temperature - strconv.atoi(temp[1]) + strconv.atoi(temp[0])
					}
				}
				j += 1
			}
			for s, i in seeds {
				if s.humidity == s.seed {
					seeds[i].humidity = s.temperature
				}
			}

		case "humidity-to-location map":
			j := i + 1

			for j < len(lines) && lines[j] != "" {
				temp := strings.split(lines[j], " ")

				for s, i in seeds {
					if s.humidity >= strconv.atoi(temp[1]) &&
					   s.humidity < strconv.atoi(temp[1]) + strconv.atoi(temp[2]) {
						seeds[i].location =
							s.humidity - strconv.atoi(temp[1]) + strconv.atoi(temp[0])
					}
				}
				j += 1
			}
			for s, i in seeds {
				if s.location == s.seed {
					seeds[i].location = s.humidity
				}
			}
		}
	}
	min := 999999999999
	for s in seeds {
		if s.location < min {
			min = s.location
		}
	}
	fmt.println(min)
}

part2 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read file")
		return
	}
	defer delete(data, context.allocator)

	seeds := [dynamic]range{}
	transformations := [dynamic]trans{}

	lines, _ := strings.split(string(data), "\n")

	temp := strings.split(strings.split(lines[0], ": ")[1], " ")

	for i := 0; i < len(temp) - 1; i += 2 {
		append(&seeds, range{start = strconv.atoi(temp[i]), len = strconv.atoi(temp[i + 1])})
	}

	i := 0
	for i < len(lines) {
		line := lines[i]
		switch strings.split(strings.trim(line, ":"), " ")[0] {
		case "seed-to-soil":
			i += 1
			for i < len(lines) && lines[i] != "" {
				lineT := strings.split(lines[i], " ")
				append(
					&transformations,
					trans{
						type = stage.s2s,
						start = strconv.atoi(lineT[1]),
						len = strconv.atoi(lineT[2]),
						trans = strconv.atoi(lineT[0]),
					},
				)
				i += 1
			}
		case "soil-to-fertilizer":
			i += 1
			for i < len(lines) && lines[i] != "" {
				lineT := strings.split(lines[i], " ")
				append(
					&transformations,
					trans{
						type = stage.s2f,
						start = strconv.atoi(lineT[1]),
						len = strconv.atoi(lineT[2]),
						trans = strconv.atoi(lineT[0]),
					},
				)
				i += 1
			}
		case "fertilizer-to-water":
			i += 1
			for i < len(lines) && lines[i] != "" {
				lineT := strings.split(lines[i], " ")
				append(
					&transformations,
					trans{
						type = stage.f2w,
						start = strconv.atoi(lineT[1]),
						len = strconv.atoi(lineT[2]),
						trans = strconv.atoi(lineT[0]),
					},
				)
				i += 1
			}
		case "water-to-light":
			i += 1
			for i < len(lines) && lines[i] != "" {
				lineT := strings.split(lines[i], " ")
				append(
					&transformations,
					trans{
						type = stage.w2l,
						start = strconv.atoi(lineT[1]),
						len = strconv.atoi(lineT[2]),
						trans = strconv.atoi(lineT[0]),
					},
				)
				i += 1
			}
		case "light-to-temperature":
			i += 1
			for i < len(lines) && lines[i] != "" {
				lineT := strings.split(lines[i], " ")
				append(
					&transformations,
					trans{
						type = stage.l2t,
						start = strconv.atoi(lineT[1]),
						len = strconv.atoi(lineT[2]),
						trans = strconv.atoi(lineT[0]),
					},
				)
				i += 1
			}
		case "temperature-to-humidity":
			i += 1
			for i < len(lines) && lines[i] != "" {
				lineT := strings.split(lines[i], " ")
				append(
					&transformations,
					trans{
						type = stage.t2h,
						start = strconv.atoi(lineT[1]),
						len = strconv.atoi(lineT[2]),
						trans = strconv.atoi(lineT[0]),
					},
				)
				i += 1
			}
		case "humidity-to-location":
			i += 1
			for i < len(lines) && lines[i] != "" {
				lineT := strings.split(lines[i], " ")
				append(
					&transformations,
					trans{
						type = stage.h2l,
						start = strconv.atoi(lineT[1]),
						len = strconv.atoi(lineT[2]),
						trans = strconv.atoi(lineT[0]),
					},
				)
				i += 1
			}
		}
		i += 1
	}


	min := 999999999

	for x in stage {
		// fmt.println("---", x, "---")
		for s, i in seeds {
			// fmt.println("s", s)
			for t in transformations {
				if x == t.type {
					// fmt.println(s)
					if s.start >= t.start && s.start + s.len <= t.start + t.len {
						seeds[i].start = s.start - t.start + t.trans
						// fmt.println("a", seeds[i], s, t)
						break
					} else if s.start < t.start &&
					   s.start + s.len <= t.start + t.len &&
					   s.start + s.len > t.start {
						append(&seeds, range{start = s.start, len = t.start - s.start})
						seeds[i].start = t.trans
						seeds[i].len = s.len - (t.start - s.start)
						// fmt.println("b", seeds[i], s, t)
						break
					} else if s.start >= t.start &&
					   s.start + s.len > t.start + t.len &&
					   s.start < t.start + t.len {
						seeds[i].len = t.start + t.len - s.start
						append(&seeds, range{start = t.start + t.len, len = s.len - seeds[i].len})
						seeds[i].start = s.start - t.start + t.trans
						// fmt.println("c", seeds[i], s, t)
						break
					} else if s.start < t.start && s.start + s.len > t.start + t.len {
						append(&seeds, range{start = s.start, len = t.start - s.start})
						seeds[i].len = t.start + t.len - s.start
						append(
							&seeds,
							range{
								start = t.start + t.len,
								len = s.len - seeds[i].len - t.start + s.start,
							},
						)
						seeds[i].start = s.start - t.start + t.trans
						// fmt.println("d", seeds[i], s, t)
						break
					}
				}
			}
			// fmt.println(s)
		}
	}

	for s in seeds {
		if s.start < min {
			min = s.start
		}
	}

	// fmt.println(seeds)
	fmt.println(min)

}
