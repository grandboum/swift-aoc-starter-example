import Algorithms
import DequeModule
import RegexBuilder
import Foundation

struct Day13: AdventDay, @unchecked Sendable {
  var data: String

  struct Game: Equatable {
    let aButton: Direction
    let bButton: Direction
    let prize: Point

	func pressA(_ state: GameState) -> GameState {
	  let nextPosition = state.position.move(in: aButton)
	  return GameState(
        position: nextPosition, 
		distance: prize.distance(to: nextPosition),
        aPresses: state.aPresses + 1, 
        bPresses: state.bPresses
      )
	} 
	
    func pressB(_ state: GameState) -> GameState {
	  let nextPosition = state.position.move(in: bButton)
	  return GameState(
        position: nextPosition, 
		distance: prize.distance(to: nextPosition),
        aPresses: state.aPresses, 
        bPresses: state.bPresses + 1
      )
	} 
  }

  struct GameState: Equatable, Hashable, Comparable {
    let position: Point
	let distance: Int
	let aPresses: Int
	let bPresses: Int

    static func < (lhs: GameState, rhs: GameState) -> Bool {
	  return lhs.distance < rhs.distance
	}
  } 

  func part1() -> Any {
	let games = parseInput()

	var cost = 0
	for game in games {
	  guard let state = solveMath(game) else { continue }
      cost += state.aPresses * 3 + state.bPresses
	}
    return cost
  }
  
  func part2() -> Any {
    let games = parseInput(true)

    var cost = 0
    for game in games {
      guard let state = solveMath(game) else { continue }
      cost += state.aPresses * 3 + state.bPresses
    }
    return cost
  }

  func solveMath(_ game: Game) -> GameState? {
    //A = (p_x*b_y - prize_y*b_x) / (a_x*b_y - a_y*b_x)
    //B = (a_x*p_y - a_y*p_x) / (a_x*b_y - a_y*b_x)

    let common = (game.aButton.dr * game.bButton.dc - game.aButton.dc * game.bButton.dr)
    let aPresses = (game.prize.rdx * game.bButton.dc - game.prize.cdx * game.bButton.dr) / common
    let bPresses = (game.aButton.dr * game.prize.cdx - game.aButton.dc * game.prize.rdx) / common

    let x = game.aButton.dr * aPresses + game.bButton.dr * bPresses
    let y = game.aButton.dc * aPresses + game.bButton.dc * bPresses
    let point = Point(rdx: x, cdx: y)

    guard point == game.prize else { return nil } 
    return GameState(position: point, distance: 0, aPresses: aPresses, bPresses: bPresses)
  }

  func solveBrute(_ game: Game) -> GameState? {
    var heap: Heap<GameState> = []
    let start = Point(rdx: 0, cdx: 0)
	var visited: Set<Point> = [start]
	heap.insert(GameState(position: start, distance: game.prize.distance(to: start), aPresses: 0, bPresses: 0))

	while let state = heap.popMin() {
      guard state.aPresses <= 100 && state.bPresses <= 100 else { continue }
	  if state.position == game.prize {
		return state	
	  }
	  let pressA = game.pressA(state)
	  if !visited.contains(pressA.position) {
		visited.insert(pressA.position)
		heap.insert(pressA)
      }
	  let pressB = game.pressB(state)
	  if !visited.contains(pressB.position) {
		visited.insert(pressB.position)
		heap.insert(pressB)
	  }
    }
	return nil
  }

  func parseInput(_ useCorrection: Bool = false) -> [Game] {
    let rawGames = data.split(separator: "\n\n").compactMap { String($0) }
    guard !rawGames.isEmpty else { fatalError("Can't separate games") }

    var answer: [Game] = []
    for rawGame in rawGames {
      let parts = rawGame.split(separator: "\n").compactMap { String($0) }
      guard parts.count == 3 else { fatalError("Can't parse a game") }
	  let aButton = parseButton(parts[0])
	  let bButton = parseButton(parts[1])
	  let prize = parsePrize(parts[2], useCorrection: useCorrection)
	  let game = Game(aButton: aButton, bButton: bButton, prize: prize)
	  answer.append(game)
    }
    return answer
  }

  func parseButton(_ button: String) -> Direction {
    let regex = Regex {
	  ZeroOrMore {
        /./
      }
	  "X+"
      Capture {
        OneOrMore(("0"..."9"))
      }
      ", Y+"
      Capture {
        OneOrMore(("0"..."9"))
      }
    }
    .anchorsMatchLineEndings()

    guard let match = button.wholeMatch(of: regex)?.output else { fatalError("Can't match regex: \(button)") }
	guard let dr = Int(match.1), let dc = Int(match.2) else { fatalError("Can't convert to Int: \(match)") }
	return Direction(dr: dr, dc: dc)
  }

  func parsePrize(_ prize: String, useCorrection: Bool) -> Point {
    let regex = Regex {
	  ZeroOrMore {
        /./
      }
	  "X="
      Capture {
        OneOrMore(("0"..."9"))
      }
      ", Y="
      Capture {
        OneOrMore(("0"..."9"))
      }
    }
    .anchorsMatchLineEndings()

    guard let match = prize.wholeMatch(of: regex)?.output else { fatalError("Can't match prize regex") }
	guard let rdx = Int(match.1), let cdx = Int(match.2) else { fatalError("Can't convert prize to Int") }
	return Point(rdx: useCorrection ? rdx + 10000000000000 : rdx, cdx: useCorrection ? cdx + 10000000000000 : cdx)
  }
}
