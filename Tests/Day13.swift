import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day13Tests {
  // Smoke test data provided in the challenge question
  let file = """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    """

  let input = [
    Day13.Game(aButton: Direction(dr: 94, dc: 34), bButton: Direction(dr: 22, dc: 67), prize: Point(rdx: 8400, cdx: 5400)),
    Day13.Game(aButton: Direction(dr: 26, dc: 66), bButton: Direction(dr: 67, dc: 21), prize: Point(rdx: 12748, cdx: 12176)),
    Day13.Game(aButton: Direction(dr: 17, dc: 86), bButton: Direction(dr: 84, dc: 37), prize: Point(rdx: 7870, cdx: 6450)),
    Day13.Game(aButton: Direction(dr: 69, dc: 23), bButton: Direction(dr: 27, dc: 71), prize: Point(rdx: 18641, cdx: 10279)),
  ]

  @Test func testParsing() async throws {
    let challenge = Day13(data: file)
    #expect(challenge.parseInput() == input)
  }

  @Test func testPart1() async throws {
    let challenge = Day13(data: file)
    #expect(String(describing: challenge.part1()) == "480")
  }

  @Test func testPart2() async throws {
    let challenge = Day13(data: file)
    #expect(String(describing: challenge.part1()) == "480")
  }
}