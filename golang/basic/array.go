package main
import "fmt"

func modify(array [5]int) {
	// 试图修改数组的第一个元素
	array[0] = 10
	fmt.Println("In modify(), array values:", array)
}

func main() {
	// 定义并初始化一个数组
	array := [5]int{1,2,3,4,5}
	// 传递给一个函数，并试图在函数体内修改这个数组内容
	modify(array)
	fmt.Println("In main(), array values:", array)
}