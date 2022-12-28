package main

import (
	"fmt"
	"sync"
)

const CANDY = 0
const COOKIE = 1

const SANTA_COUNT = 2
// const SANTA_COUNT = 9
const BOX_COUNT = 3
// const BOX_COUNT = 7
const CANDIES_IN_BOX = 4
// const CANDIES_IN_BOX = 10
const COOKIES_IN_BOX = 5
// const COOKIES_IN_BOX = 14
const COLLECT_CANDIES_COUNT = 7
// const COLLECT_CANDIES_COUNT = 8
const COLLECT_COOKIES_COUNT = 8
// const COLLECT_COOKIES_COUNT = 11

const INPUT_CHANNEL = 0
const OUTPUT_CHANNEL = 1

var CHANNELS [BOX_COUNT][2][2] chan int


func getWeight(i int, productType int) int {
	if productType == CANDY {
		return getCandiesWeight(i)
	} else if productType == COOKIE {
		return getCookieWeight(i)
	} else {
		return 0
	}
}

func getCandiesWeight(i int) int {
	if i == 0 { return 0 }
	return 300 + 50 * i
}

func getCookieWeight(i int) int {
	if i == 0 { return 0 }
	return 200 + 50 * i
}

func box(id int) {
	candies, cookies := CANDIES_IN_BOX, COOKIES_IN_BOX

	// let's check if we have incoming requests
	for {
		// if the box has no more candies or cookies
		// we stop listening to the ports and finish the goroutine
		if cookies == 0 && candies == 0 {
			break
		}

		select {
		case <-CHANNELS[id][INPUT_CHANNEL][CANDY]:
			CHANNELS[id][OUTPUT_CHANNEL][CANDY] <- candies
			if candies != 0 {
				candies--
			}
		case <-CHANNELS[id][INPUT_CHANNEL][COOKIE]:
			CHANNELS[id][OUTPUT_CHANNEL][COOKIE] <- cookies
			if cookies != 0 {
				cookies--
			}
		}
	}
}

func salavecis(id int, priorityType int) {
	weights := []int{0, 0}
	collected := []int{0, 0}

	to_collect_count := []int{COLLECT_CANDIES_COUNT, COLLECT_COOKIES_COUNT}

	changes := 0

	for collected[CANDY]  < to_collect_count[CANDY]  && 
		collected[COOKIE] < to_collect_count[COOKIE] && 
		changes < 2 {
		for box := 0; box < BOX_COUNT; box++ {
			CHANNELS[box][INPUT_CHANNEL][priorityType] <- 0
			receivedNum := <-CHANNELS[box][OUTPUT_CHANNEL][priorityType]
			fmt.Printf("Debug: santa %d got %d num of %d from %d\n", id, receivedNum, priorityType, box)
			if receivedNum == 0 {
				changes++
				priorityType = (priorityType + 1) % 2
			} else {
				weights[priorityType] += getWeight(receivedNum, priorityType)
				collected[priorityType]++

				if collected[priorityType] == to_collect_count[priorityType] {
					changes++
					priorityType = (priorityType + 1) % 2
				}
			}
		}
	}

	if collected[CANDY] == to_collect_count[CANDY] && collected[COOKIE] == to_collect_count[COOKIE] {
		fmt.Printf("Salatēvs %d savāca %dg konfekšu un %dg cepumu. Dodas īstenot Ziemassvētku brīnumus!\n", 
			id, weights[CANDY], weights[COOKIE])
	} else {
		fmt.Printf("Salatēvam %d pietrūka %d konfekšu un %d cepumu paciņas :(\n", 
			id, (COLLECT_CANDIES_COUNT - collected[CANDY]), (COLLECT_COOKIES_COUNT - collected[COOKIE]))
	}
}

func main() {
	var wg sync.WaitGroup

	// initialization of channels 
	for i := 0; i < BOX_COUNT; i++ {
		for j := 0; j < 2; j++ {
			for k := 0; k < 2; k++ {
				CHANNELS[i][j][k] = make(chan int)  
			}
		}
	}

	for i := 0; i < BOX_COUNT; i++ {
		wg.Add(1)

		i := i
		go func() {
			defer wg.Done()
			box(i)
		}()
	}

	for i := 0; i < SANTA_COUNT; i++ {
		wg.Add(1)

		i := i
		go func() {
			defer wg.Done()
			priorityProduct := CANDY
			if i > 3 { priorityProduct = COOKIE }
			salavecis(i, priorityProduct)
		}()
	}	

	wg.Wait()
}