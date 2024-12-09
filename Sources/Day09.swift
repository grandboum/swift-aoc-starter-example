import Algorithms
import DequeModule
import Foundation

struct Day09: AdventDay, @unchecked Sendable {
  var data: String

  func part1() -> Any {
    let disk = parseInput(data)
    _ = countEmptySpace(disk)
    let fragmented = moveBlocks(disk, fragmented: true)
    let checksum = calcChecksum(fragmented)
    return checksum
  }
  
  func part2() -> Any {
    let disk = parseInput(data)
    let fragmented = moveBlocks(disk, fragmented: false)
    let checksum = calcChecksum(fragmented)
    return checksum
  }

  func parseInput(_ input: String) -> [Int] {
    let compressed = Array(input).map { String($0) }
    guard compressed.count == input.count else { fatalError("Can't parse data") }

    let expanded = expand(compressed)
    return expanded
  }

  func expand(_ disk: [String]) -> [Int] {
    var fileIdx = 0
    var answer: [Int] = []
    for (idx, val) in disk.enumerated() {
      let processed = val.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !processed.isEmpty else { 
        print("Met empty value")
        continue 
      }
      guard let dgt = Int(processed) else { fatalError("Can't parse string: \(val)") }
      let isFile = idx % 2 == 0

      if dgt == 0 {
        if isFile {
          fileIdx += 1
        }
        continue
      }

      let blockValue = if isFile { fileIdx } else { -1 }
      let temp = Array(repeating: blockValue, count: dgt)
      answer.append(contentsOf: temp)
      if isFile {
        fileIdx += 1
      }
    }
    return answer
  }

  func countEmptySpace(_ disk: [Int]) -> Int {
    var left = 0, right = disk.count - 1

    while right > left && disk[right] == -1 {
      right -= 1
    }

    guard right > left else { return 0 }

    var count = 0
    while left < right {
      if disk[left] == -1 {
        count += 1
      }
      left += 1
    }
    return count
  }

  func moveBlocks(_ input: [Int], fragmented: Bool) -> [Int] {
    var disk = input
    var right = disk.count - 1
    while right > 0 {
      while right > 0 && disk[right] == -1 {
        right -= 1
      }

      let fileSize = if fragmented { 1 } else { calcFileSize(lastIdx: right, disk) }
      guard let emptyBlockStart = findEmptyBlock(of: fileSize, in: disk, before: right, start: 0) else { 
        right -= fileSize
        continue
      }
      
      guard right > emptyBlockStart else { break }
      for writeIdx in emptyBlockStart..<(emptyBlockStart+fileSize) {
        disk[writeIdx] = disk[right]
        disk[right] = -1
        right -= 1
      }
    }
    return disk
  }

  func calcFileSize(lastIdx: Int, _ disk: [Int]) -> Int {
    var idx = lastIdx
    let fileId = disk[lastIdx]

    while idx >= 0 && disk[idx] == fileId {
      idx -= 1
    }

    return lastIdx - idx
  }

  func findEmptyBlock(of size: Int, in disk: [Int], before right: Int, start: Int = 0) -> Int? {
    var left = start
    while left < right && disk[left] != -1 {
      left += 1
    }

    guard left < right else { return nil }
    let blockStart = left
    var count = 0
    while left < right && disk[left] == -1 && count < size {
      count += 1
      left += 1
    }

    guard count != size else { return blockStart }
    return findEmptyBlock(of: size, in: disk, before: right, start: left)
  }

  func calcChecksum(_ disk: [Int]) -> Int {
    var answer = 0
    for (idx, num) in disk.enumerated() {
      guard num != -1 else { continue }
      answer += idx * num
    }
    return answer
  }

  func _diskConverter(_ disk: [Int]) -> String {
    var answer: [String] = []

    for num in disk {
      if num == -1 {
        answer.append(".")
      } else {
        answer.append(String(num))
      }
    }
    return answer.joined(separator: "")
  }
}
