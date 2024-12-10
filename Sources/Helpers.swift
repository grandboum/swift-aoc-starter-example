import Foundation

struct Point: Hashable {
  let rdx: Int
  let cdx: Int
}

struct Direction: Hashable {
  let dr: Int
  let dc: Int
  static var startingDirection: Direction { Direction(dr: -1, dc: 0) }

  func rotateClockwise() -> Direction {
    return Direction(dr: dc, dc: -1 * dr)
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
}

func power(_ num: UInt64, _ pow: Int) -> UInt64 {
  guard pow >= 0 else { fatalError("Not supported") }

  var answer: UInt64 = 1
  for _ in 0..<pow {
    answer *= num
  }
  return answer
}
