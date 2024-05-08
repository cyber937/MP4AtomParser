//
//  QTMinf.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

// Media Information Box

struct QTMinf: QTAtom, QTAtomProcessAvailable, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .minf
    var atomName: String = "Media Information Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var extDescription: String?
    
    mutating func parseData() {}
}
