//
//  QTMinf.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

struct QTMinf: QTAtom, QTAtomProcessAvailable, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .minf
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

struct QTSmhd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .smhd
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}
