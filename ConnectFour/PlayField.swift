//
//  PlayField.swift
//  ConnectFour
//
//  Created by Andreas Job on 29.08.24.
//

import Foundation

/**
 * Stone or chip which is dropped into the playfield grid
 */
public enum Stone: Int, CustomStringConvertible {
	case none = 0, red = -1, blue = 1

	public var description : String {
		switch self {
		case .none: return " .  "
		case .red: return "red "
		case .blue: return "blue"
		}
	}
}

public enum PlayFieldError: Error {
	case columnFull(Int), columnEmpty(Int), playFieldFull;

	var errorDescription: String? {
		switch self {
		case .columnFull(let col): return "Column \(col) is already full."
		case .columnEmpty(let col): return "Column \(col) is empty."
		case .playFieldFull: return "The playfield is already full."
		}
	}
}

/**
 * The playfield (or game board) in which the players drop the stones
 */
class PlayField {
	public let sizex: Int
	public let sizey: Int
	public var data: [[Stone]]

	public init(sizex: Int, sizey: Int) {
		self.sizex = sizex
		self.sizey = sizey
		self.data = Array(repeating: Array(repeating: Stone.none, count: sizey), count: sizex)
	}

	public init(data: [[Stone]]) {
		self.sizex = data.count
		self.sizey = data[0].count
		self.data = data
	}

	public func getAt(x: Int, y: Int) -> Stone {
		return data[x][y]
	}

	public func setAt(x: Int, y: Int, val: Stone) {
		data[x][y] = val
	}

	public func print() {
		for y in (0..<sizey).reversed() {
			for x in 0..<sizex {
				Console.print("\(data[x][y]) ")
			}
			Console.println() // new line
		}
	}

	public func isColumnFull(x: Int) -> Bool {
		return data[x][sizey - 1] != .none
	}

	public func isColumnEmpty(x: Int) -> Bool {
		return data[x][0] == .none
	}

	public func isPlayFieldFull() -> Bool {
		for x in 0..<sizex {
			if (!isColumnFull(x: x)) {
				return false
			}
		}
		return true
	}

	public func addStone(x: Int, stone: Stone) throws {
		if (stone == .none) {
			return
		}
		if (isColumnFull(x: x)) {
			throw PlayFieldError.columnFull(x)
		}
		// fill playfied with stones from bottom to top
		for y in 0..<sizey {
			if (data[x][y] == .none) { // can add in this row if it's empty
				data[x][y] = stone
				return
			}
		}
		throw PlayFieldError.columnFull(x)
	}
	
	public func removeStone(x: Int) throws {
		if (isColumnEmpty(x: x)) {
			//Console.println("Cannot remove stone from \(x). Column is already empty")
			throw PlayFieldError.columnEmpty(x)
		}
		// fill playfied with stones from bottom to top
		for y in (0..<sizey).reversed() {
			if (data[x][y] != .none) { // can add in this row if it's empty
				data[x][y] = .none
				return
			}
		}
	}

	/*public func testAddStone(x: Int, stone: Stone, into playField: [[Stone]]) throws -> [[Stone]] {
		if (isColumnFull(x: x)) {
			throw PlayFieldError.columnFull(x)
		}
		
		var playFieldCopy = playField

		if (stone == .none) {
			return playFieldCopy
		}

		// fill playfied with stones from bottom to top
		for y in 0..<sizey {
			if (playFieldCopy[x][y] == .none) { // can add in this row if it's empty
				playFieldCopy[x][y] = stone
				return playFieldCopy
			}
		}
		throw PlayFieldError.columnFull(x)
	}*/

	public func hasConnectedFour() -> Bool {
		return findConnectedFour() != nil
	}

	public func findConnectedFour() -> [Position]? {
		var positions = hasHorizontalConnectedFour()
		if (positions != nil) {
			return positions
		}

		positions = hasVerticalConnectedFour()
		if (positions != nil) {
			return positions
		}

		return hasDiagonalConnectedFour()
	}

	private func hasHorizontalConnectedFour() -> [Position]? {
		for y in 0..<sizey {
			for x in 0..<(sizex - 3) {
				let first: Stone = data[x][y]
				if (first == .none) {
					continue
				}
				let second = data[x + 1][y]
				let third  = data[x + 2][y]
				let fourth = data[x + 3][y]
				if (second == first && third == first && fourth == first) {
					let positions: [Position] = [Position(x, y),
												 Position(x + 1, y),
												 Position(x + 2, y),
												 Position(x + 3, y)]
					return positions
				}
				/*var positions: [Position] = [Position(x, y)]
				var i = 1
				repeat {
					let position = Position(x + i, y)
					let stone = data[position.x][position.y]
					if (stone == .none || stone != first) {
						break
					}
					positions.append(position)
					i += 1
				} while (i < 4)
				if (i == 4) {
					return positions
				}*/
			}
		}
		return nil
	}

	private func hasVerticalConnectedFour() -> [Position]? {
		for y in 0..<sizey - 3 {
			for x in 0..<sizex {
				let first: Stone = data[x][y]
				if (first == .none) {
					continue
				}
				let second = data[x][y + 1]
				let third  = data[x][y + 2]
				let fourth = data[x][y + 3]
				if (second == first && third == first && fourth == first) {
					let positions: [Position] = [Position(x, y),
												 Position(x, y + 1),
												 Position(x, y + 2),
												 Position(x, y + 3)]
					return positions
				}
				/*var positions: [Position] = [Position(x, y)]
				var i = 1
				repeat {
					let position = Position(x, y + i)
					let stone = data[position.x][position.y]
					if (stone == .none || stone != first) {
						break
					}
					positions.append(position)
					i += 1
				} while (i < 4)
				if (i == 4) {
					return positions
				}*/
			}
		}
		return nil
	}

	private func hasDiagonalConnectedFour() -> [Position]? {
		// diagonal up
		for y in 0..<sizey - 3 {
			for x in 0..<sizex - 3 {
				let first: Stone = data[x][y]
				if (first == .none) {
					continue
				}
				let second = data[x + 1][y + 1]
				let third  = data[x + 2][y + 2]
				let fourth = data[x + 3][y + 3]
				if (second == first && third == first && fourth == first) {
					let positions: [Position] = [Position(x, y),
												 Position(x + 1, y + 1),
												 Position(x + 2, y + 2),
												 Position(x + 3, y + 3)]
					return positions
				}
				/*var positions: [Position] = [Position(x, y)]
				var i = 1
				repeat {
					let position = Position(x + i, y + i)
					let stone = data[position.x][position.y]
					if (stone == .none || stone != first) {
						break
					}
					positions.append(position)
					i += 1
				} while (i < 4)
				if (i == 4) {
					return positions
				}*/
			}
		}

		// diagonal down
		for y in 3..<sizey {
			for x in 0..<sizex - 3 {
				let first: Stone = data[x][y]
				if (first == .none) {
					continue
				}
				let second = data[x + 1][y - 1]
				let third  = data[x + 2][y - 2]
				let fourth = data[x + 3][y - 3]
				if (second == first && third == first && fourth == first) {
					let positions: [Position] = [Position(x, y),
												 Position(x + 1, y - 1),
												 Position(x + 2, y - 2),
												 Position(x + 3, y - 3)]
					return positions
				}
				/*var positions: [Position] = [Position(x, y)]
				var i = 1
				repeat {
					let position = Position(x + i, y - i)
					let stone = data[position.x][position.y]
					if (stone == .none || stone != first) {
						break
					}
					positions.append(position)
					i += 1
				} while (i < 4)
				if (i == 4) {
					return positions
				}*/
			}
		}
		return nil
	}

	func calcScoreForMove(add color: Stone, putIn column: Int, maxDepth: Int = Int.max) throws -> Int {
		let playfieldCopy = PlayField(data: data)
		return try playfieldCopy.calcScoreForMove(add: color, putIn: column, maxDepth: maxDepth, wantedColor: color)
	}

	private func calcScoreForMove(add color: Stone, putIn column: Int, maxDepth: Int = Int.max, depth: Int = 0, wantedColor: Stone) throws -> Int {
		try addStone(x: column, stone: color)
		defer {
			do {
				try removeStone(x: column)
			} catch {
				Console.println("Cannot remove stone from \(column). Column is already empty")
			}
		}

		let connectedFour = findConnectedFour()
		// if has 4 connected stones -> return score
		if let connectedFour = connectedFour {
			let positionFirstStone = connectedFour[0]
			let stoneColor = getAt(x: positionFirstStone.x, y: positionFirstStone.y)

			if (depth == 0) {
				return stoneColor == wantedColor ? Int.max : -1;
			} else if (depth == 1) {
				return stoneColor != wantedColor ? -100 : 1;
			} else {
				//if (stoneColor == wantedColor) {
				//	Console.println("found solution (last stone put in \(column):")
				//	print()
				//}
				return stoneColor == wantedColor ? 1 : -1;
			}
		}

		// no 4 connected stones -> try next move
		if (depth >= maxDepth) {
			return 0
		}
		var totalScore = 0
		for i in (0..<sizex).shuffled() {
			let nextColor = color == Stone.blue ? Stone.red : Stone.blue
			do {
				let score = try calcScoreForMove(add: nextColor, putIn: i, maxDepth: maxDepth, depth: depth + 1, wantedColor: wantedColor)
				totalScore += score
			} catch {
				// cannot add a stone in column i
				//Console.println(" Error: \(error)")
			}
		}
		//if (totalScore != 0){
		//	Console.println(" Returning: \(totalScore)")
		//}

		return totalScore;
	}
}
