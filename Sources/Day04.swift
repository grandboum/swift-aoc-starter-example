import Algorithms
import DequeModule

struct Day04: AdventDay, @unchecked Sendable {
  var data: String

  let directionalPattern = ["X", "M", "A", "S"]
  let squarePattern = ["M", "A", "S"]

  func part1() -> Any {
    let matrix = parseInput(data)

    var answer = 0
    for rdx in 0..<matrix.count {
        for cdx in 0..<matrix[rdx].count {
            guard matrix[rdx][cdx] == directionalPattern[0] else { continue }
            answer += exploreDirections(matrix, rdx, cdx, directionalPattern)
        }
    }
    return answer
  }

  func exploreDirections(_ matrix: [[String]], _ row: Int, _ col: Int, _ target: [String]) -> Int {
    let directions = [(0, -1), (0, 1), (1, 0), (-1, 0), (1, -1), (-1, 1), (-1, -1), (1, 1)]

    var answer = 0
    for direction in directions {
        guard visitDirection(matrix, row, col, direction, target) else { continue }
        answer += 1
    }
    return answer
  }

  func visitDirection(_ matrix: [[String]], _ row: Int, _ col: Int, _ direction: (Int, Int), _ target: [String]) -> Bool {
    let rows = matrix.count, cols = matrix[0].count
    let isValidMove: (Int, Int) -> Bool = { rdx, cdx in 
      if rdx < 0 || rdx >= rows {
        return false
      }
      if cdx < 0 || cdx >= cols {
        return false
      }
      return true
    }

    let (dr, dc) = direction
    var rdx = row, cdx = col, idx = 1
    var path: Set<Int> = [createKey(rdx: rdx, cdx: cdx, rows: rows, cols: cols)]
    while idx < target.count {
      let nextRow = rdx + dr
      let nextCol = cdx + dc
      guard isValidMove(nextRow, nextCol) else { return false }
      guard matrix[nextRow][nextCol] == target[idx] else { return false }
      rdx = nextRow
      cdx = nextCol
      path.insert(createKey(rdx: rdx, cdx: cdx, rows: rows, cols: cols))
      idx += 1
    }

    //printMatrix(matrix, path: path)
    return true
  }

  func parseInput(_ input: String) -> [[String]] {
    var result: [[String]] = []
    input.enumerateLines { line, _ in
        result.append(line.map(String.init))
    }
    return result
  }

  func part2() -> Any {
    let matrix = parseInput(data)

    var answer = 0
    for rdx in 0..<matrix.count {
      for cdx in 0..<matrix[rdx].count {
        guard exploreSquare(matrix: matrix, row: rdx, col: cdx, target: squarePattern) else { continue }
        answer += 1
      }
    }
    return answer
  }

  func exploreSquare(matrix: [[String]], row: Int, col: Int, target: [String]) -> Bool {
    guard row + 2 < matrix.count && col + 2 < matrix[row].count else { return false }

    let topDirections = [(1, 1), (1, -1)]
    let bottomDirections = [(-1, 1), (-1, -1)]

    var count = 0
    if matrix[row][col] == target[0] && visitSquareDirection(matrix: matrix, row: row, col: col, target: target, direction: topDirections[0]) {
      count += 1
    }
    if matrix[row][col+2] == target[0] && visitSquareDirection(matrix: matrix, row: row, col: col+2, target: target, direction: topDirections[1]) {
      count += 1
    }
    if matrix[row+2][col] == target[0] && visitSquareDirection(matrix: matrix, row: row+2, col: col, target: target, direction: bottomDirections[0]) {
      count += 1
    }
    if matrix[row+2][col+2] == target[0] && visitSquareDirection(matrix: matrix, row: row+2, col: col+2, target: target, direction: bottomDirections[1]) {
      count += 1
    }
    return count == 2
  }

  func visitSquareDirection(matrix: [[String]], row: Int, col: Int, target: [String], direction: (Int, Int)) -> Bool {
    let (dr, dc) = direction
    var rdx = row, cdx = col, idx = 1
    while idx < target.count {
      let nextRow = rdx + dr
      let nextCol = cdx + dc
      guard matrix[nextRow][nextCol] == target[idx] else { return false }
      rdx = nextRow
      cdx = nextCol
      idx += 1
    }
    return true
  }
}

extension Day04 {
  func createKey(rdx: Int, cdx: Int, rows: Int, cols: Int) -> Int {
    return rdx * cols + cdx
  }

  private func printMatrix(_ matrix: [[String]], path: Set<Int>) {
    for rdx in 0..<matrix.count {
      var line = ""
      for cdx in 0..<matrix[rdx].count {
        var value = matrix[rdx][cdx]
        if path.contains(createKey(rdx: rdx, cdx: cdx, rows: matrix.count, cols: matrix[0].count)) {
          value = value.color(.red)
        }
        line += " " + value
      }
      print(line)
    }
    print("-------------------")
  }
}
