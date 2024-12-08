import Algorithms
import DequeModule

struct Day06: AdventDay, @unchecked Sendable {
  var data: String

  enum Glyph: String {
    case empty = "."
    case obstacle = "#"
    case guardian = "^"
    case visited = "X"
  }

  struct Point: Hashable {
    let rdx: Int
    let cdx: Int
  }

  struct Direction: Hashable {
    let dr: Int
    let dc: Int
    static var startingDirection: Direction { Direction(dr: -1, dc: 0) }

    func rotate() -> Direction {
      return Direction(dr: dc, dc: -1 * dr)
    }
  }

  struct VisitedInfo: Hashable {
    let point: Point
    let direction: Direction
  }

  func part1() -> Any {
    let rawMatrix = parseInput(data)
    let matrix = convertMatrix(rawMatrix)
    guard let start = findStart(matrix) else { fatalError("Couldn't find start") }

    let visitedMatrix = visitMatrix(matrix, start: start)
    let visitedCount = countVisitedSquares(in: visitedMatrix)
    return visitedCount
  }
  
  func part2() -> Any {
    let rawMatrix = parseInput(data)
    let matrix = convertMatrix(rawMatrix)
    guard let start = findStart(matrix) else { fatalError("Couldn't find start") }

    var visitedMatrix = visitMatrix(matrix, start: start)

    var count = 0
    for rdx in 0..<visitedMatrix.count {
      for cdx in 0..<visitedMatrix[rdx].count {
        guard visitedMatrix[rdx][cdx] == .visited else { continue }
        visitedMatrix[rdx][cdx] = .obstacle
        if containsCycle(matrix: visitedMatrix, start: start, direction: Direction.startingDirection) {
          count += 1
        }
        visitedMatrix[rdx][cdx] = .visited
      }
    }
    return count
  }

  func parseInput(_ input: String) -> [[String]] {
    var matrix: [[String]] = []
    input.enumerateLines { line, _ in
      let converted = line.map(String.init)
      matrix.append(converted) 
    }
    return matrix
  }

  func convertMatrix(_ matrix: [[String]]) -> [[Glyph]] {
    var converted: [[Glyph]] = []

    for row in matrix {
      let processed = row.compactMap(Glyph.init)
      guard processed.count == row.count else { fatalError("Can't convert to glyph") }
      converted.append(processed)
    }
    return converted
  }

  func findStart(_ matrix: [[Glyph]]) -> Point? {
    for rdx in 0..<matrix.count {
      for cdx in 0..<matrix[rdx].count {
        guard matrix[rdx][cdx] != .guardian else { return Point(rdx: rdx, cdx: cdx) }
      }
    }
    return nil
  } 

  func visitMatrix(_ matrix: [[Glyph]], start: Point) -> [[Glyph]] {
    var visitedMatrix = matrix
    var direction = Direction.startingDirection

    var point = start
    while isInBounds(point, matrix: matrix) {
      visitedMatrix[point] = .visited 
      let nextPoint = point.move(in: direction)
      guard isInBounds(nextPoint, matrix: matrix) else { break }  
      if matrix[nextPoint] == .obstacle {
        direction = direction.rotate()
        continue
      }
      point = nextPoint
    }
    return visitedMatrix 
  }

  func isInBounds(_ point: Point, matrix: [[Glyph]]) -> Bool {
    if point.rdx < 0 || point.rdx >= matrix.count {
      return false
    }
    if point.cdx < 0 || point.cdx >= matrix[point.rdx].count {
      return false
    }
    return true
  }

  func countVisitedSquares(in matrix: [[Glyph]]) -> Int {
    var answer = 0
    for row in matrix {
      for glyph in row {
        if glyph == .visited {
          answer += 1
        }   
      }
    }
    return answer
  }

  func containsCycle(matrix: [[Glyph]], start: Point, direction: Direction) -> Bool {
    var seen: Set<VisitedInfo> = []
    var point = start
    var direction = Direction.startingDirection
    while isInBounds(point, matrix: matrix) {
      let key = VisitedInfo(point: point, direction: direction)
      seen.insert(key)
      let nextPoint = point.move(in: direction)
      guard isInBounds(nextPoint, matrix: matrix) else { return false }
      if matrix[nextPoint] == .obstacle {
        direction = direction.rotate()
        continue
      }

      let nextKey = VisitedInfo(point: nextPoint, direction: direction)
      if seen.contains(nextKey) {
        return true
      }
      point = nextPoint
    }
    return true 
  }
}

extension Day06.Point {
  func move(in direction: Day06.Direction) -> Day06.Point {
    return Day06.Point(rdx: rdx + direction.dr, cdx: cdx + direction.dc)
  }
}

extension Array where Element == [Day06.Glyph] {
  subscript(point: Day06.Point) -> Day06.Glyph {
    get {
      self[point.rdx][point.cdx]
    }
    set {
      self[point.rdx][point.cdx] = newValue
    }
  }
}
