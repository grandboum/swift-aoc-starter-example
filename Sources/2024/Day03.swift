import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[String.Element]] {
    data.split(separator: "\n").map { Array($0) }
  }

  func canUseNumber(row: Int, col: Int, input: [[String.Element]]) -> Bool {
    let directions = [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]]
    for dir in directions {
      let rdx = row + dir[0]
      let cdx = col + dir[1]

      guard isValidAddress(row: rdx, col: cdx, input: input) else { continue }

      let symbol = input[rdx][cdx]

      if symbol != "." && !symbol.isNumber { return true }
    }
    return false
  }

  func neighbouringStars(row: Int, col: Int, input: [[String.Element]]) -> [String] {
    var answer: [String] = []
    let directions = [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]]
    for dir in directions {
      let rdx = row + dir[0]
      let cdx = col + dir[1]

      guard isValidAddress(row: rdx, col: cdx, input: input) else { continue }

      let symbol = input[rdx][cdx]
      if symbol == "*" {
        answer.append("r:\(rdx):c:\(cdx)")
      }
    }
    return answer
  }

  func isValidAddress(row: Int, col: Int, input: [[String.Element]]) -> Bool {
    guard row >= 0 && row < input.count else { return false }
    guard col >= 0 && col < input[row].count else { return false }

    return true
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var answer = 0
    let input = entities
    for rdx in 0..<input.count {
      var acc = 0
      var usable = false
      for cdx in 0..<input[rdx].count {
        let symbol = input[rdx][cdx]
        if symbol.isNumber {
          acc *= 10
          acc += symbol.wholeNumberValue ?? 0
          usable = usable || canUseNumber(row: rdx, col: cdx, input: input)
        } else {
          if usable {
            answer += acc
          }
          acc = 0
          usable = false
        }
      }

      if usable {
        answer += acc
      }
    }

    return answer
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let input = entities
    var storage: [String: [Int]] = [:]
    for rdx in 0..<input.count {
      var acc = 0
      var stars: Set<String> = []
      for cdx in 0..<input[rdx].count {
        let symbol = input[rdx][cdx]
        if symbol.isNumber {
          acc *= 10
          acc += symbol.wholeNumberValue ?? 0
          stars.formUnion(neighbouringStars(row: rdx, col: cdx, input: input))
        } else {
          if !stars.isEmpty {
            for star in stars {
              var arr = storage[star] ?? []
              arr.append(acc)
              storage[star] = arr
            }
          }
          acc = 0
          stars = []
        }
      }
      if !stars.isEmpty {
        for star in stars {
          var arr = storage[star] ?? []
          arr.append(acc)
          storage[star] = arr
        }
      }
    }

    var answer = 0
    for (key, val) in storage {
      guard val.count == 2 else { continue }
      print(key)
      let first = val.first ?? 0
      let second = val.last ?? 0
      answer += first * second
    }
    return answer
  }
}
