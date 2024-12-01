import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var answer = 0
    print(entities)
    for str in entities {
      guard
        let left = str.firstIndex(where: { $0.isNumber }),
        let right = str.lastIndex(where: { $0.isNumber })
      else {
        continue
      }

      let first = str[left].wholeNumberValue ?? 0
      let second = str[right].wholeNumberValue ?? 0
      print(first * 10 + second)
      answer += first * 10 + second
    }
    return answer
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var answer = 0
    let digits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

    func allIndices(of pattern: String, inside text: String) -> [Int] {
      var start = text.startIndex

      var answer: [Int] = []
      while start != text.endIndex {
        guard
          let range = text.range(of: pattern, range: start..<text.endIndex),
          !range.isEmpty
        else { break }
        let idx = text.distance(from: text.startIndex, to: range.lowerBound)
        answer.append(idx)
        start = range.upperBound
      }
      return answer
    }

    for str in entities {
      var firstVal = 0
      let firstIdx = str.firstIndex(where: { $0.isNumber })
      if let idx = firstIdx {
        firstVal = str[idx].wholeNumberValue ?? 0
      }

      var lastVal = 0
      let lastIdx = str.lastIndex(where: { $0.isNumber })
      if let idx = lastIdx {
        lastVal = str[idx].wholeNumberValue ?? 0
      }

      var left = str.distance(from: str.startIndex, to: firstIdx ?? str.endIndex)
      var right = str.distance(from: str.startIndex, to: lastIdx ?? str.startIndex)
      for (idx, dgt) in digits.enumerated() {
        let indices = allIndices(of: dgt, inside: str)
        if let match = indices.first, match < left {
          left = match
          firstVal = idx + 1
        }

        if let match = indices.last, match > right {
          right = match
          lastVal = idx + 1
        }
      }

      answer += firstVal * 10 + lastVal
    }
    return answer
  }
}
