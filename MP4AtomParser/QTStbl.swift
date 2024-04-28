//
//  QTStbl.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

struct QTStbl: QTAtom, QTAtomProcessAvailable, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .stbl
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

struct QTStsd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .stsd
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

struct QTStts: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .stts
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

struct QTStsc: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .stsc
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

struct QTStsz: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .stsz
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

struct QTStco: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .stco
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}
