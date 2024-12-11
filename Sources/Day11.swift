import Algorithms
import DequeModule
import Foundation

struct Day11: AdventDay, @unchecked Sendable {
  var data: String

  struct Key: Hashable {
    let stone: Int
    let steps: Int
  }

  func part1() -> Any {
    let stones = parseInput()

    var cache: [Key: Int] = [:]
    var answer = 0
    for stone in stones {
      answer += processStone(stone, 25, &cache)
    }

    return answer
  }
  
  func part2() -> Any {
    let stones = parseInput()

    var answer = 0
    var cache: [Key: Int] = [:]
    for stone in stones {
      answer += processStone(stone, 75, &cache)
    }

    return answer
  }

  func processStone(_ stone: Int, _ count: Int, _ cache: inout [Key: Int]) -> Int {
    guard count != 0 else { return 1 }

    let key = Key(stone: stone, steps: count)
    if let answer = cache[key] {
      return answer
    }

    let answer: Int
    if stone == 0 {
      answer = processStone(1, count - 1, &cache)
    } else if canSplitStoneInTwo(stone) { 
      let (first, second) = splitStone(stone)
      answer = processStone(first, count - 1, &cache) + processStone(second, count - 1, &cache)
    } else {
      answer = processStone(stone * 2024, count - 1, &cache)
    }
    cache[key] = answer
    return answer
  }

  func canSplitStoneInTwo(_ stone: Int) -> Bool {
    return stone.dgtCount % 2 == 0
  }

  func splitStone(_ stone: Int) -> (Int, Int) {
    let divisor = 10.pow(stone.dgtCount / 2)
    let first = stone / divisor
    let second = stone % divisor
    return (first, second)
  }

  func parseInput() -> [Int] {
    return data.components(separatedBy: .whitespaces).compactMap { Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
  }
}
