import Algorithms
import DequeModule

struct Day05: AdventDay, @unchecked Sendable {
  var data: String


  func part1() -> Any {
    let (rules, orders) = parseInput(data)
    let (valid, _) = filterOrders(rules: rules, orders: orders)
    
    var answer = 0
    for order in valid {
      let midIdx = order.count / 2
      answer += order[midIdx]
    }
    return answer
  }
  
  func part2() -> Any {
    let (rules, orders) = parseInput(data)
    let dependencies = turnRulesInsideOut(rules: rules)
    let (_, invalid) = filterOrders(rules: rules, orders: orders)

    var answer = 0
    for order in invalid {
      let validOrder = fixupOrder(order: order, rules: rules, deps: dependencies)
      let midIdx = validOrder.count / 2
      answer += validOrder[midIdx]
    }
 
    return answer
  }

  func turnRulesInsideOut(rules: [Int: [Int]]) -> [Int: [Int]] {
    var updatedRules: [Int: [Int]] = [:]

    for (key, deps) in rules {
      for dep in deps {
        updatedRules[dep, default: []].append(key)
      }
    }
    return updatedRules
  }

  func fixupOrder(order: [Int], rules: [Int: [Int]], deps: [Int: [Int]]) -> [Int] {
    let requested = Set(order)

    var indegree: [Int: Int] = [:] 
    var que: Deque<Int> = []
    for item in order {
      var count = 0
      let dependencies = rules[item] ?? []
      for dep in dependencies {
        guard requested.contains(dep) else { continue }
        count += 1
      }
      indegree[item] = count
      if count == 0 {
        que.append(item)
      }
    }

    var answer: [Int] = []
    while !que.isEmpty {
      let page = que.removeFirst()
      answer.append(page)
      guard let neighbours = deps[page] else { continue }
      for nei in neighbours {
        guard indegree.keys.contains(nei) else { continue }
        indegree[nei, default: 1] -= 1
        if indegree[nei] == 0 {
          que.append(nei)
        }
      } 
    } 
    return answer
  }

  func filterOrders(rules: [Int: [Int]], orders: [[Int]]) -> ([[Int]], [[Int]]) {
    var validOrders: [[Int]] = []
    var invalidOrders: [[Int]] = []

    for order in orders {
      var inprogress = Set(order)
      var valid = true
      for page in order {
        if let deps = rules[page] {
          let pageDeps = Set(deps)
          let common = pageDeps.intersection(inprogress)
          if !common.isEmpty {
            valid = false 
            break
          } 
        }
        inprogress.remove(page)
      }
      if valid {
        validOrders.append(order)
      } else {
        invalidOrders.append(order)
      }
    }
    return (validOrders, invalidOrders)
  }
 
  func parseInput(_ input: String) -> ([Int: [Int]], [[Int]]) {
    var ordering: [String] = []
    var orders: [String] = []
    var seenBreak = false
    input.enumerateLines { line, _ in
      if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        seenBreak = true
        return 
      }
      if seenBreak {
        orders.append(line)
      } else {
        ordering.append(line)
      }
    }
    
    var sequence: [Int: [Int]] = [:]
    for rule in ordering {
      let parts = rule.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "|")
      guard let firstPart = parts.first, let lastPart = parts.last else { fatalError("Wrong ordering data") }
      guard let first = Int(firstPart), let last = Int(lastPart) else { fatalError("Wrong ordering data") }
      sequence[last, default: []].append(first)
    }

    var pages: [[Int]] = []
    for order in orders {
      let parts = order.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",").compactMap{ Int($0) }
      pages.append(parts)
    }
    return (sequence, pages)
  }
}
