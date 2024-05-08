//
//  QTSmhd.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

// Sound Media Header Box

struct QTSmhd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .smhd
    var atomName: String = "Sound Media Header Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var extDescription: String?
    
    mutating func parseData() {}
}
