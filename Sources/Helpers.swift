import Foundation

extension Int {
  var dgtCount: Int { return String(self).count }

  func pow(_ power: Int) -> Int {
    guard power >= 0 else { fatalError("Not supported") }

    var answer: Int = 1
    for _ in 0..<power {
      answer *= self
    }
    return answer
  }
}

extension String {
  func convertToMatrix() -> [[String]] {
    var result: [[String]] = []
    enumerateLines { line, _ in
        result.append(line.map(String.init))
    }
    return result
  }
}

struct Point: Hashable {
  let rdx: Int
  let cdx: Int

  func distance(to another: Point) -> Int {
    return (rdx - another.rdx).pow(2) + (cdx - another.rdx).pow(2)
  }
}

struct Direction: Hashable {
  let dr: Int
  let dc: Int
  static let startingDirection: Direction  = .north
  static let allDirections: [Direction] = [ .north, .south, .west, .east ]

  func rotateClockwise() -> Direction {
    return Direction(dr: dc, dc: -1 * dr)
  }

  static var north: Direction { return Direction(dr: -1, dc: 0) }
  static var south: Direction { return Direction(dr: 1, dc: 0) }
  static var west: Direction { return Direction(dr: 0, dc: -1) }
  static var east: Direction { return Direction(dr: 0, dc: 1) }

  static var top: Direction { return .north }
  static var bottom: Direction { return .south }
  static var left: Direction { return .west }
  static var right: Direction { return .east }

  func isOppositeDirection(_ direction: Direction) -> Bool {
    if direction == .north && self == .south { return true }
    if direction == .south && self == .north { return true }
    if direction == .west && self == .east { return true }
    if direction == .east && self == .west { return true }
    return false 
  }
}

extension Point {
  func move(in direction: Direction) -> Point {
    return Point(rdx: rdx + direction.dr, cdx: cdx + direction.dc)
  }
}

struct Matrix<T> {
  typealias Indices = Range<Int>

  var storage: [[T]]
  var rows: Indices {
    return 0..<storage.count
  }
  var cols: Indices {
    return 0..<storage[0].count
  }

  init(_ raw: [[T]]) {
    storage = raw
  }

  subscript(point: Point) -> T {
    get {
      storage[point.rdx][point.cdx]
    }
    set {
      storage[point.rdx][point.cdx] = newValue
    }
  }

  func contains(point: Point) -> Bool {
    if point.rdx < 0 || point.rdx >= storage.count {
      return false 
    }
    if point.cdx < 0 || point.cdx >= storage[point.rdx].count {
      return false 
    }
    return true
  }

  func explore(_ callback: (Point) -> Void) {
    for rdx in storage.indices {
      for cdx in storage[rdx].indices {
        let point = Point(rdx: rdx, cdx: cdx)
        callback(point)
      }
    }
  }
}

func power(_ num: UInt64, _ pow: Int) -> UInt64 {
  guard pow >= 0 else { fatalError("Not supported") }

  var answer: UInt64 = 1
  for _ in 0..<pow {
    answer *= num
  }
  return answer
}
