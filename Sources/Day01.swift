import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func parse(_ data: String) -> [[Int]] {
    let lines = data.split(separator: "\n")

    var left: [Int] = []
    var right: [Int] = []

    for line in lines {
      let parts = line.split(separator: " ")
      if let firstPart = parts.first, let number = Int(firstPart) {
        left.append(number)
      }
      if let secondPart = parts.last, let number = Int(secondPart) {
        right.append(number)
      }
    }
    return [left, right]
  }


  func part1() -> Any {
    let input = parse(data)
    guard input.count == 2, let left = input.first?.sorted(), let right = input.last?.sorted() else {
      assertionFailure("Problem with parsing")
      return -1
    }

    guard left.count == right.count else {
      assertionFailure("Arrays have different size")
      return -1
    } 

    var answer = 0
    for (a, b) in zip(left, right) {
      answer += abs(a - b)
    }
    return answer
  }

  func part2() -> Any {
    let input = parse(data)
    guard input.count == 2, let left = input.first, let right = input.last else {
      assertionFailure("Problem with parsing")
      return -1
    }

    var counter: [Int: Int] = [:]
    for num in right {
      counter[num] = counter[num, default: 0] + 1
    }
    
    var answer = 0
    for num in left {
      if let count = counter[num] {
        answer += num * count
      }
    }
    return answer
  }
}
