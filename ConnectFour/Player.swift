//
//  Player.swift
//  ConnectFour
//
//  Created by Andreas Job on 31.08.24.
//

import Foundation

/**
 * the player instance
 */
class Player {
	public let name: String
	public let human: Bool
	public let color: Stone

	public init(name: String, human: Bool, color: Stone) {
		self.name = name
		self.human = human
		self.color = color
	}
}

class HumanPlayer : Player {
	public init(name: String, color: Stone) {
		super.init(name: name, human: true, color: color)
	}
}

class CpuPlayer : Player {
	public init(name: String, color: Stone) {
		super.init(name: name, human: false, color: color)
	}

	public func findBestNextMove(playfield: PlayField) -> Int? {
		var maxScoreColumn = (Int.min, -1)
		for column in (0..<playfield.sizex).shuffled() {
			do {
				let score = try playfield.calcScoreForMove(add: color, putIn: column, maxDepth: 5)
				if (score > maxScoreColumn.0) {
					maxScoreColumn.0 = score
					maxScoreColumn.1 = column
				}
				//Console.println("Score for column \(column): \(score)")
				if (score > 100000) { // found a very good column -> skip any further searches
					break
				}
			} catch {
				// cannot add a stone in column
			}
		}
		if (maxScoreColumn.1 > -1) {
			return maxScoreColumn.1
		}

		// if cannot find a score, return a random, non-full column
		for randomColumn in (0..<playfield.sizex).shuffled() {
			if (!playfield.isColumnFull(x: randomColumn)) {
				return randomColumn
			}
		}
		// cannot find any non-full column -> return nil
		return nil;
	}

}
