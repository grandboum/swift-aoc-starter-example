import Algorithms

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  enum HandType: Int, CaseIterable {
    case highCard = 0
    case pair = 1
    case twoPair = 2
    case kind3 = 3
    case fullHouse = 4
    case kind4 = 5
    case kind5 = 6
  }

  var cardsOrder: [String.Element: Int] {
    let order: [String.Element] = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
    var lookup: [String.Element: Int] = [:]
    for (idx, item) in order.enumerated() {
      lookup[item] = order.count - idx
    }
    return lookup
  }

  func parse(lines: [String], order: [String.Element: Int], joker: Bool) -> [(String, Int)] {
    var answer: [(String, Int)] = []
    var storage: [HandType: [(String, Int)]] = [:]
    for line in lines {
      let parts = line.split(separator: " ").map { String($0) }

      guard let hand = parts.first else { continue }
      guard let bidVal = parts.last, let bid = Int(bidVal) else { continue }

      let type = parseHand(hand, joker: joker)
      storage[type, default: []].append((hand, bid))
    }

    for type in HandType.allCases {
      guard let val = storage[type] else { continue }
      answer.append(contentsOf: val.sorted(by: { compareHands(lhs: $0.0, rhs: $1.0, lookup: order)}))
    }
    return answer
  }

  func compareHands(lhs: String, rhs: String, lookup: [String.Element: Int]) -> Bool {
    var left = lhs.startIndex
    var right = rhs.startIndex
    while left != lhs.endIndex && right != rhs.endIndex {
      guard lhs[left] == rhs[right] else { return lookup[lhs[left]]! < lookup[rhs[right]]! }
      left = lhs.index(after: left)
      right = rhs.index(after: right)
    }
    return true
  }

  func parseHand(_ hand: String, joker: Bool) -> HandType {
    var count: [String.Element: Int] = [:]
    for card in hand {
      count[card] = count[card, default: 0] + 1
    }

    let values = Array(count.values)
    guard values.count != 1 else { return .kind5 }
    guard !values.contains(4) else { 
      guard joker && count["J"] != nil else { return .kind4 }
      return .kind5
    }
    guard !(values.contains(3) && values.contains(2)) else { 
      guard joker && count["J"] != nil else { return .fullHouse }
      return .kind5
    }
    guard !values.contains(3) else { 
      guard joker && count["J"] != nil else { return .kind3 }
      return .kind4
    }
    guard !(values.filter({ $0 == 2}).count == 2) else { 
      guard joker && count["J"] != nil else { return .twoPair }
      guard count["J"] == 2 else { return .fullHouse }
      return .kind4
    }
    guard !values.contains(2) else { 
      guard joker && count["J"] != nil else { return .pair }
      return .kind3
    }
    guard joker && count["J"] != nil else { return .highCard }
    return .pair
  }

  func part1() -> Any {
    let order: [String.Element] = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
    var lookup: [String.Element: Int] = [:]
    for (idx, item) in order.enumerated() {
      lookup[item] = order.count - idx
    }
    let input = parse(lines: entities, order: lookup, joker: false)

    var answer = 0
    for (idx, item) in input.enumerated() {
      answer += item.1 * (idx + 1)
    }
    return answer
  }

  func part2() -> Any {
    let order: [String.Element] = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]
    var lookup: [String.Element: Int] = [:]
    for (idx, item) in order.enumerated() {
      lookup[item] = order.count - idx
    }
    let input = parse(lines: entities, order: lookup, joker: true)
    
    var answer = 0
    for (idx, item) in input.enumerated() {
      answer += item.1 * (idx + 1)
    }
    return answer
  }
}
