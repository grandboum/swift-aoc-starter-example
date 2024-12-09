import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day09Tests {
  // Smoke test data provided in the challenge question
  let file = """
    2333133121414131402
    """

  @Test func testParsing() async throws {
    let challenge = Day09(data: file)
    #expect(challenge.parseInput(file) == [0, 0, -1,-1,-1,1,1,1,-1,-1,-1,2,-1,-1,-1,3,3,3,-1,4,4,-1,5,5,5,5,-1,6,6,6,6,-1,7,7,7,-1,8,8,8,8,9,9])
  }

  @Test func testMoving() async throws {
    let challenge = Day09(data: file)
    let disk = challenge.parseInput(file)
    let moved = challenge.moveBlocks(disk, fragmented: true)
    let transformed = challenge._diskConverter(moved)
    #expect(transformed == "0099811188827773336446555566..............")
  }

  @Test func testMovingDefragmented() async throws {
    let challenge = Day09(data: file)
    let disk = challenge.parseInput(file)
    let moved = challenge.moveBlocks(disk, fragmented: false)
    let transformed = challenge._diskConverter(moved)
    #expect(transformed == "00992111777.44.333....5555.6666.....8888..")
  }
 
  @Test func testPart1() async throws {
    let challenge = Day09(data: file)
    #expect(String(describing: challenge.part1()) == "1928")
  }

  @Test func testPart2() async throws {
    let challenge = Day09(data: file)
    #expect(String(describing: challenge.part2()) == "2858")
  }
}
