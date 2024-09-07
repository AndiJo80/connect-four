//
//  main.swift
//  ConnectFour
//
//  Created by Andreas Job on 29.08.24.
//

import Foundation

Console.println("Welcome to Connect Four")
Console.println()

/*let data: [[Stone]] = [[.blue, .none, .none, .none, .none, .none ],
					   [.blue, .red,  .blue, .none, .none, .none ],
					   [.red, . blue, .red,  .blue, .none, .none ],
					   [.blue, .blue, .red,  .red,  .red, .blue ],
					   [.red,  .blue, .red,  .red,  .red, .none ],
					   [.none, .none, .none, .none, .none, .none ],
					   [.blue, .none, .none, .none, .none, .none ]
]
let testPlayField = PlayField(data: data)
testPlayField.print()
let hasFour = testPlayField.hasConnectedFour()*/

var players: [Player] = []
for i in 1...2 {
	var input: String? = nil
	var inputvalid = false
	repeat {
		Console.print("Player \(i) is human? (y/n/q): ")
		input = readLine()
		if (input == "q") { exit(0); } // quit
		inputvalid = input == "y" || input == "n"
		if (!inputvalid) {
			Console.println("invalid input")
		}
	} while (!inputvalid)
	let human = input == "y"
	let color: Stone // = (i == 1) ? Stone.blue : Stone.red
	if (i == 1) {
		color = Stone.blue
	} else if (i == 2) {
		color = Stone.red
	} else {
		Console.println("Only 2 players allowed")
		break;
	}

	let player: Player = human ? HumanPlayer(name: "\(i)", color: color) : CpuPlayer(name: "\(i)", color: color)
	players.append(player)
}

// size of playfield
let playFieldColumns = 7
let playFieldRows = 6
let playField = PlayField(sizex: playFieldColumns, sizey: playFieldRows)
var quit = false
var hasFourInARow = false
var currentPlayerIdx = 1
repeat {
	currentPlayerIdx = (currentPlayerIdx + 1) % 2

	// print playfield
	Console.clear()
	playField.print()
	Console.println() // empty line

	let currentPlayer = players[currentPlayerIdx]
	Console.println("Turn of player \(currentPlayer.name)")
	if (currentPlayer.human) {
		var played = false
		repeat {
			Console.print("Your choice (1-\(playFieldColumns),q)")
			let input = readLine() ?? ""
			quit = input == "q"
			if (quit) {
				continue
			}

			let inputColumn = Int(input, radix: 10) ?? 0
			if (1...playFieldColumns).contains(inputColumn) {
				do {
					try playField.addStone(x: inputColumn - 1, stone: currentPlayer.color)
					played = true
				} catch PlayFieldError.columnFull(let column) {
					Console.println("Column \(column) is already full. Choose a different column.")
				}
			}
		} while (!played && !quit)
		if (quit) {
			continue
		}
	} else if let cpuPlayer = currentPlayer as? CpuPlayer {
		let x = cpuPlayer.findBestNextMove(playfield: playField)
		if let x = x {
			Console.println("Computer player \(cpuPlayer.name) put stone in column \(x + 1)")
			try! playField.addStone(x: x, stone: cpuPlayer.color)
		} else {
			Console.println("Computer player \(cpuPlayer.name) cannot find any free column to add a stone")
		}
		Thread.sleep(forTimeInterval: 3)
	}
} while (!quit && !playField.hasConnectedFour() && !playField.isPlayFieldFull())

if (playField.hasConnectedFour()) {
	Console.clear()
	playField.print()
	Console.println() // empty line

	let currentPlayer = players[currentPlayerIdx]
	Console.println("Player \(currentPlayer.name) has won.")
} else if (playField.isPlayFieldFull()) {
	Console.clear()
	playField.print()
	Console.println() // empty line
	Console.println("No empty space left. Game ends with a draw.")
}

Console.println() // empty line
Console.println("Goodbye")
/*
playField.setAt(x: 0, y: 0, val: .blue)
playField.setAt(x: 3, y: 0, val: .blue)
playField.setAt(x: 0, y: 2, val: .red)

var testPlayFieldData = try? playField.testAddStone(x: 1, stone: .red, into: playField.playField)
if let pfData = testPlayFieldData {
	testPlayFieldData = try? playField.testAddStone(x: 1, stone: .red, into: pfData)
}
if let pfData = testPlayFieldData {
	testPlayFieldData = try? playField.testAddStone(x: 1, stone: .red, into: pfData)
}
if let pfData = testPlayFieldData {
	PlayField(sizex: playField.sizex, sizey: playField.sizey, playField: pfData).print()
}
print() // empty line

try? playField.addStone(x: 4, stone: .blue)
try? playField.addStone(x: 4, stone: .red)
try? playField.addStone(x: 4, stone: .blue)

playField.print()
*/
