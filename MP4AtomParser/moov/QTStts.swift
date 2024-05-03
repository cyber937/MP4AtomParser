//
//  QTStts.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

// Dacoding Time

struct QTStts: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var extSize: UInt64?
    var type: QTAtomType = .stts
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var entryCount: UInt32?
    var sampleCount: UInt32?
    var sampleDelta: UInt32?
    
    var extDescription: String?
    
    mutating func parseData() {}
}
