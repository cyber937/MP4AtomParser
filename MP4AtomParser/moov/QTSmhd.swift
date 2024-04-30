//
//  QTSmhd.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

struct QTSmhd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var extSize: UInt64?
    var type: QTAtomType = .smhd
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
    
    mutating func parseData() {}
}
