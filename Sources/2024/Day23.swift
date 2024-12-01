import Algorithms

struct Day23: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0).map { String($0) }}
  }

  func part1() -> Any {
    return "WIP"
  }

  func part2() -> Any {
    return "WIP"
  }
}

extension Day23 {
  enum Cell: String {
    case empty = "."
    case wall = "#"
    case slide = "lol"
  }

  struct Direction {
    let row: Int
    let col: Int

    init(_ input: [Int]) {
      self.row = input[0]
      self.col = input[1]
    }
  }

  typealias Point = (row: Int, col: Int)

  func traverse() {
    let slides: [String: Direction] = [
      "^": .init([-1, 0]), 
      ">": .init([0, 1]), 
      "v": .init([1, 0]), 
      "<": .init([0, -1])
    ]
  }

  func findStart(grid: [[String]]) -> Point {
    for cdx in 0..<grid[0].count {
      guard grid[0][cdx] ==  else { continue }
      return (row: 0, col: cdx)
    }
    fatalError("Can't find start")
  }

  func findEnd(grid: [[String]]) -> Point {
    let row = grid.count - 1
    for cdx in 0..<grid[0].count {
      guard grid[row][cdx] == "." else {
        
      }
    }
  }
}

func ==(lhs: String, rhs: Day23.Cell) -> Bool {
  switch lhs {
    case Cell.empty.rawValue:
      return rhs == .empty
    case Cell.wall.rawValue:
      return rhs == .wall
    default:
      return rhs == .slide
    }
}

