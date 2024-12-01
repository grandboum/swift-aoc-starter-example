import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  func part1() -> Any {
    var answer = 0
    let lines = entities
    for line in lines {
      answer += nextNumber(for: line).1
    }
    return answer
  }

  func part2() -> Any {
    var answer = 0
    let lines = entities
    for line in lines {
      answer += nextNumber(for: line).0
    }
    return answer
  }

  func nextNumber(for line: String) -> (Int, Int) {
    let numbers = line.split(separator: " ").map { String($0) }.compactMap { Int($0) }

    var seq: [Int] = numbers
    var nxt = numbers.last ?? 0
    var prev = numbers.first ?? 0
    var woot: [Int] = [numbers[0]]
    while true {
      var level: [Int] = []
      for idx in 1..<seq.count {
        level.append(seq[idx] - seq[idx-1])
      }
      seq = level 
      nxt += level.last ?? 0
      woot.append(level.first ?? 0)
      prev -= level.first ?? 0

      let uniq = Set(level)
      guard uniq.count > 1 else { break }
    }
    
    var a = woot.last!
    for idx in stride(from: woot.count-2, through: 0, by: -1) {
      a = woot[idx] - a
    }
    return (a, nxt)
  }

}
