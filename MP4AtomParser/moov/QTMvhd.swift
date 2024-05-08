//
//  QTMvhd.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

// Movie Header Box

struct QTMvhd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .mvhd
    var atomName: String = "Movie Header Box"
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
    
    var extDescription: String? {
        
        guard let creationTime,
              let modificationTime,
              let timeScale,
              let duration,
              let preferredRate,
              let preferredVolume,
              let matrix,
              let nextTrackID else { return nil }
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        let output = """
        \n\(indent)|
        \(indent)| Creation Time - \(creationTime)
        \(indent)| Modification Time  - \(modificationTime)
        \(indent)| Time Scale - \(timeScale)
        \(indent)| Duration - \(duration)
        \(indent)| Preferred Rate - \(preferredRate)
        \(indent)| Preferred Valume - \(preferredVolume)
        \(indent)| Matrix - \(matrix)
        \(indent)| Next Track ID - \(nextTrackID)
        """
        
        return output
    }
    
    init(data: Data, size: UInt32, extSize: UInt64?, location: Range<Int>) {
        self.data = data
        self.size = size
        self.extSize = extSize
        self.location = location
        
        // Offset value the data's started value + size value (32 bit) + type value (32 bit)
        let offSet = location.lowerBound+8
        
        // Extract minot version as Int
        version = data[offSet..<offSet+4].QTUtilConvert(type: UInt32.self)
        
        if version == 1 {
            creationTime = QTUtilUTCConvert(data: data[offSet+4..<offSet+16])
            
            modificationTime = QTUtilUTCConvert(data: data[offSet+16..<offSet+24])
            
            timeScale = data[offSet+24..<offSet+28].QTUtilConvert(type: UInt32.self)
            
            duration = data[offSet+28..<offSet+36].QTUtilConvert(type: UInt32.self)
            
            preferredRate = data[offSet+36..<offSet+40].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
            
            preferredVolume = data[offSet+40..<offSet+42].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
            
        } else {
            creationTime = QTUtilUTCConvert(data: data[offSet+4..<offSet+8])
            
            modificationTime = QTUtilUTCConvert(data: data[offSet+8..<offSet+12])
            
            timeScale = data[offSet+12..<offSet+16].QTUtilConvert(type: UInt32.self)
            
            duration = data[offSet+16..<offSet+20].QTUtilConvert(type: UInt32.self)
            
            preferredRate = data[offSet+20..<offSet+24].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
            
            preferredVolume = data[offSet+24..<offSet+26].QTFixedPointConvert(aboveType: UInt8.self, belowType: UInt8.self)
            
            reserved = data[offSet+26..<offSet+36]
            
            matrix = data[offSet+36..<offSet+72].QTMatrixConvert()
            
            predefines = data[offSet+72..<offSet+96]
            
            nextTrackID = data[offSet+96..<offSet+100].QTUtilConvert(type: UInt32.self)
            
        }
    }
    
    mutating func parseData() {}
}
