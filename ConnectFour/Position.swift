//
//  Position.swift
//  ConnectFour
//
//  Created by Andreas Job on 07.09.24.
//

import Foundation

class Position {
	public let x: Int // x on left is 0
	public let y: Int // y on bottom is 0

	public var column: Int { // column on left is 1
		get {
			return x + 1
		}
	}
	
	public var row: Int { // row on bottom is 1
		get {
			return y + 1
		}
	}

	public init(_ x: Int, _ y: Int) {
		self.x = x
		self.y = y
	}
}
