import Algorithms

struct Day16: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  func part1() -> Any {
    return "WIP"
  }

  func part2() -> Any {
    return "WIP"
  }
}
