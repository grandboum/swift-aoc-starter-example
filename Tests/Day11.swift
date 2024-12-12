import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day11Tests {
  // Smoke test data provided in the challenge question
  let file = "125 17"
  let input = [125, 17]

  @Test func testParsing() async throws {
    let challenge = Day11(data: file)
    #expect(challenge.parseInput() == input)
  }

  @Test func testPart1() async throws {
    let challenge = Day11(data: file)
    #expect(String(describing: challenge.part1()) == "55312")
  }

  @Test func testPart2() async throws {
    let challenge = Day11(data: file)
    #expect(String(describing: challenge.part2()) == "65601038650482")
  }
}