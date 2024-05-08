//
//  QTTkhd.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

struct QTTkhd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .tkhd
    var atomName: String = "Track Header Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32 = 0
    var Flags: [UInt8]?
    var creationTime: Date?
    var modificationTime: Date?
    var trackID: UInt32?
    var reservedOne: UInt32?
    var duration: UInt32?
    var reservedTwo: [UInt32]?
    var layer: Int16?
    var alternateGroup: Int16?
    var volume: Float?
    var reservedThree: UInt16?
    var matrix: [Float]?
    var width: Float?
    var height: Float?
    
    var extDescription: String? {
        
        guard let creationTime,
              let modificationTime,
              let trackID,
              let duration,
              let layer,
              let volume,
              let matrix,
              let width,
              let height else { return nil }
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        let output = """
        \n\(indent)|
        \(indent)| Creation Time - \(creationTime)
        \(indent)| Modification Time  - \(modificationTime)
        \(indent)| Track ID - \(trackID)
        \(indent)| Duration - \(duration)
        \(indent)| Layer - \(layer)
        \(indent)| Valume - \(volume)
        \(indent)| Matrix - \(matrix)
        \(indent)| Width - \(width)
        \(indent)| Height - \(height)
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
            
            modificationTime = QTUtilUTCConvert(data: data[offSet+16..<offSet+32])
            
            trackID = data[offSet+32..<offSet+36].QTUtilConvert(type: UInt32.self)
            
            duration = data[offSet+36..<offSet+44].QTUtilConvert(type: UInt32.self)
        } else {
            creationTime = QTUtilUTCConvert(data: data[offSet+4..<offSet+8])
            modificationTime = QTUtilUTCConvert(data: data[offSet+8..<offSet+12])
            
            trackID = data[offSet+12..<offSet+16].QTUtilConvert(type: UInt32.self)
            
            reservedOne = data[offSet+16..<offSet+20].QTUtilConvert(type: UInt32.self)
            
            duration = data[offSet+20..<offSet+24].QTUtilConvert(type: UInt32.self)
            
            reservedTwo = [data[offSet+24..<offSet+28].QTUtilConvert(type: UInt32.self),
                           data[offSet+28..<offSet+32].QTUtilConvert(type: UInt32.self)]
            
            layer = data[offSet+32..<offSet+34].QTUtilConvert(type: Int16.self)
            
            alternateGroup = data[offSet+34..<offSet+36].QTUtilConvert(type: Int16.self)
            
            volume = data[offSet+36..<offSet+38].QTFixedPointConvert(aboveType: UInt8.self, belowType: UInt8.self)
            
            reservedThree = data[offSet+38..<offSet+40].QTUtilConvert(type: UInt16.self)
            
            matrix = data[offSet+40..<offSet+76].QTMatrixConvert()
            
            width = data[offSet+76..<offSet+80].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
            
            height = data[offSet+80..<offSet+84].QTFixedPointConvert(aboveType: UInt16.self, belowType: UInt16.self)
        }
    }
    
    mutating func parseData() {}
}
