import Algorithms
import DequeModule

struct Day21: AdventDay {
  typealias Cell = (row: Int, col: Int)
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[String]] {
    data.split(separator: "\n").map { String($0).map { String($0) } }
  }

  func part1() -> Any {
    let input = entities
    let start = findStart(input)
    let steps = 64
    return explore(grid: input, steps: steps, start: start)
  }

  func part2() -> Any {
    return "WIP"
  }
}

extension Day21 {
  func explore(grid: [[String]], steps: Int, start: Cell) -> Int {
    var que: Set<[Int]> = [[start.row, start.col]]
    var stepsTaken = 0

    let dir = [[0, -1], [1, 0], [0, 1], [-1, 0]]
    while !que.isEmpty && stepsTaken < steps {
      var nxt: Set<[Int]> = []
      for item in que {
        for d in dir {
          let row = item[0] + d[0], col = item[1] + d[1]
          guard validMove(row, col, grid) else { continue }
          nxt.insert([row, col])
        }
      }
      que = nxt
      stepsTaken += 1
    }
    return que.count
  }

  func validMove(_ row: Int, _ col: Int, _ grid: [[String]]) -> Bool {
    guard row >= 0 && row < grid.count else { return false }
    guard col >= 0 && col < grid[row].count else { return false }
    return grid[row][col] != "#"
  }

  func findStart(_ input: [[String]]) -> Cell {
    for rdx in 0..<input.count {
      for cdx in 0..<input[rdx].count {
        guard input[rdx][cdx] == "S" else { continue }
        return (row: rdx, col: cdx)
      }
    }
    fatalError("No start")
  }

  func debug(grid: [[String]], que: Deque<Cell>) {
    var field = grid
    for item in que {
      field[item.row][item.col] = "O" 
    }
   
    for row in field {
      var line = ""
      for item in row {
        line += item
      }
      print(line)
    }
    print("----------------")
  }
}
