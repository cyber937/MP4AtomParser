//
//  QTTrak.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

struct QTTrak: QTAtom, QTAtomProcessAvailable, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .trak
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

struct QTTkhd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .tkhd
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}
