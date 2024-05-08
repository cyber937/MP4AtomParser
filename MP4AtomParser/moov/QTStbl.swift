//
//  QTStbl.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

// Sample Table Box

struct QTStbl: QTAtom, QTAtomProcessAvailable, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .stbl
    var atomName: String = "Sample Table Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var extDescription: String?
    
    mutating func parseData() {}
}
