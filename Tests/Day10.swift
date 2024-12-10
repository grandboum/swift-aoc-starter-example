import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day10Tests {
  // Smoke test data provided in the challenge question
  let file = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

  let input = [
    [8, 9, 0, 1, 0, 1, 2, 3],
    [7, 8, 1, 2, 1, 8, 7, 4],
    [8, 7, 4, 3, 0, 9, 6, 5],
    [9, 6, 5, 4, 9, 8, 7, 4],
    [4, 5, 6, 7, 8, 9, 0, 3],
    [3, 2, 0, 1, 9, 0, 1, 2],
    [0, 1, 3, 2, 9, 8, 0, 1],
    [1, 0, 4, 5, 6, 7, 3, 2]
  ]

  @Test func testParsing() async throws {
    let challenge = Day10(data: file)
    #expect(challenge.parseInput() == input)
  }

  @Test func testPart1() async throws {
    let challenge = Day10(data: file)
    #expect(String(describing: challenge.part1()) == "36")
  }

  @Test func testPart2() async throws {
    let challenge = Day10(data: file)
    #expect(String(describing: challenge.part2()) == "81")
  }
}
