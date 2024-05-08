//
//  QTCtts.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 5/5/24.
//

import Foundation

// Composition Time to Sample Box

struct QTCtts: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .ctts
    var atomName: String = "Composition Time to Sample Box"
    var location: Range<Int>
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32 = 0
    var entryCount: UInt32?
    var sampleCount = [UInt32]()
    var sampleOffset = [UInt32]()
    
    var extDescription: String? {
        
        guard let entryCount else { return nil }
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        let output = """
        \n\(indent)|
        \(indent)| Entry Count - \(entryCount)
        \(indent)| Sample Count - \(sampleCount)
        \(indent)| Sample Offset - \(sampleOffset)
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
            
            let offsetInEntry = i * 8
            
            let tempSampleCount = data[offSet+8+offsetInEntry..<offSet+12+offsetInEntry].QTUtilConvert(type: UInt32.self)
            sampleCount.append(tempSampleCount)
            
            let tempSampleOffset = data[offSet+12+offsetInEntry..<offSet+16+offsetInEntry].QTUtilConvert(type: UInt32.self)
            sampleOffset.append(tempSampleOffset)
        }
    }
    
    mutating func parseData() {}
}

