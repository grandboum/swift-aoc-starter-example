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

extension Array where Element == [Any] {
  subscript(point: Point) -> Any {
    get {
      self[point.rdx][point.cdx]
    }
    set {
      self[point.rdx][point.cdx] = newValue
    }
  }
}
