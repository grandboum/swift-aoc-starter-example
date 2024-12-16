import Algorithms
import DequeModule
import RegexBuilder
import Foundation

struct Day14: AdventDay, @unchecked Sendable {
  var data: String

  struct RobotInfo: Equatable {
	let position: Point
	let velocity: Direction
  }

  func part1() -> Any {
    return true
  }
  
  func part2() -> Any {
    return true
  }

  func parseInput() -> [RobotInfo] {
	var answer: [RobotInfo] = []
    data.enumerateLines { line, _ in
      guard let match = line.trimmingCharacters(in: .whitespacesAndNewlines).wholeMatch(of: regex)?.output else { fatalError("Can't match regex: \(line)") }
	  guard let rdx = Int(match.1), let cdx = Int(match.2), let dr = Int(match.3), let dc = Int(match.4) else { fatalError("Can't convert to int: \(match)") }
	  let info = RobotInfo(position: Point(rdx: rdx, cdx: cdx), velocity: Direction(dr: dr, dc: dc))
	  answer.append(info)
    }
    return answer
  }

  private let regex = Regex {
    "p="
    Capture {
        Regex {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        }
    }
    ","
    Capture {
        Regex {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        }
    }
    " v="
    Capture {
        Regex {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        }
    }
    ","
    Capture {
        Regex {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        }
    }
  }
}
