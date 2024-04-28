//
//  QAnvhd.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

struct QTMoov: QTAtom, QTAtomProcessAvailable, CustomStringConvertible {
    let data: Data
    let size: UInt32
    let type: QTAtomType = .moov
    let location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
}

// 'mvhd' - Movie Header
struct QTMvhd: QTAtom, CustomStringConvertible{
    var data: Data
    var size: UInt32
    var name: String = "Movie Header"
    var type: QTAtomType = .mvhd
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt8?
    var Flags: [UInt8]?
    var creationTime: UInt32?
    var modificationTime: UInt32?
    var timeScale: UInt32?
    var duration: UInt32?
    var preferredRate: UInt32?
    var preferredVolume: UInt32?
    var reserved: UInt8?
    var matrix: [UInt32]?
    var predefines: [UInt8]?
    var nextTrackID: UInt32?
    
}
