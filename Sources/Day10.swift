import Algorithms
import DequeModule
import Foundation

struct Day10: AdventDay, @unchecked Sendable {
  var data: String

  func part1() -> Any {
    let rawMatrix = parseInput()
    let matrix = Matrix(rawMatrix)
    let startPoints = collectStartPoints(matrix)

    var answer = 0
    for point in startPoints {
      let (score, _) = exploreTrail(point, matrix)
      answer += score
    }
    return answer
  }
  
  func part2() -> Any {
    let rawMatrix = parseInput()
    let matrix = Matrix(rawMatrix)
    let startPoints = collectStartPoints(matrix)

    var answer = 0
    for point in startPoints {
      let (_, rating) = exploreTrail(point, matrix)
      answer += rating
    }
    return answer
  }

  func exploreTrail(_ start: Point, _ matrix: Matrix<Int>) -> (Int, Int) {
    let directions = [
      Direction(dr: 0, dc: 1), 
      Direction(dr: 1, dc: 0), 
      Direction(dr: -1, dc: 0), 
      Direction(dr: 0, dc: -1)
    ]

    var rating: Int = 0
    var visited: Set<Point> = []
    var que: Deque<Point> = [start]
    while !que.isEmpty {
      guard let point = que.popFirst() else { fatalError("Can't get value from non-empty que") }
      let val = matrix[point]

      if val == 9 {
        rating += 1
        visited.insert(point)
        continue
      }

      for direction in directions {
        let nextPoint = point.move(in: direction)
        guard matrix.contains(point: nextPoint) else { continue }
        guard matrix[nextPoint] == matrix[point] + 1 else { continue }
        que.append(nextPoint)
      }
    }
    return (visited.count, rating)
  }

  func collectStartPoints(_ matrix: Matrix<Int>) -> [Point] {
    var answer: [Point] = []
    for rdx in matrix.rows {
      for cdx in matrix.cols {
        let point = Point(rdx: rdx, cdx: cdx)
        if matrix[point] == 0 {
          answer.append(Point(rdx: rdx, cdx: cdx)) 
        }
      }
    }
    return answer
  }

  func parseInput() -> [[Int]] {
    var answer: [[Int]] = []
    data.enumerateLines { line, _ in
      let row = line.map { String($0) }.compactMap { Int($0) }
      answer.append(row)
    }
    return answer
  }
}
