//
//  QTDinf.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

struct QTDinf: QTAtom, QTAtomProcessAvailable, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .dinf
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

struct QTDref: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .dinf
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}
