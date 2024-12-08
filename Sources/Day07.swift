import Algorithms
import DequeModule
import Foundation

struct Calibration: Equatable{
  let result: UInt64
  let numbers: [UInt64]
}

struct Day07: AdventDay, @unchecked Sendable {
  var data: String

  func part1() -> Any {
    let calibrations = parseInput(data)
    return calibrations.lazy.filter { backtrack($0, idx: 1, total: $0.numbers[0], canOr: false) }.reduce(0, { $0 + $1.result} ) 
  }
  
  func part2() -> Any {
    let calibrations = parseInput(data)
    return calibrations.lazy.filter { backtrack($0, idx: 1, total: $0.numbers[0], canOr: true) }.reduce(0, { $0 + $1.result} ) 
  }

  func backtrack(_ calibration: Calibration, idx: Int, total: UInt64, canOr: Bool) -> Bool {
    guard idx < calibration.numbers.count else { return total == calibration.result }

    let number = calibration.numbers[idx]
    let add = backtrack(calibration, idx: idx + 1, total: total + number, canOr: canOr)
    let mul = backtrack(calibration, idx: idx + 1, total: total * number, canOr: canOr)
    guard canOr else { return add || mul }

    let digits = String(calibration.numbers[idx]).count
    let extra = power(10, digits)
    let total = UInt64(total * extra + calibration.numbers[idx])
    let or = backtrack(calibration, idx: idx + 1, total: total, canOr: canOr)
    return add || mul || or
  }

  func parseInput(_ input: String) -> [Calibration] {
    var answer: [Calibration] = []

    input.enumerateLines { line, _ in 
      let parts = line.components(separatedBy: ":")
      guard 
        let result = parts.first, 
        let resultingNumber = UInt64(result),
        let operands = parts.last
      else { fatalError("Can't parse a line") }
      let rawNumbers = operands.components(separatedBy: " ")
      let numbers = rawNumbers.compactMap({ UInt64($0.trimmingCharacters(in: .whitespaces)) })
      answer.append(
        Calibration(result: resultingNumber, numbers: numbers)
      )
    }
    return answer
  }
}
