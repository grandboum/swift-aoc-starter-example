import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { Int($0) }
    }
  }

  let safeLevelsRange: Range<Int> = 1..<4

  func parse(_ input: String) -> [[Int]] {
    return input.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func part1() -> Any {
    let reports = parse(data)
    var safeCount = 0
    for report in reports {
      guard checkReport(report, range: safeLevelsRange, skipCount: 0) else { continue }
      safeCount += 1
    }
    return safeCount
  }

  func part2() -> Any {
    let reports = parse(data)
    var safeCount = 0
    for report in reports {
      guard checkReport(report, range: safeLevelsRange, skipCount: 1) else { continue }
      safeCount += 1
    }
    return safeCount
  }

  private func checkReport(_ input: [Int], range: Range<Int>, skipCount: Int) -> Bool {
    let diffs = countDifferences(input)
    let comparator: (Int, Int) -> Bool = (diffs.neg < diffs.pos) ? (>) : (<)
    return checkSlope(input, range: range, skipCount: skipCount, comparator: comparator)
  }

  private func checkSlope(
    _ input: [Int], 
    range: Range<Int>, 
    skipCount: Int, 
    skipIdx: Int = -1, 
    startIdx: Int = 0, 
    comparator: (Int, Int) -> Bool
  ) -> Bool {
    guard skipCount >= 0 else { return false }
    for idx in startIdx..<input.count {
      guard idx != skipIdx else { continue } 
      guard let prev = prevNumber(for: idx, skipping: skipIdx, in: input) else { continue }
      let diff = abs(input[idx] - prev)
      guard comparator(input[idx], prev) && range.contains(diff) else {
        return checkSlope(input, range: range, skipCount: skipCount-1, skipIdx: idx, startIdx: idx, comparator: comparator) || 
          checkSlope(input, range: range, skipCount: skipCount-1, skipIdx: idx-1, startIdx: idx, comparator: comparator)
      }
    }
    return true
  }

  private func countDifferences(_ input: [Int]) -> (pos: Int, neg: Int) {
    var neg = 0
    var pos = 0
    for idx in 1..<input.count {
      let diff = input[idx] - input[idx-1]
      if diff > 0 {
        pos += 1
      } else if diff < 0 {
        neg += 1
      }
    }
    return (pos: pos, neg: neg)
  }

  private func prevNumber(for idx: Int, skipping skipIdx: Int, in input: [Int]) -> Int? {
    guard input.indices.contains(idx-1) else { return nil }
    guard idx - 1 == skipIdx else { return input[idx-1] }
    guard input.indices.contains(idx-2) else { return nil }
    return input[idx-2]
  }
}
