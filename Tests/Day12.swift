import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day12Tests {
  // Smoke test data provided in the challenge question
  let file = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

  let input = [
	["R", "R", "R", "R", "I", "I", "C", "C", "F", "F"],
	["R", "R", "R", "R", "I", "I", "C", "C", "C", "F"],
	["V", "V", "R", "R", "R", "C", "C", "F", "F", "F"],
	["V", "V", "R", "C", "C", "C", "J", "F", "F", "F"],
	["V", "V", "V", "V", "C", "J", "J", "C", "F", "E"],
	["V", "V", "I", "V", "C", "C", "J", "J", "E", "E"],
	["V", "V", "I", "I", "I", "C", "J", "J", "E", "E"],
	["M", "I", "I", "I", "I", "I", "J", "J", "E", "E"],
	["M", "I", "I", "I", "S", "I", "J", "E", "E", "E"],
	["M", "M", "M", "I", "S", "S", "J", "E", "E", "E"]
  ]

  @Test func testParsing() async throws {
    let challenge = Day12(data: file)
    #expect(challenge.parseInput() == input)
  }

  @Test func testPart1() async throws {
    let challenge = Day12(data: file)
    #expect(String(describing: challenge.part1()) == "1930")
  }

  @Test func testPart2() async throws {
    let challenge = Day12(data: file)
    #expect(String(describing: challenge.part2()) == "1206")
  }
}
