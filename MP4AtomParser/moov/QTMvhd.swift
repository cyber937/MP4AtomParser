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
    var preferredRate: Float?
    var preferredVolume: Float?
    var reserved: Data?
    var matrix: [Float]?
    var predefines: Data?
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
        
        // versionOffset = 0
        
        if version == 1 {
            creationTime = QTUtilUTCConvert(data: data[offSet+4..<offSet+16])
            modificationTime = QTUtilUTCConvert(data: data[offSet+16..<offSet+24])
            
            timeScale = data[offSet+24..<offSet+28]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            duration = data[offSet+28..<offSet+36]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            let preferredRateData = data.subdata(in: offSet+36..<offSet+40)
            preferredRate = QTFixedPointConvert(data: preferredRateData, aboveType: UInt16.self, belowType: UInt16.self)
            
            let preferredVolumeData = data.subdata(in: offSet+40..<offSet+42)
            preferredVolume = QTFixedPointConvert(data: preferredVolumeData, aboveType: UInt16.self, belowType: UInt16.self)
            
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
            
            let preferredRateData = data.subdata(in: offSet+20..<offSet+24)
            preferredRate = QTFixedPointConvert(data: preferredRateData, aboveType: UInt16.self, belowType: UInt16.self)
            
            let preferredVolumeData = data.subdata(in: offSet+24..<offSet+26)
            preferredVolume = QTFixedPointConvert(data: preferredVolumeData, aboveType: UInt8.self, belowType: UInt8.self)
            
            reserved = data[offSet+26..<offSet+36]

            let matrixData = data.subdata(in:offSet+36..<offSet+72)
            matrix = QTMatrixConvert(data: matrixData)
            
            predefines = data[offSet+72..<offSet+96]
            
            nextTrackID = data[offSet+96..<offSet+100]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
        }
            
        print("Creating Time ... \(creationTime!)\nModification Time ... \(modificationTime!)\nTime Scale ... \(timeScale!)\nDuration ... \(duration!)\nRate ... \(preferredRate!)\nVolume ... \(preferredVolume!)\nMatrix ... \(matrix!)\nNext Track ID ... \(nextTrackID!)")
        
        print(offSet+100, location.upperBound)
    }
    
    
    mutating func parseData() {}
}
