package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

const (
	puzzleInput = "priv/input.txt"
)

const (
	addr = iota
	addi
	mulr
	muli
	banr
	bani
	borr
	bori
	setr
	seti
	gtir
	gtri
	gtrr
	eqir
	eqri
	eqrr
)

func ExecOp(opcode int, a, b int, state []int) int {
	switch opcode {
	case addr:
		return state[a] + state[b]
	case addi:
		return state[a] + b
	case mulr:
		return state[a] * state[b]
	case muli:
		return state[a] * b
	case banr:
		return state[a] & state[b]
	case bani:
		return state[a] & b
	case borr:
		return state[a] | state[b]
	case bori:
		return state[a] | b
	case setr:
		return state[a]
	case seti:
		return a
	case gtir:
		if a > state[b] {
			return 1
		}
		return 0
	case gtri:
		if state[a] > b {
			return 1
		}
		return 0
	case gtrr:
		if state[a] > state[b] {
			return 1
		}
		return 0
	case eqir:
		if a == state[b] {
			return 1
		}
		return 0
	case eqri:
		if state[a] == b {
			return 1
		}
		return 0
	case eqrr:
		if state[a] == state[b] {
			return 1
		}
		return 0
	default:
		panic("invalid op")
	}
}

func ExecInstr(instr []int, state []int) []int {
	opcode := instr[0]
	a := instr[1]
	b := instr[2]
	c := instr[3]
	out := make([]int, len(state))
	copy(out, state)
	out[c] = ExecOp(opcode, a, b, state)
	return out
}

func parseInstrToCode(instr string) int {
	switch instr {
	case "addr":
		return addr
	case "addi":
		return addi
	case "mulr":
		return mulr
	case "muli":
		return muli
	case "banr":
		return banr
	case "bani":
		return bani
	case "borr":
		return borr
	case "bori":
		return bori
	case "setr":
		return setr
	case "seti":
		return seti
	case "gtir":
		return gtir
	case "gtri":
		return gtri
	case "gtrr":
		return gtrr
	case "eqir":
		return eqir
	case "eqri":
		return eqri
	case "eqrr":
		return eqrr
	default:
		panic("Invalid instr")
	}
}

func parseLine(line string) []int {
	k := strings.SplitN(line, " ", 2)
	var a, b, c int
	fmt.Sscanf(k[1], "%d %d %d", &a, &b, &c)
	return []int{parseInstrToCode(k[0]), a, b, c}
}

func main() {
	file, err := os.Open(puzzleInput)
	if err != nil {
		log.Fatal(err)
	}
	defer func() {
		if err := file.Close(); err != nil {
			log.Fatal(err)
		}
	}()

	scanner := bufio.NewScanner(file)

	if !scanner.Scan() {
		log.Fatal("Failed to read file")
	}
	var ipreg int
	fmt.Sscanf(scanner.Text(), "#ip %d", &ipreg)

	instructions := [][]int{}
	for scanner.Scan() {
		instructions = append(instructions, parseLine(scanner.Text()))
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	// debugger := bufio.NewScanner(os.Stdin)
	// debug := false
	// mode1 := false

	//part1 := 11474091
	part2 := 0

	last := 0
	seen := map[int]struct{}{}

	state := []int{part2, 0, 0, 0, 0, 0}
	for state[ipreg] > -1 && state[ipreg] < len(instructions) {
		state = ExecInstr(instructions[state[ipreg]], state)
		state[ipreg]++
		//if mode1 && state[2] == 28 {
		//	debug = true
		//}
		if state[4] == 28 {
			if _, ok := seen[state[3]]; ok {
				fmt.Println(last)
				break
			}
			seen[state[3]] = struct{}{}
			last = state[3]
		}
		// if mode1 && debug {
			// fmt.Println(state)
			// debugger.Scan()
		// }
	}
}
