import Algorithms

struct Almanac {
  struct Item {
    let start: Int
    let end: Int
    let diff: Int
  }

  var seedToSoil: [Item]
  var soilToFer: [Item]
  var ferToWater: [Item]
  var waterToLight: [Item]
  var lightToTemp: [Item]
  var tempToHumid: [Item]
  var humidToLoc: [Item]
  var seeds: [Int]

  init(input: [String]) {
    self.seedToSoil = []
    self.soilToFer = []
    self.ferToWater = []
    self.waterToLight = []
    self.lightToTemp = []
    self.tempToHumid = []
    self.humidToLoc = []
    self.seeds = input[0].split(separator: " ").compactMap { Int($0) }

    var storage: [Item] = []

    let process: ([Item]) -> [Item] = { items in items.sorted { $0.start < $1.start } }
    for idx in 1..<input.count {
      let line = input[idx]
      guard line.count != 0 else { continue }

      if line == "seed-to-soil map:" {
        continue
      } else if line == "soil-to-fertilizer map:" {
        self.seedToSoil = process(storage) 
        storage = []
      } else if line == "fertilizer-to-water map:" {
        self.soilToFer = process(storage)
        storage = []
      } else if line == "water-to-light map:" {
        self.ferToWater = process(storage)
        storage = []
       } else if line == "light-to-temperature map:" {
         self.waterToLight = process(storage)
         storage = []
       } else if line == "temperature-to-humidity map:" {
         self.lightToTemp = process(storage)
         storage = []
       } else if line == "humidity-to-location map:" {
         self.tempToHumid = process(storage)
         storage = []
       } else {
         let numbers = line.split(separator: " ").compactMap { Int($0) }
         storage.append(
           Item(
             start: numbers[1],
             end: numbers[1] + numbers[2] - 1,
             diff: numbers[1] - numbers[0]
           )
         )
       }
     }
     self.humidToLoc = process(storage)
   }
}

extension Almanac {
  func findLocation(for seed: Int) -> Int {
    let soil = find(seed, in: seedToSoil)
    let fer = find(soil, in: soilToFer)
    let water = find(fer, in: ferToWater)
    let light = find(water, in: waterToLight)
    let temp = find(light, in: lightToTemp)
    let humid = find(temp, in: tempToHumid)
    let loc = find(humid, in: humidToLoc)
    return loc
  }

  func find(_ val: Int, in record: [Item]) -> Int {
    for item in record {
      if val >= item.start && val <= item.end {
        return val - item.diff
      }
    }
    return val
  }

  func findLocationRange(_ start: Int, _ end: Int) -> Int {
    let soil  = findRange(start, end, in: seedToSoil)
    let fer = findRange(soil.0, soil.1, in: soilToFer)
    let water = findRange(fer.0, fer.1, in: ferToWater)
    let light = findRange(water.0, water.1, in: waterToLight)
    let temp = findRange(light.0, light.1, in: lightToTemp)
    let humid = findRange(temp.0, light.1, in: tempToHumid)
    let loc = findRange(humid.0, humid.1, in: humidToLoc)
    return loc.0
  }

  func findRange(_ start: Int, _ end: Int, in record: [Item]) -> (Int, Int) {
    return (0,0)
  }
}

struct Day05: AdventDay {
  var data: String

  var entities: [String] {
    data.split(separator: "\n").map { String($0) }
  }

  func part1() -> Any {
    let almanac = Almanac(input: entities)
    var answer = almanac.humidToLoc.last?.end ?? 0
    for seed in almanac.seeds {
      let location = almanac.findLocation(for: seed)
      answer = min(answer, location)
    }
    return answer 
  }

  func part2() -> Any {
    let almanac = Almanac(input: entities)
    var answer = almanac.humidToLoc.last?.end ?? 0
    for idx in almanac.seeds.indices {
      guard idx % 2 == 0 else { continue }
      let start = almanac.seeds[idx]
      let end = almanac.seeds[idx] + almanac.seeds[idx+1]
      let location = almanac.findLocationRange(start, end)
      print(location)
      answer = min(answer, location)
    }
    return answer
  }
}
