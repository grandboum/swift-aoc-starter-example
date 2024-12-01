import Algorithms

struct Day19: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  func part1() -> Any {
    let (rules, ratings) = parse(entities)

    var answer = 0
    for rating in ratings {
      guard process(rating, book: rules) else { continue }
      answer += rating.values.reduce(0, +)
    }
    return answer
  }

  func part2() -> Any {
    return "WIP"
  }

  func process(_ rating: [String: Int], book: RuleBook) -> Bool {
    var ruleKey = "in"

    while true {
      guard let rule = book.rules[ruleKey] else { fatalError("Looking for rule \(ruleKey) but no luck") }
      loadRule: for cond in rule.cond {
        switch evaluate(cond, rating: rating) {
          case .finish(let result):
            return result
          case .jmp(let rule):
            ruleKey = rule
            break loadRule
          case .cont:
            break
        }
      }
    }
    fatalError("You should have returned something earlier")
  }

  func evaluate(_ cond: Condition, rating: [String: Int]) -> EvResult {
    let handle: (Outcome) -> EvResult = { outcome in
      switch outcome {
        case .reject:
          return .finish(val: false)
        case .accept:
          return .finish(val: true)
        case .transfer(let name):
          return .jmp(name: name)
        }
    }

    switch cond {
      case .less(let name, let val, let outcome):
        guard let num = rating[name] else { fatalError("No value for \(name)") }
        guard num < val else { return .cont }
        return handle(outcome)
      case .greater(let name, let val, let outcome):
        guard let num = rating[name] else { fatalError("No value for \(name)") }
        guard num > val else { return .cont }
        return handle(outcome)
      case .immediate(let outcome):
        return handle(outcome)
    }
  }
}

extension Day19 {
  struct RuleBook {
    let rules: [String: Rule]
  }

  struct Rule {
    let name: String
    let cond: [Condition]
  }

  enum Condition {
    case less(name: String, val: Int, jmp: Outcome)
    case greater(name: String, val: Int, jmp: Outcome)
    case immediate(jmp: Outcome)
  }

  enum Outcome {
    case reject
    case accept
    case transfer(name: String)
  }

  enum EvResult {
    case finish(val: Bool)
    case jmp(name: String)
    case cont
  }
}

extension Day19 {
  func parse(_ input: [String]) -> (RuleBook, [[String: Int]]) {
    var rules: [String] = []
    var values: [String] = []
    for line in input {
      if line[line.startIndex] == "{" {
        values.append(line)
      } else {
        rules.append(line)
      }
    }

    let parsedRules = rules.map { parseRule($0) }
    let book = RuleBook(rules: Dictionary(uniqueKeysWithValues: parsedRules.map { ($0.name, $0) }))

    let ratings = values.map { parseRating($0) }

    return (book, ratings)
  }

  func parseRating(_ rating: String) -> [String: Int] {
    let clean = String(rating.dropFirst().dropLast())
    let parts = clean.split(separator: ",").map { String($0) }

    var answer: [String: Int] = [:]
    for part in parts {
      let pair = part.split(separator: "=").map { String($0) }
      answer[pair[0]] = Int(pair[1])
    }
    return answer
  }

  func parseRule(_ rule: String) -> Rule {
    let parts = rule.split(separator: "{").map { String($0) }
    let name = parts[0]
    let body = String(parts[1].dropLast())
    let cond = parseRuleBody(body)
    return Rule(name: name, cond: cond)
  }

  func parseRuleBody(_ body: String) -> [Condition] {
    var conditions = body.split(separator: ",").map { String($0) }
    let finalCondition = conditions.last!
    conditions = conditions.dropLast()

    var answer: [Condition] = []
    for cond in conditions {
      answer.append(Condition.parse(cond))
    }
    answer.append(Condition.immediate(jmp: Outcome.parse(finalCondition)))
    return answer
  }
}

extension Day19.Outcome {
  static func parse(_ val: String) -> Self {
    guard val != "A" else { return .accept }
    guard val != "R" else { return .reject }
    return .transfer(name: val)
  }
}
  
extension Day19.Condition {
  static func parse(_ val: String) -> Self {
    let parts = val.split(separator: ":").map { String($0) }
    let main = parts[0]
    let outcome = Day19.Outcome.parse(parts[1])

    if main.contains(">") {
      let mainParts = main.split(separator: ">").map { String($0) }
      guard let val = Int(mainParts[1]) else { fatalError("Nopeee: \(mainParts[1])") }
      return .greater(name: mainParts[0], val: val, jmp: outcome)
    } else {
      let mainParts = main.split(separator: "<").map { String($0) }
      guard let val = Int(mainParts[1]) else { fatalError("Nopeee: \(mainParts[1])") }
      return .less(name: mainParts[0], val: val, jmp: outcome)
    }
  }
}
