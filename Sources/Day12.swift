import Algorithms
import DequeModule
import Foundation

struct Day12: AdventDay, @unchecked Sendable {
  var data: String

  func part1() -> Any {
    let rawMatrix = parseInput()
    let matrix = Matrix(rawMatrix)
 
    var answer = 0
    var visited: Set<Point> = []
    matrix.explore { point in
      guard !visited.contains(point) else { return }
      let (area, perimeter) = exploreRegion(point, matrix: matrix, visited: &visited)
      answer += area * perimeter
    }
    return answer
  }
  
  func part2() -> Any {
    let rawMatrix = parseInput()
    let matrix = Matrix(rawMatrix)

    var answer = 0
    var visited: Set<Point> = []
    matrix.explore { point in
      guard !visited.contains(point) else { return }
      let (area, perimeter) = exploreRegion(point, matrix: matrix, visited: &visited)
      answer += area * perimeter
    }
    return answer
  }

  func exploreRegion(_ start: Point, matrix: Matrix<String>, visited: inout Set<Point>) -> (Int, Int) {
    let label = matrix[start]
    var area = 1, perimeter = 0
    var que: Deque<Point> = [start]
    visited.insert(start)
    while !que.isEmpty {
      guard let point = que.popFirst() else { fatalError("Can't take item from non-empty queue") }
      for d in Direction.allDirections {
        let nextPoint = point.move(in: d)
        guard matrix.contains(point: nextPoint) else { 
          perimeter += 1
          continue
        }
        guard matrix[nextPoint] == label else {
          perimeter += 1
          continue 
        }
        guard !visited.contains(nextPoint) else { continue }
        visited.insert(nextPoint)
        que.append(nextPoint)
        area += 1
      }
    }
    return (area, perimeter)
  }

  func parseInput() -> [[String]] {
    return data.convertToMatrix()
  }
}
