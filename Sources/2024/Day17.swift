import Algorithms
import Collections
import Foundation

struct Day17: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map { $0.compactMap { Int(String($0)) }}
  }

  func part1() -> Any {
    let matrix = entities
    return traverse(matrix, start: (0, 0), minMoves: 1, maxMoves: 3)
  }

  func part2() -> Any {
    let matrix = entities
    return traverse(matrix, start: (0, 0), minMoves: 4, maxMoves: 10)
  }

  func traverse(_ matrix: [[Int]], start: (Int, Int), minMoves: Int, maxMoves: Int) -> Int {
    var heap = Heap<Item>()
    var visited: Set<String> = []
    let fin = matrix.count - 1

    heap.insert( Item(heat: 0, length: 0, dir: .none, row: 0, col: 0, path: []) )
    while !heap.isEmpty {
      let item = heap.popMin()!
      guard !visited.contains(item.key) else { continue }
      visited.insert(item.key)

      if item.row == fin && item.col == fin {
        printPath(in: matrix, path: item.path)
        return item.heat
      }

      for dir in Direction.nei {
        if item.dir.isReverse(dir) { continue }
        if item.dir == dir && item.length == maxMoves { continue }

        let row = item.row + dir.offset.row 
        let col = item.col + dir.offset.col
        guard validMove(row: row, col: col, in: matrix) else { continue }

        var skip = false
        var nextItem = item.move(in: dir, heat: matrix[row][col])
        while nextItem.length < minMoves {
          let row = nextItem.row + dir.offset.row 
          let col = nextItem.col + dir.offset.col
          guard validMove(row: row, col: col, in: matrix) else { 
            skip = true
            break
          }
          nextItem = nextItem.move(in: dir, heat: matrix[row][col])
        }
        guard !skip else { continue }
        heap.insert(nextItem)
      }
    }
    return 0
  }

  func validMove(row: Int, col: Int, in matrix: [[Int]]) -> Bool {
    guard row >= 0, row < matrix.count else { return false }
    guard col >= 0, col < matrix[0].count else { return false }

    return true
  }
}

extension Day17 {
  func printProgress(_ matrix: [[Int]], item: Item) {
    fflush(__stdoutp)
    print("\u{1B}[2J")
    print("Heat: \(item.heat)")
    var matrix = matrix.map { $0.map { String($0)} }
    for point in item.path {
      matrix[point.row][point.col] = point.dir
    }
    matrix[0][0] = "*"

    printMatrix(matrix)
    usleep(10000)
  }

  func printPath(in matrix: [[Int]], path: [Path]) {
    var matrix = matrix.map { $0.map { String($0)} }
    print("------------------------------------------")
    
    for item in path {
      matrix[item.row][item.col] = item.dir
    }

    matrix[0][0] = "*"
    printMatrix(matrix)
  }

  func printMatrix(_ matrix: [[String]]) {
    for row in matrix {
      var line = ""
      for val in row {
        line += val
      }
      print(line)
    }
  }
}

struct Path: Equatable {
  let dir: String
  let row: Int
  let col: Int
}

struct Item: Comparable {
  let heat: Int
  let length: Int
  let dir: Direction
  let row: Int
  let col: Int
  let path: [Path]

  var key: String {
    return "\(row) + \(col) + \(dir.desc) + \(length)"
  }

  static func < (lhs: Self, rhs: Self) -> Bool {
    return lhs.heat < rhs.heat
  }

  func move(in dir: Direction, heat: Int) -> Item {
    let row = self.row + dir.offset.row
    let col = self.col + dir.offset.col
    return Item(
      heat: self.heat + heat,
      length: self.dir == dir ? self.length + 1 : 1,
      dir: dir,
      row: row,
      col: col,
      path: self.path + [Path(dir: dir.vis, row: row, col: col)]
    )
  }
}

enum Direction: Comparable {
  case left
  case right
  case up
  case down
  case none

  var offset: (row: Int, col: Int) {
    switch self {
      case .left:
        return (row: 0, col: -1)
      case .right:
        return (row: 0, col: 1)
      case .up:
        return (row: -1, col: 0)
      case .down:
        return (row: 1, col: 0)
      case .none:
        return (row: 0, col: 0)
    }
  }

  var desc: String {
    switch self {
      case .left:
        return "left"
      case .right:
        return "right"
      case .up:
        return "up"
      case .down:
        return "down"
      case .none:
        return "none"
    }
  }
    
  var vis: String {
    switch self {
      case .left:
        return "<".color(.magenta)
      case .right:
        return ">".color(.yellow)
      case .up:
        return "^".color(.red)
      case .down:
        return "v".color(.blue)
      case .none:
        return "none"
    }
  }

  static var nei: [Direction] = [.left, .right, .up, .down]

  func isReverse(_ dir: Direction) -> Bool {
    if self == .left && dir == .right { return true }
    if self == .right && dir == .left { return true }
    if self == .up && dir == .down { return true }
    if self == .down && dir == .up { return true }
    return false
  }
}


