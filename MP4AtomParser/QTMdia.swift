//
//  QTMdia.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

struct QTMdia: QTAtom, QTAtomProcessAvailable, CustomStringConvertible {
    var level: Int = 0
    
    var data: Data
    var size: UInt32
    var type: QTAtomType = .mdia
    var location: Range<Int>
    
    var children = [QTAtom]()
}

struct QTMdhd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .mdhd
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

struct QTHdlr: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .hdlr
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}
