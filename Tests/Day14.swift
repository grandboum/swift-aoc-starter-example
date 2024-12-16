import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day14Tests {
  // Smoke test data provided in the challenge question
  let file = """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """

  let input = [
    Day14.RobotInfo(position: Point(rdx: 0, cdx: 4), velocity: Direction(dr: 3, dc: -3)),
    Day14.RobotInfo(position: Point(rdx: 6, cdx: 3), velocity: Direction(dr: -1, dc: -3)),
    Day14.RobotInfo(position: Point(rdx: 10, cdx: 3), velocity: Direction(dr: -1, dc: 2)),
    Day14.RobotInfo(position: Point(rdx: 2, cdx: 0), velocity: Direction(dr: 2, dc: -1)),
    Day14.RobotInfo(position: Point(rdx: 0, cdx: 0), velocity: Direction(dr: 1, dc: 3)),
    Day14.RobotInfo(position: Point(rdx: 3, cdx: 0), velocity: Direction(dr: -2, dc: -2)),
    Day14.RobotInfo(position: Point(rdx: 7, cdx: 6), velocity: Direction(dr: -1, dc: -3)),
    Day14.RobotInfo(position: Point(rdx: 3, cdx: 0), velocity: Direction(dr: -1, dc: -2)),
    Day14.RobotInfo(position: Point(rdx: 9, cdx: 3), velocity: Direction(dr: 2, dc: 3)),
    Day14.RobotInfo(position: Point(rdx: 7, cdx: 3), velocity: Direction(dr: -1, dc: 2)),
    Day14.RobotInfo(position: Point(rdx: 2, cdx: 4), velocity: Direction(dr: 2, dc: -3)),
    Day14.RobotInfo(position: Point(rdx: 9, cdx: 5), velocity: Direction(dr: -3, dc: -3))
  ]

  @Test func testParsing() async throws {
    let challenge = Day14(data: file)
    #expect(challenge.parseInput() == input)
  }

  @Test func testPart1() async throws {
    let challenge = Day14(data: file)
    #expect(String(describing: challenge.part1()) == "12")
  }

  @Test func testPart2() async throws {
    let challenge = Day14(data: file)
    #expect(String(describing: challenge.part1()) == "480")
  }
}
