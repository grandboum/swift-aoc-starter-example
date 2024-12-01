import Algorithms
import OrderedCollections

struct Day15: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
  }

  func part1() -> Any {
    let input = entities
    var answer = 0
    for part in input {
      answer += hash(of: part)
    }
    return answer
  }

  func part2() -> Any {
    let input = entities
    var boxes: [OrderedDictionary<String, Int>] = Array(repeating: [:], count:256)
    for instruction in input {
      let parts = instruction.split(separator: "=")
      if parts.count > 1 {
        let label = String(parts[0])
        let lens = Int(String(parts[1]))
        let boxId = hash(of: label)
        boxes[boxId][label] = lens
      } else {
        let label = String(instruction.dropLast())
        let boxId = hash(of: label)
        if let _ = boxes[boxId][label] {
          boxes[boxId].removeValue(forKey: label)
        }
      }
    }

    var answer = 0
    for (idx, box) in boxes.enumerated() {
      for (jdx, item) in box.elements.enumerated() {
        answer += (idx + 1) * (jdx + 1) * item.1 
      }
    }
    return answer
  }

  func hash(of text: String) -> Int {
    var answer = 0

    for ch in text {
      guard let ascii = ch.asciiValue else { continue }
      answer += Int(ascii)
      answer *= 17
      answer = answer % 256
    }
    return answer
  }
}
