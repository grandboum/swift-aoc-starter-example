import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day17Tests {
  // Smoke test data provided in the challenge question
  let firstFile = """
   Register A: 729
   Register B: 0
   Register C: 0

   Program: 0,1,5,4,3,0
   """

  @Test func testPart1() async throws {
    let challenge = Day17(data: firstFile)
    #expect(String(describing: challenge.part1()) == "4,6,3,5,6,3,5,2,1,0")
  }

  @Test func testPart2() async throws {
    let challenge = Day17(data: firstFile)
    #expect(String(describing: challenge.part2()) == "117440")
  }
}
