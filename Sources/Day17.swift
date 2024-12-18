import Algorithms
import DequeModule
import RegexBuilder
import Foundation

struct Day17: AdventDay, @unchecked Sendable {
  var data: String

  enum Opcode: String {
    case adv = "0"
    case bxl = "1"
    case bst = "2"
    case jnz = "3"
    case bxc = "4"
    case out = "5"
    case bdv = "6"
    case cdv = "7"
  }

  struct Registers {
    var a: Int
    var b: Int
    var c: Int

    init(with storage: [String: Int]) {
      guard let aValue = storage["A"] else { fatalError("No A register value") }
      guard let bValue = storage["B"] else { fatalError("No B register value") }
      guard let cValue = storage["C"] else { fatalError("No C register value") }
      self.a = aValue
      self.b = bValue
      self.c = cValue
    }
    
    init(a: Int, b: Int, c: Int) {
      self.a = a
      self.b = b
      self.c = c
    }

    func updateA(_ a: Int) -> Registers {
      return Registers(a: a, b: self.b, c: self.c)
    }

    func updateB(_ b: Int) -> Registers {
      return Registers(a: self.a, b: b, c: self.c)
    }

    func updateC(_ c: Int) -> Registers {
      return Registers(a: self.a, b: self.b, c: c)
    }
  }

  enum ExecutionResult {
    case update(registers: Registers)
    case jump(offset: Int?)
    case output(value: Int)
  }

  struct Instruction {
    let opcode: Opcode
    let operand: Int

    var usesLiteral: Bool {
      if opcode == .bxl || opcode == .jnz {
        return true
      }
      return false
    }
  }

  func part1() -> Any {
    let input = parseInput()

    var ip = 0
    var registers = input.0
    let instructions = input.1

    var answer: [Int] = []
    while ip < instructions.count {
      let instruction = instructions[ip]
      let result = performInstruction(instruction, registers: registers)
      switch result {
        case .update(let newRegisters):
          registers = newRegisters
          ip += 1
        case .output(let value):
          answer.append(value) 
          ip += 1
        case .jump(let rawOffset):
          if let offset = rawOffset {
            ip = offset
          } else {
            ip += 1
          }
      }
    }
    return answer.map { String($0) }.joined(separator: ",")
  }
  
  func part2() -> Any {
    return true
  }

  func performInstruction(_ instruction: Instruction, registers: Registers) -> ExecutionResult {
    print(instruction)
    switch instruction.opcode {
      case .adv:
        return .update(registers: adv(instruction.operand, registers: registers))
      case .bxl:
        return .update(registers: bxl(instruction.operand, registers: registers))
      case .bst:
        return .update(registers: bst(instruction.operand, registers: registers))
      case .jnz:
        return .jump(offset: jnz(instruction.operand, registers: registers))
      case .bxc:
        return .update(registers: bxc(instruction.operand, registers: registers))
      case .out:
        return .output(value: out(instruction.operand, registers: registers))
      case .bdv:
        return .update(registers: bdv(instruction.operand, registers: registers))
      case .cdv:
        return .update(registers: cdv(instruction.operand, registers: registers))
    }
  }

  func adv(_ operand: Int, registers: Registers) -> Registers {
    let value = readValue(operand, registers: registers)
    let denom = 2.pow(value)
    let a = registers.a / denom
    return registers.updateA(a)
  }

  func bxl(_ operand: Int, registers: Registers) -> Registers {
    let b = registers.b ^ operand
    return registers.updateB(b)
  }

  func bst(_ operand: Int, registers: Registers) -> Registers {
    let value = readValue(operand, registers: registers)
    let b = value % 8
    return registers.updateB(b)
  } 

  func jnz(_ operand: Int, registers: Registers) -> Int? {
    guard registers.a != 0 else { return nil }
    return operand
  }

  func bxc(_ operand: Int, registers: Registers) -> Registers {
    let b = registers.b ^ registers.c
    return registers.updateB(b)
  }

  func out(_ operand: Int, registers: Registers) -> Int {
    let value = readValue(operand, registers: registers)
    return value % 8
  }

  func bdv(_ operand: Int, registers: Registers) -> Registers {
    let value = readValue(operand, registers: registers)
    let denom = 2.pow(value)
    let b = registers.a / denom
    return registers.updateB(b)
  }
  
  func cdv(_ operand: Int, registers: Registers) -> Registers {
    let value = readValue(operand, registers: registers)
    let denom = 2.pow(value)
    let c = registers.a / denom
    return registers.updateC(c)
  }
    
  func readValue(_ at: Int, registers: Registers) -> Int {
    switch at {
      case 0...3:
        return at
      case 4:
        return registers.a
      case 5:
        return registers.b
      case 6:
        return registers.c
      default:
        fatalError("Unknown combo operand: \(at)")
    }
  }

  func parseInput() -> (Registers, [Instruction]) {
    var registers: [String: Int] = [:]
    var instructions: [Instruction] = []
    data.enumerateLines { line, _ in 
      if let matches = line.wholeMatch(of: registerRegex) {
        registers[matches.1] = matches.2
      } else if let match = line.wholeMatch(of: programmRegex) {
        instructions = parseInstructions(String(match.1)) 
      }
    }
    return (Registers(with: registers), instructions)
  }

  func parseInstructions(_ line: String) -> [Instruction] {
    let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

    let parts = cleanLine.components(separatedBy: ",")

    var answer: [Instruction] = []
    for idx in stride(from: 0, to: parts.count, by: 2) {
      guard let opcode = Opcode(rawValue: parts[idx]) else { fatalError("Can't parse opcode") }
      guard let operand = Int(parts[idx+1]) else { fatalError("Can't parse operand") }
      answer.append(Instruction(opcode: opcode, operand: operand))
    }
    return answer
  }

  let registerRegex = Regex {
    "Register"
	OneOrMore(.whitespace)
    TryCapture {
      One(.word)
    } transform: { match in
      String(match)
    }
    ":"
    OneOrMore(.whitespace)
    TryCapture {
      OneOrMore(.digit)
    } transform: { match in
      Int(match)
    }
  }.anchorsMatchLineEndings()

  let programmRegex = /Program: (.*)/
}
