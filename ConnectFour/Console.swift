//
//  Console.swift
//  ConnectFour
//
//  Created by Andreas Job on 31.08.24.
//

import Foundation

/**
  * Utility methods to output text to the console
 */
class Console {
	
	private init() {
		// empty
	}

	public static func clear() {
		Swift.print("\u{001B}[2J")
	}

	public static func println() {
		Swift.print()
	}
	
	public static func println(_ text: String) {
		Swift.print(text)
	}
	
	public static func print(_ text: String) {
		Swift.print(text, terminator: "")
	}
}
