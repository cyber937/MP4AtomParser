//
//  QTType.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

struct QTFtyp: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var type: QTAtomType = .ftyp
    var location: Range<Int>
    var level: Int = 0
    
    var children = [QTAtom]()
}