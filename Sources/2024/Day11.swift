import Algorithms
import DequeModule

struct Day11: AdventDay {
  enum PixelType: String {
    case empty = "."
    case galaxy = "#"
  }

  typealias MapData = [(Int, Int)]

  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[String]] {
    data.split(separator: "\n").map { $0.map { String($0)}}
  }

  func part1() -> Any {
    let map = entities
    let input = parse(map, offset: 2)
    return countDistances(input)
  }

  func part2() -> Any {
    let map = entities
    let offset = 1000000
    let input = parse(map, offset: offset)
    return countDistances(input)
  }

  func countDistances(_ input: MapData) -> Int {
    var answer = 0
    for idx in 0..<input.count {
      let start = idx + 1
      for jdx in start..<input.count {
        let src = input[idx]
        let dst = input[jdx]
        answer += (abs(src.0 - dst.0) + abs(src.1 - dst.1))
      }
    }
    return answer
  }

  func parse(_ lines: [[String]], offset: Int) -> MapData {
    let rows = lines.count
    let cols = lines[0].count

    var emptyRows = Set(Array(0..<rows))
    var emptyCols = Set(Array(0..<cols))
    var galaxies: [(Int, Int)] = []

    for row in 0..<rows {
      for col in 0..<cols {
        if lines[row][col] == PixelType.galaxy.rawValue {
          if emptyRows.contains(row) {
            emptyRows.remove(row)
		  }
          if emptyCols.contains(col) {
            emptyCols.remove(col)
		  }
		}
      }
    }

    var offsetRow = 0
    for row in 0..<rows {
      if emptyRows.contains(row) {
        offsetRow += offset - 1
        continue
      }
      var offsetCol = 0
      for col in 0..<cols {
        if emptyCols.contains(col) {
          offsetCol += offset - 1
          continue
        }
        if lines[row][col] == PixelType.galaxy.rawValue {
          galaxies.append((row + offsetRow, col + offsetCol))
		}
      }
    }
    return galaxies
  }
}
