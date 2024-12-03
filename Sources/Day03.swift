import Algorithms
import RegexBuilder

struct Day03: AdventDay, @unchecked Sendable {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  let regex = Regex {
    "mul("
    
    TryCapture {
      OneOrMore(.digit)
    } transform: { match in
      Int(match)
    }
    
    ","
    
    TryCapture {
      OneOrMore(.digit)
    } transform: { match in
      Int(match)
    }
    
    ")"
  }
  let disableRegex = /don't\(\)/
  let enableRegex = /do\(\)/

  func part1() -> Any {
    let matches = data.matches(of: regex)

    var answer = 0
    for match in matches {
      answer += match.output.1 * match.output.2
    }
    return answer
  }

  enum ItemType {
    case control(state: Bool)
    case value(data: Int)
  }

  struct Item {
    let range: Range<String.Index>
    let type: ItemType
  }

  func part2() -> Any {
    let enableMatches = data.matches(of: enableRegex)
    let disableMatches = data.matches(of: disableRegex)
    let matches = data.matches(of: regex)

    var allItems: [Item] = []
    for match in enableMatches {
      allItems.append(
        Item(range: match.range, type: .control(state: true))
      )
    }
    for match in disableMatches {
      allItems.append(
        Item(range: match.range, type: .control(state: false))
      )
    }
    for match in matches {
      let value = match.output.1 * match.output.2
      allItems.append(
        Item(range: match.range, type: .value(data: value))
      )
    }
    let sortedItems = allItems.sorted { $0.range.lowerBound < $1.range.lowerBound }

    var answer = 0
    var enabled = true
    for item in sortedItems {
      switch item.type {
        case .control(let state):
          enabled = state
        case .value(let data):
          if enabled {
            answer += data
          }
      }
    }
    return answer
  }
}
