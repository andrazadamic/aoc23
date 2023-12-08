package day7

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:time"

/*
	Rezultati:
		1. 251029473
*/

cardType :: enum {
	R,
	B,
	C,
	F,
	D,
	S,
	E,
	N,
	T,
	J,
	Q,
	K,
	A,
}

main :: proc() {
	file := "inputs/day7.input"
	start := time.now()
	part1(file)
	fmt.println("Part 1 took ", time.since(start))
	part2(file)
}

part1 :: proc(file: string) {
	data, ok := os.read_entire_file(file, context.allocator)
	if !ok {
		fmt.println("Failed to read file")
		return
	}

	// first cell of array is the bid, second is the type of hand 
	// (five of a kind, four of a kind, full house, three of a kind, two pair, one pair, high card)
	// (7            , 6             , 5         , 4              , 3       , 2       , 1        )
	hands := make(map[string][2]int)

	for line in strings.split(string(data), "\n") {
		hand := strings.split(line, " ")[0]
		bet := strconv.atoi(strings.split(line, " ")[1])
		type := check_hand(hand)
		hands[hand] = [2]int{bet, type}
	}

	// sort the hands by the type of hand
	sorted := [dynamic]string{}
	for hand in hands {
		append(&sorted, hand)
	}

	for i in 0 ..< len(sorted) {
		min := sorted[i]
		minI := i
		for j in i ..< len(sorted) {
			s := sort(hands[min], sorted[minI], hands[sorted[j]], sorted[j])
			if s == -1 {
				min = sorted[j]
				minI = j
			}
		}
		t := sorted[i]
		sorted[i] = sorted[minI]
		sorted[minI] = t
	}

	sum := 0
	for i in 0 ..< len(sorted) {
		sum += hands[sorted[i]][0] * (len(sorted) - i)
	}

	fmt.println(sum)
}

part2 :: proc(file: string) {

}

check_hand :: proc(hand: string) -> int {
	cards := []rune{'A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'}
	count := []int{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	for c, i in cards {
		for j in hand {
			if j == c {
				count[i] += 1
			}
		}
	}
	hand := 1
	for i in count {
		if i == 5 {
			return 7
		}
		if i == 4 {
			return 6
		}
		if i == 3 {
			hand += 3
		}
		if i == 2 {
			hand += 1
		}
	}
	return hand
}

sort :: proc(a: [2]int, as: string, b: [2]int, bs: string) -> int {
	if a[1] > b[1] {
		return 1
	}
	if a[1] < b[1] {
		return -1
	}
	if a[1] == b[1] {
		for i in 0 ..< len(as) {
			if as[i] == bs[i] {
				continue
			}
			if check_card_type(rune(as[i])) < check_card_type(rune(bs[i])) {
				return -1
			}
			if check_card_type(rune(as[i])) > check_card_type(rune(bs[i])) {
				return 1
			}
		}
	}
	return 0
}

check_card_type :: proc(x: rune) -> cardType {
	switch (x) {
	case 'A':
		return cardType.A
	case 'K':
		return cardType.K
	case 'Q':
		return cardType.Q
	case 'J':
		return cardType.J
	case 'T':
		return cardType.T
	case '9':
		return cardType.N
	case '8':
		return cardType.E
	case '7':
		return cardType.S
	case '6':
		return cardType.D
	case '5':
		return cardType.F
	case '4':
		return cardType.C
	case '3':
		return cardType.B
	case '2':
		return cardType.R
	}
	return cardType.B
}
