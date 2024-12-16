import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day16Tests {
  // Smoke test data provided in the challenge question
  let firstFile = """
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    """
  let secondFile = """
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################
    """

  let firstAnswer = 7036
  let secondAnswer = 11048

  let firstAnswerPart2 = 45
  let secondAnswerPart2 = 64

  @Test func testPart1() async throws {
    let challenge = Day16(data: firstFile)
    #expect(String(describing: challenge.part1()) == "\(firstAnswer)")
    
    let secondChallenge = Day16(data: secondFile)
    #expect(String(describing: secondChallenge.part1()) == "\(secondAnswer)")
  }

  @Test func testPart2() async throws {
    let challenge = Day16(data: firstFile)
    #expect(String(describing: challenge.part2()) == "\(firstAnswerPart2)")
    
    let secondChallenge = Day16(data: secondFile)
    #expect(String(describing: secondChallenge.part2()) == "\(secondAnswerPart2)")
  }
}
