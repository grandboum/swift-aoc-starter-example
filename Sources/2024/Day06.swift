import Algorithms
import Foundation

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  func parse() -> [(Int, Int)] {
    let lines = entities
    guard let times = lines.first?.split(separator: ":").last else { return [] }
    guard let numbers = lines.last?.split(separator: ":").last else { return [] }
    return Array(
      zip(
        times.split(separator: " ").compactMap { Int($0) },
        numbers.split(separator: " ").compactMap { Int($0) }
      )
    )
  }

  func parse2() -> (Int, Int) {
    let lines = entities
    guard let time = lines.first?.split(separator: ":").last else { return (0, 0) }
    guard let distance = lines.last?.split(separator: ":").last else { return (0, 0) }

    return (
      assembleNumber(from: String(time)),
      assembleNumber(from: String(distance))
    )
  }

  func assembleNumber(from line: String) -> Int {
    var answer = 0
    for part in line.split(separator: " ") {
      if let number = Int(part) {
        answer *= Int(pow(10, Double(part.count)))
        answer += number
      }
    }
    return answer
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let input = parse()

    var answer = Array(repeating: 0, count: input.count)
    for (idx, item) in input.enumerated() {
      let (time, target) = item
      let smallest = findDistance(for: time) { dist in dist >= target }
      let biggest = findDistance(for: time) { dist in dist < target }
      answer[idx] = biggest - smallest
    }
    return answer.reduce(1, *)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let (time, target) = parse2()
   
    let smallest = findDistance(for: time) { dist in dist >= target }
    let biggest = findDistance(for: time) { dist in dist < target }

    return biggest - smallest
  }

  func findDistance(for time: Int, condition: (Int) -> Bool) -> Int {
    let transform: (Int) -> Int = { val in val * (time - val) }
    return binarySearch(start: 0, end: time, transform: transform, condition: condition)
  }

  func binarySearch(start: Int, end: Int, transform: (Int) -> Int, condition: (Int) -> Bool) -> Int {
    var left = start
    var right = end
    while left < right {
      let mid = left + (right - left) / 2
      if condition(transform(mid)) {
        right = mid
      } else {
        left = mid + 1
      }
    }
    return left
  }
}
