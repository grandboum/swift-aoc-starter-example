import Algorithms
import DequeModule
import Foundation

struct Day18: AdventDay {
  typealias Item = (Direction, Int, String)
  typealias Size = (w: Int, h: Int, left: Int, top: Int)
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  func part1() -> Any {
    let input = parse(input: entities)
    let size = calcDimensions(input: input)
    var field = createField(size: size)
    let borderCount = digBorders(&field, input: input, size: size) 
    let area = fillField(&field)
    return borderCount + area
  }

  func part2() -> Any {
    return "WIP"
  }
}

extension Day18 {
  func printField(_ field: [[String]]) {
    for row in field {
      var line = ""
      for item in row {
        line += item
      }
      print(line)
    }
  }

  func parse(input: [String]) -> [Item]{
    var answer: [(Direction, Int, String)] = []
    for line in input {
      let parts = line.split(separator: " ")
      guard parts.count == 3 else { continue }
      guard let amount = Int(String(parts[1])), let direction = Direction(rawValue: String(parts[0])) else {
        continue 
      }
      let color = String(parts[2].dropFirst().dropLast())
      answer.append((direction, amount, color))
    }
    return answer
  }

  func calcDimensions(input: [Item]) -> Size {
    var minX = 0, maxX = 0
    var minY = 0, maxY = 0
    var position = (0, 0)
    for (dir, amount, _) in input {
      var xOffset = 0, yOffset = 0
      switch dir {
        case .up:
          yOffset = -1 * amount
        case .down:
          yOffset = amount
        case .right:
          xOffset = amount
        case .left:
          xOffset = -1 * amount
      }
      let newPosition = (position.0 + xOffset, position.1 + yOffset)
      position = newPosition
      minX = min(minX, newPosition.0)
      maxX = max(maxX, newPosition.0)
      minY = min(minY, newPosition.1)
      maxY = max(maxY, newPosition.1)
    }
    return (w: maxX - minX + 1, h: maxY - minY + 1, left: abs(minX), top: abs(minY))
  }

  func createField(size: Size) -> [[String]] {
    var result: [[String]] = []

    for _ in 0..<size.h {
      result.append(Array(repeating: ".", count: size.w))
    }

    return result
  }

  func digBorders(_ field: inout [[String]], input: [Item], size: Size) -> Int {
    var row = size.top, col = size.left
    var start = 0, end = 0
    var axis = false
    var count = 0
    for (d, a, _) in input {
      count += a
      switch d {
        case .left:
          start = col - a
          end = col
          axis = false
        case .right:
          start = col
          end = col + a
          axis = false
        case .up:
          start = row - a
          end = row
          axis = true
        case .down:
          start = row
          end = row + a
          axis = true
      }
      if axis {
        for rdx in start...end {
          field[rdx][col] = "#"
        }
        row = d == .up ? start : end
      } else {
        for cdx in start...end {
          field[row][cdx] = "#"
        }
        col = d == .left ? start : end
      }
    }
    return count
  }

  func fillField(_ field: inout [[String]]) -> Int {
    let dir = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    let start = findStart(field)
    field[start.0][start.1] = "#"

    var count = 1
    var que: Deque = [start]
    while !que.isEmpty {
      guard let (rdx, cdx) = que.popFirst() else { return -1 }
      for d in dir {
        let row = rdx + d.0, col = cdx + d.1
        guard validMove(row: row, col: col, field: field) else { continue }
        field[row][col] = "#"
        count += 1
        que.append((row, col))
      }
    }
    return count
  }

  func findStart(_ field: [[String]]) -> (Int, Int) {
    var row = Int.random(in: 1..<field.count-1)
    var col = Int.random(in: 1..<field[0].count-1)

    while !isInside(field, row: row, col: col) {
      row = Int.random(in: 1..<field.count-1)
      col = Int.random(in: 1..<field[0].count-1)
    }
    return (row, col)
  }

  func isInside(_ field: [[String]], row: Int, col: Int) -> Bool {
    guard field[row][col] != "#" else { return false }

    var intersections = 0
    for rdx in 0...row {
      if field[rdx][col] == "#" {
        intersections += 1
      }
    }

    return (intersections % 2) == 1
  }

  func validMove(row: Int, col: Int, field: [[String]]) -> Bool {
    if row < 0 || row >= field.count { return false }
    if col < 0 || col >= field[row].count { return false }
    return field[row][col] == "."
  }
}

extension Day18 {
  enum Direction: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
  }
}
