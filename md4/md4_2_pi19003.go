/*
    Author: Pavels Ivanovs, pi19003
*/


package main

import (
    "fmt"
    "sync"
)

const (
    CANDY = 0
    COOKIE = 1

    SANTA_COUNT = 9
    BOX_COUNT = 7
    CANDIES_IN_BOX = 10
    COOKIES_IN_BOX = 14
    COLLECT_CANDIES_COUNT = 8
    COLLECT_COOKIES_COUNT = 11

    INPUT_CHANNEL = 0
    OUTPUT_CHANNEL = 1
)

var CHANNELS [BOX_COUNT][2][2] chan int


/*
    Function calculates weight of a package of a specified type.
*/
func getWeight(i int, productType int) int {
    if productType == CANDY {
        return getCandiesWeight(i)
    } else if productType == COOKIE {
        return getCookieWeight(i)
    } else {
        return 0
    }
}

/*
    Function calculates weight of candies package.
*/
func getCandiesWeight(i int) int {
    if i == 0 { 
        return 0 
    }
    return 300 + 50 * i
}

/*
    Function calculates weight of a cookies package.
*/
func getCookieWeight(i int) int {
    if i == 0 { 
        return 0 
    }
    return 200 + 50 * i
}

/*
    Function describes a box goroutine.

    In the begging the amount of candies and cookies packages is initialized,
    after which the goroutine is listening to requests via channels.

    If a box has some products it can give, the box passes the number of the package to its output channel
    and decreases the amount of specified product it has.
    If the box does not have any more of the specified products, it just returns 0 which is later
    processed by Santa.

    Box goroutines are not intended to finish on their own. WaitGroup terminates them.
*/
func box(id int) {
    candies, cookies := CANDIES_IN_BOX, COOKIES_IN_BOX

    // let's check if we have incoming requests
    for {
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
        default:
        }
    }
}

/*
    Function describes Santa goroutine.

    The goroutine works as such: the main cycle is being run until Santa collects all products of required amount
    or he cannot find the required products anymore.
    If a box has a required package. Santa adds it to his collection.
    When a box does not have a required product, Santa tries to search for the product in other boxes. If Santa has searched in all boxes
    and none of them have the desired product, Santa starts searching for another product or leaves the for loop, if Santa has already searched for all 
    types of products.
*/
func salavecis(id int, priorityType int) {
    weights := []int{0, 0}
    collected := []int{0, 0}

    to_collect_count := []int{COLLECT_CANDIES_COUNT, COLLECT_COOKIES_COUNT}

    changes := 0
    hasNotFoundInABoxCount := 0

    for (collected[CANDY]  < to_collect_count[CANDY]  || 
        collected[COOKIE] < to_collect_count[COOKIE]) && 
        changes < 2 {
        for box := 0; box < BOX_COUNT; box++ {
            CHANNELS[box][INPUT_CHANNEL][priorityType] <- 1
            receivedNum := <-CHANNELS[box][OUTPUT_CHANNEL][priorityType]
            if receivedNum != 0 {
                weights[priorityType] += getWeight(receivedNum, priorityType)
                collected[priorityType]++

                if collected[priorityType] == to_collect_count[priorityType] {
                    changes++
                    priorityType = (priorityType + 1) % 2

                    // found the required amount of BOTH products, so no need searchinhg anymore
                    if collected[CANDY] == to_collect_count[CANDY] && 
                        collected[COOKIE] == to_collect_count[COOKIE] {
                            break
                    }
                }
            } else { // the box does not have the requested product
                if hasNotFoundInABoxCount < BOX_COUNT { 
                    hasNotFoundInABoxCount++
                } else {
                    changes++
                    priorityType = (priorityType + 1) % 2
                    hasNotFoundInABoxCount = 0
                    if changes == 2 { break }   
                }
            }
        }
    }

    if collected[CANDY] == to_collect_count[CANDY] && collected[COOKIE] == to_collect_count[COOKIE] {
        fmt.Printf("Salatēvs #%d savāca %dg konfekšu un %dg cepumu. Dodas īstenot Ziemassvētku brīnumus!\n", 
            id, weights[CANDY], weights[COOKIE])
    } else {
        fmt.Printf("Salatēvam #%d pietrūka %d konfekšu un %d cepumu paciņas :(\n", 
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
        i := i
        go func() {
            box(i)
        }()
    }

    for i := 0; i < SANTA_COUNT; i++ {
        wg.Add(1)
        priorityProduct := CANDY
        if i > 3 { priorityProduct = COOKIE }

        i := i
        go func() {
            defer wg.Done()
            salavecis(i, priorityProduct)
        }()
    }    

    wg.Wait()
}