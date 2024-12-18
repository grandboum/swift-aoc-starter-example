import Algorithms
import DequeModule
import RegexBuilder
import Foundation

struct Day18: AdventDay, @unchecked Sendable {
  var data: String

  enum Tile {
    case empty
    case obstacle
  }

  // For test, change size to 7 and limit to 12
  func part1() -> Any {
    let size = 71
    let limit = 1024
    let obstacles = parseInput()
    let matrix = fillMatrix(with: obstacles, size: size, limit: limit)
    let answer = shortestPath(in: matrix, from: Point(rdx: 0, cdx: 0), to: Point(rdx: size-1, cdx: size-1))
    return answer
  }
 
  // For test, change size to 7 
  func part2() -> Any {
    let size = 71
    let obstacles = parseInput()
    let answer = findBlocker(with: obstacles, size: size, from: Point(rdx: 0, cdx: 0), to: Point(rdx: size-1, cdx: size-1))
    let blocker = obstacles[answer]
    return [blocker.cdx, blocker.rdx]
  }

  func findBlocker(with obstacles: [Point], size: Int, from start: Point, to end: Point) -> Int {
    var left = 0, right = obstacles.count-1

    while left <= right {
      let idx = left + (right - left) / 2
    
      let matrix = fillMatrix(with: obstacles, size: size, limit: idx+1)
      let shortestPath = shortestPath(in: matrix, from: start, to: end)
      if shortestPath != -1 {
        left = idx + 1
      } else {
        right = idx - 1
      }
    }
    return left
  }

  func shortestPath(in matrix: Matrix<Tile>, from start: Point, to end: Point) -> Int {
    var que: Deque<(Point, Int)> = [(start, 0)]
    var visited: Set<Point> = [start]

    //matrix.printMatrix { $0 == .empty ? "." : "#" }

    while !que.isEmpty {
      guard let (point, count) = que.popFirst() else { fatalError("Can't pop from non-empty que") }
      guard point != end else { return count }
      
      for direction in Direction.allDirections {
        let nextPoint = point.move(in: direction)
        guard matrix.contains(point: nextPoint) else { continue }
        guard matrix[nextPoint] != .obstacle else { continue }
        guard !visited.contains(nextPoint) else { continue }
        que.append((nextPoint, count + 1))
        visited.insert(nextPoint)
      }
    }
    return -1
  }

  func fillMatrix(with obstacles: [Point], size: Int, limit: Int) -> Matrix<Tile> {
    var rawMatrix: [[Tile]] = []
    for _ in 0..<size {
      let row = Array(repeating: Tile.empty, count: size)
      rawMatrix.append(row)
    }

    var matrix = Matrix(rawMatrix)
    for idx in 0..<limit {
      guard idx < obstacles.count else { fatalError("Trying to read \(idx), have: \(obstacles.count)") }
      let point = obstacles[idx]
      matrix[point] = .obstacle
    }
    return matrix
  }

  func parseInput() -> [Point] {
    var answer: [Point] = []
    data.enumerateLines { line, _ in
      let parts = line.components(separatedBy: ",")
      guard let y = parts.first, let x = parts.last else { fatalError("Can't divide into pairs") }
      guard let rdx = Int(x), let cdx = Int(y) else { fatalError("Can't convert coordinates to Int") }
      answer.append(Point(rdx: rdx, cdx: cdx))
    }
    return answer
  }
}
