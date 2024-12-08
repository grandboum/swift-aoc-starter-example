import Algorithms
import DequeModule
import Foundation

struct Day08: AdventDay, @unchecked Sendable {
  var data: String

  func part1() -> Any {
    let (antennas, rows, cols) = parseInput(data)
    var antinodes: [String: Set<Point>] = [:]

    for (antenna, locations) in antennas {
      for location in locations {
        let candidates = exploreOptions(location, neighbours: locations, resonant: false) { 
          isInBounds($0, rows: rows, cols: cols) && !locations.contains($0)
        }
        let updated = antinodes[antenna, default: Set<Point>()].union(candidates)
        antinodes[antenna] = updated
      }
    }

    var uniq: Set<Point> = []
    for (_, nodes) in antinodes {
      uniq.formUnion(nodes)
    }

    return uniq.count
  }
  
  func part2() -> Any {
    let (antennas, rows, cols) = parseInput(data)
    var antinodes: [String: Set<Point>] = [:]

    for (antenna, locations) in antennas {
      for location in locations {
        let candidates = exploreOptions(location, neighbours: locations, resonant: true) { 
          isInBounds($0, rows: rows, cols: cols)
        }
        let updated = antinodes[antenna, default: Set<Point>()].union(candidates)
        antinodes[antenna] = updated
      }
    }

    var uniq: Set<Point> = []
    for (_, nodes) in antinodes {
      uniq.formUnion(nodes)
    }

    for (_, nodes) in antennas {
      uniq.formUnion(nodes)
    }

    return uniq.count
  }

  func isInBounds(_ point: Point, rows: Int, cols: Int) -> Bool {
    if point.rdx < 0 || point.rdx >= rows {
      return false
    }
    if point.cdx < 0 || point.cdx >= cols {
      return false
    }
    return true
  }

  func exploreOptions(_ location: Point, neighbours: Set<Point>, resonant: Bool, include: (Point) -> Bool) -> Set<Point> {
    var answer: Set<Point> = []
    for nei in neighbours {
      guard location != nei else { continue }
      let dx = location.rdx - nei.rdx
      let dy = location.cdx - nei.cdx
      var point = Point(rdx: location.rdx + dx, cdx: location.cdx + dy)
      while include(point) {
        answer.insert(point)
        point = Point(rdx: point.rdx + dx, cdx: point.cdx + dy)
        guard resonant else { break }
      }

      let altDx = nei.rdx - location.rdx
      let altDy = nei.cdx - location.cdx
      var altPoint = Point(rdx: nei.rdx + altDx, cdx: nei.cdx + altDy)
      while include(altPoint) {
        answer.insert(altPoint)
        altPoint = Point(rdx: altPoint.rdx + altDx, cdx: altPoint.cdx + altDy)
        guard resonant else { break }
      }
    }
    return answer
  }

  func parseInput(_ input: String) -> (antennas: [String: Set<Point>], rows: Int, cols: Int) {
    var rdx = 0, cols = 0
    var answer: [String: Set<Point>] = [:]
    input.enumerateLines { line, _ in 
      let row = line.map { String($0) }  
      for cdx in 0..<row.count {
        let freq = row[cdx]
        guard freq != "." else { continue }
        answer[freq, default: Set<Point>()].insert(Point(rdx: rdx, cdx: cdx))
      }
      rdx += 1
      cols = line.count
    }
    return (antennas: answer, rows: rdx, cols: cols)
  }

  func debugPrint(_ nodes: [String: Set<Point>], _ antennas: [String: Set<Point>], rows: Int, cols: Int) {
    var matrix = Array(repeating: Array(repeating: ".", count: cols), count: rows)

    for (_, locations) in nodes {
      for location in locations {
        matrix[location.rdx][location.cdx] = "#"
      }
    }

    for (key, locations) in antennas {
      for location in locations {
        matrix[location.rdx][location.cdx] = key
      }
    }

    for row in matrix {
      print(row)
    }
  }
}
