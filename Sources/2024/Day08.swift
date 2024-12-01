import Algorithms

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  func part1() -> Any {
    let lines = entities
    let input = parse(lines)
    let directions = lines[0] 

    var idx = directions.startIndex
    var answer = 0
    var start = "AAA"
    while start != "ZZZ" {
      switch directions[idx] {
      case "R":
        
        start = input[start]![1]
      case "L":
        start = input[start]![0]
      default:
        fatalError("oopsie")
      }

      answer += 1
      idx = directions.index(after: idx)
      if idx == directions.endIndex {
        idx = directions.startIndex
      }
    }
    return answer
  }

  func part2() -> Any {
    let lines = entities
    let input = parse(lines)
    let directions = lines[0] 

    var finished = 0
    var answer = 0
    var idx = directions.startIndex
    var start = collectStartingPoints(input)
    while finished != start.count {
      var didx = 0
      finished = 0
      switch directions[idx] {
      case "R":
        didx = 1 
      case "L":
        didx = 0
      default:
        fatalError("oopsie")
      }
      print(start)

      answer += 1
      for sIdx in start.indices {
        start[sIdx] = input[start[sIdx]]![didx]
        if isFinished(start[sIdx]) {
          finished += 1
        }
      }
      idx = directions.index(after: idx)
      if idx == directions.endIndex {
        idx = directions.startIndex
      }
    }
    return answer
  }
}

extension Day08 {
  func parse(_ lines: [String]) -> [String: [String]] {
    var answer: [String: [String]] = [:]
    for idx in 1..<lines.count {
      guard lines[idx].count > 0 else { continue }
      let parts = lines[idx].split(separator: "=")
      guard 
        let srcPart = parts.first, 
        let dstPart = parts.last
      else {
        continue
      }

      let src = String(srcPart).trimmingCharacters(in: .whitespacesAndNewlines)
      let dst = cleanup(String(dstPart).trimmingCharacters(in: .whitespacesAndNewlines))
      let sides = dst.split(separator: ",")

      guard let leftPart = sides.first, let rightPart = sides.last else { continue }
      let left = String(leftPart).trimmingCharacters(in: .whitespacesAndNewlines)
      let right = String(rightPart).trimmingCharacters(in: .whitespacesAndNewlines)

      answer[src] = [left, right]
    }
    return answer
  }

  func cleanup(_ text: String) -> String {
    let a = String(text.dropFirst()).dropLast()
    return String(a)
  }

  func collectStartingPoints(_ input: [String: [String]]) -> [String] {
    var answer: [String] = []
    for key in input.keys {
      let idx = key.index(before: key.endIndex)
      guard key[idx] == "A" else { continue }
      answer.append(key)
    }
    return answer
  }

  func isFinished(_ text: String) -> Bool {
    let idx = text.index(before: text.endIndex)
    return text[idx] == "Z"
  }
}
