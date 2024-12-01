import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  enum Colors: String {
    case red = "red"
    case green = "green"
    case blue = "blue"

    var idx: Int {
      switch self {
      case .red:
        return 0
      case .green:
        return 1
      case .blue:
        return 2
      }
    }
  }

  func countCubes() -> [[Int]] {
    var answer: [[Int]] = []
    for line in entities {
      guard let input = line.split(separator: ":").last else { continue }

      var guess = [0, 0, 0]
      let rolls = input.split(separator: ";")
      for roll in rolls {
        let items = roll.split(separator: ",")
        for item in items {
          let parts = item.split(separator: " ")
          guard
            let numberString = parts.first,
            let number = Int(String(numberString)),
            let colorString = parts.last,
            let color = Colors(rawValue: String(colorString))
          else {
            continue
          }
          guess[color.idx] = max(guess[color.idx], number)
        }
      }
      answer.append(guess)
    }
    return answer
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let target = [12, 13, 14]

    var answer = 0
    let cubes = countCubes()
    for (idx, values) in cubes.enumerated() {
      if values[0] <= target[0] && values[1] <= target[1] && values[2] <= target[2] {
        answer += (idx + 1)
      }
    }
    return answer
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var answer = 0
    let cubes = countCubes()
    for values in cubes {
      answer += values[0] * values[1] * values[2]
    }
    return answer
  }
}
