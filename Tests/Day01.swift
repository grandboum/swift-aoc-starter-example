import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day01Tests {
  // Smoke test data provided in the challenge question
  let testData = """
	3   4
	4   3
	2   5
	1   3
	3   9
	3   3
	"""

  @Test func testParsing() async throws {
    let challenge = Day01(data: testData)
    #expect([[3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]] == challenge.parse(testData))
  }

  @Test func testPart1() async throws {
    let challenge = Day01(data: testData)
    #expect(String(describing: challenge.part1()) == "11")
  }

  @Test func testPart2() async throws {
    let challenge = Day01(data: testData)
    #expect(String(describing: challenge.part2()) == "31")
  }
}
