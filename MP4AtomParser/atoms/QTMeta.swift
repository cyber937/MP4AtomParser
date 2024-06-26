//
//  QTMeta.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 5/3/24.
//

import Foundation

// Meta Box

struct QTMeta: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .meta
    var atomName: String = "Meta Box"
    var location: Range<Int>
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var extDescription: String?
    
    mutating func parseData() {}
}
