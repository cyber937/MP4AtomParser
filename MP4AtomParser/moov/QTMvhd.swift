//
//  QTMvhd.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

// 'mvhd' - Movie Header
struct QTMvhd: QTAtom, CustomStringConvertible{
    var data: Data
    var size: UInt32
    var extSize: UInt64?
    var name: String = "Movie Header"
    var type: QTAtomType = .mvhd
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32 = 0
    var Flags: [UInt8]?
    var creationTime: Date?
    var modificationTime: Date?
    var timeScale: UInt32?
    var duration: UInt32?
    var preferredRate: Float32?
    var preferredVolume: Int16?
    var reserved: UInt8?
    var matrix: [UInt32]?
    var predefines: [UInt8]?
    var nextTrackID: UInt32?
    
    init(data: Data, size: UInt32, extSize: UInt64?, location: Range<Int>) {
        self.data = data
        self.size = size
        self.extSize = extSize
        self.location = location
        
        // Offset value the data's started value + size value (32 bit) + type value (32 bit)
        let offSet = location.lowerBound+8
        
        // Extract minot version as Int
        version = data[offSet..<offSet+4]
            .reduce(0, { soFar, new in
                (soFar << 8) | UInt32(new)
            })
        
        if version == 1 {
            
        } else {
            creationTime = QTUtilUTCConvert(data: data[offSet+4..<offSet+8])
            modificationTime = QTUtilUTCConvert(data: data[offSet+8..<offSet+12])
            
            timeScale = data[offSet+12..<offSet+16]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            duration = data[offSet+16..<offSet+20]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
//            preferredRate = data[offSet+20..<offSet+24].withUnsafeBytes {
//                $0.load(fromByteOffset: 0, as: Float32.self)
//            }
            
//            preferredRate = data[offSet+20..<offSet+24]
//                .reduce(0, { soFar, new in
//                    (soFar << 8) | Int32(new)
//                })
            
//            preferredVolume = data[offSet+24..<offSet+28]
//                .reduce(0, { soFar, new in
//                    (soFar << 8) | Int16(new)
//                })
            
            print("Creating Time ... \(creationTime!)\nModification Time ... \(modificationTime!)\nTime Scale ... \(timeScale!)\nDuration ... \(duration!)")//\nPreferred Rate ... \(preferredRate!)")//\nPreferred Volume ... \(preferredVolume!)\n")
        }
    }
    
    
    mutating func parseData() {}
}
