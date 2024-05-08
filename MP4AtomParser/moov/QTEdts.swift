//
//  QTEdts.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 5/7/24.
//

import Foundation

// Edit Box

struct QTEdts: QTAtom, QTAtomProcessAvailable, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .edts
    var atomName: String = "Edit Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var extDescription: String?
    
    mutating func parseData() {}
}
