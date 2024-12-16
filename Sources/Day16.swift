import Algorithms
import DequeModule
import RegexBuilder
import Foundation

struct Day16: AdventDay, @unchecked Sendable {
  var data: String

  enum Tile: String {
    case empty = "."
    case wall = "#"
    case start = "S"
    case end = "E"
  }

  struct LocationInfo: Hashable {
    let point: Point
    let direction: Direction
  }

  struct State {
    let point: Point
    let direction: Direction
    let score: Int
    let squaresTravelled: Set<Point>

    var locationInfo: LocationInfo {
      return LocationInfo(point: point, direction: direction)
    }
  }

  private let rotationCost = 1000
  private let moveCost = 1

  func part1() -> Any {
    let rawMatrix = parseInput()
    let matrix = Matrix(rawMatrix)
    let start = findStart(matrix)
    let (score, _) = findScore(matrix, start: start)
    return score
  }
  
  func part2() -> Any {
    let rawMatrix = parseInput()
    let matrix = Matrix(rawMatrix)
    let start = findStart(matrix)
    let (_, seats) = findScore(matrix, start: start)
    return seats
  }

  func findStart(_ matrix: Matrix<Tile>) -> Point {
    var answer: Point?
    matrix.explore { point in
      guard matrix[point] == .start else { return }
      answer = point
    }
    guard let answer else { fatalError("Can't find start") }
    return answer
  }

  func findScore(_ matrix: Matrix<Tile>, start startPoint: Point) -> (Int, Int) {
    var visited: [LocationInfo: Int] = [:]
    let start = State(point: startPoint, direction: .east, score: 0, squaresTravelled: Set<Point>([startPoint]))
    visited[start.locationInfo] = 0

    var score = Int.max
    var seats: Set<Point> = [startPoint]
    var que: Deque<State> = [start]
    while !que.isEmpty {
      guard let state = que.popFirst() else { fatalError("I can't ") }
      if matrix[state.point] == .end {
        if state.score < score {
          score = state.score
          seats = state.squaresTravelled
        } else if state.score == score {
          seats = seats.union(state.squaresTravelled)
        }
        continue
      }

      for (direction, cost) in generateRotationCosts(for: state.direction) {
        guard !direction.isOppositeDirection(state.direction) else { continue }
        let nextPoint = state.point.move(in: direction)
        // Check that move is in bounds
        guard matrix.contains(point: nextPoint) else { continue }
        // Check that not walking into a wall
        guard matrix[nextPoint] != .wall else { continue }
        // Check that haven't already visited
        let location = LocationInfo(point: nextPoint, direction: direction)
        let nextScore = state.score + cost + 1
        if let previousCost = visited[location] {
          guard previousCost >= state.score + cost + 1 else { continue }
        }
        var squares = state.squaresTravelled
        squares.insert(nextPoint)
        que.append(State(point: nextPoint, direction: direction, score: nextScore, squaresTravelled: squares))
        visited[location] = nextScore
      }
    }
    return (score, seats.count)
  }

  func generateRotationCosts(for direction: Direction) -> [(Direction, Int)] {
    if direction == .east {
      return [(.east, 0), (.north, rotationCost), (.south, rotationCost), (.west, rotationCost * 2)]
    }
    if direction == .south {
      return [(.south, 0), (.east, rotationCost), (.west, rotationCost), (.north, rotationCost * 2)]
    }
    if direction == .west {
      return [(.west, 0), (.south, rotationCost), (.north, rotationCost), (.east, rotationCost * 2)]
    }
    if direction == .north {
      return [(.north, 0), (.west, rotationCost), (.east, rotationCost), (.south, rotationCost * 2)]
    }
    fatalError("Unknown direction: \(direction)")
  }

  func parseInput() -> [[Tile]] {
    var rawMatrix: [[Tile]] = []
    data.enumerateLines { line, _ in 
      let tiles = Array(line).compactMap { String($0) }
      let row = tiles.compactMap { Tile(rawValue: $0) }
      guard row.count == line.count else { fatalError("I can't") }
      rawMatrix.append(row)
    }
    return rawMatrix
  }
}
