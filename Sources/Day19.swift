import Algorithms
import DequeModule
import RegexBuilder
import Foundation

struct Day19: AdventDay, @unchecked Sendable {
  var data: String

  init(data: String) {
    self.data = data
  }

  func part1() -> Any {
    let (towels, patterns) = parseInput()

    var answer = 0
    for pattern in patterns {
      guard canCreatePattern(pattern, towels: towels) else { continue }
      answer += 1
    }
    return answer
  }
 
  func part2() -> Any {
    let (towels, patterns) = parseInput()

    var answer = 0
    var dp: [String: Int] = [:]
    for (idx, pattern) in patterns.enumerated() {
      answer += countWaysToCreatePattern(pattern, towels: towels, idx: 0, dp: &dp, limit: nil)
      print("Done \(idx+1) of \(patterns.count)")
    }
    return answer
  }

  func canCreatePattern(_ pattern: String, towels: Set<String>) -> Bool {
    var dp: [String: Int] = [:]
    return countWaysToCreatePattern(pattern, towels: towels, idx: 0, dp: &dp, limit: 1) > 0
  }

  func countWaysToCreatePattern(_ pattern: String, towels: Set<String>, idx: Int, dp: inout [String: Int], limit: Int?) -> Int {
    guard idx < pattern.count else { return 1 }
    let key = createKey(pattern, startIdx: idx)
    if let value = dp[key] { return value }

    var count = 0
    for size in 1...(pattern.count - idx) {
      let start = pattern.index(pattern.startIndex, offsetBy: idx)
      let end = pattern.index(start, offsetBy: size)
      let part = String(pattern[start..<end])
      guard towels.contains(part) else { continue }
      count += countWaysToCreatePattern(pattern, towels: towels, idx: idx + size, dp: &dp, limit: limit)
      if let limit, limit <= count {
        return count
      }
    }
    dp[key, default: 0] += count
    return count
  }

  func createKey(_ pattern: String, startIdx: Int) -> String {
    let start = pattern.index(pattern.startIndex, offsetBy: startIdx)
    let key = pattern[start..<pattern.endIndex]
    return String(key)
  }

  func parseInput() -> (Set<String>, [String]) {
    let parts = data.components(separatedBy: .newlines).map { String($0) }
    guard let rawTowels = parts.first else { fatalError("Can't read towels line") }
    let towels = Set(rawTowels.components(separatedBy: ", ").map { String($0) })
    
    let patterns = Array(parts[1..<parts.count]).filter { $0.count > 0 }
    return (towels, patterns)
  }
}
