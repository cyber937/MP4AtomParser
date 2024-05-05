//
//  QTStss.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 5/5/24.
//

import Foundation

// Sync Sample Box

struct QTStss: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var extSize: UInt64?
    var type: QTAtomType = .stco
    var location: Range<Int>
    
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32 = 0
    var entryCount: UInt32?
    var sampleNumber = [UInt32]()
    
    var extDescription: String? {
        
        guard let entryCount else { return nil }
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        let output = """
        \n\(indent)|
        \(indent)| Entry Count - \(entryCount)
        \(indent)| Sample Number - \(sampleNumber)
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
        
        entryCount = data[offSet+4..<offSet+8].QTUtilConvert(type: UInt32.self)
        
        for i in 0..<Int(entryCount!) {
            
            let sampleNumberOffset = i * 4
            
            let tempSampleNumber = data[offSet+8+sampleNumberOffset..<offSet+12+sampleNumberOffset].QTUtilConvert(type: UInt32.self)
            sampleNumber.append(tempSampleNumber)
            
        }
    }
    
    mutating func parseData() {}
}

