import Algorithms
import Collections
import Foundation

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  func countWinningNumbers(cards: [String]) -> [Int] {
    var answer: [Int] = []
    for card in cards {
      let parts = card.split(separator: "|")
      guard let header = parts.first, let data = parts.last else { continue }
      guard let winningString = header.split(separator: ":").last else { continue }

      let winningNumbers = Set(winningString.split(separator: " ").compactMap { Int(String($0)) })
      let actualNumbers = Set(data.split(separator: " ").compactMap { Int(String($0)) })

      answer.append(winningNumbers.intersection(actualNumbers).count)
    }
    return answer
  }

  // Answer should be 28750
  func part1() -> Any {
    let numbers = countWinningNumbers(cards: entities)

    var answer = 0
    for number in numbers {
      let power = Double(number - 1)
      answer += Int(pow(2, power))
    }
    return answer
  }

  // Answer should be 10212704
  func part2() -> Any {
    let cards = entities
    let numbers = countWinningNumbers(cards: cards)

    var dp = Array(repeating:1, count: cards.count)
    for idx in cards.indices {
      let match = numbers[idx]
      for jdx in 0..<match {
        dp[idx + jdx + 1] += dp[idx]
      }
    }
    return dp.reduce(0, +)
  }
}
