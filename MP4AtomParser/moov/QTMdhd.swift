//
//  QTMdhd.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

struct QTMdhd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var extSize: UInt64?
    var type: QTAtomType = .mdhd
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32 = 0
    var Flags: [UInt8]?
    var creationTime: Date?
    var modificationTime: Date?
    var timeScale: UInt32?
    var duration: UInt32?
    var language = [String]()
    
    var extDescription: String? {
        
        guard let creationTime,
              let modificationTime,
              let timeScale,
              let duration else { return nil }
        
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
        \(indent)| Language - \(language)
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
        } else {
            creationTime = QTUtilUTCConvert(data: data[offSet+4..<offSet+8])
            
            modificationTime = QTUtilUTCConvert(data: data[offSet+8..<offSet+12])
            
            timeScale = data[offSet+12..<offSet+16].QTUtilConvert(type: UInt32.self)
            
            duration = data[offSet+16..<offSet+20].QTUtilConvert(type: UInt32.self)
        }
    }
    
    mutating func parseData() {}
}
