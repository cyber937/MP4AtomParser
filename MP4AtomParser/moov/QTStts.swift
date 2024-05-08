//
//  QTStts.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

// Dacoding Time to Sample Box

struct QTStts: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .stts
    var atomName: String = "Dacoding Time to Sample Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32 = 0
    var entryCount: UInt32?
    var sampleCount = [UInt32]()
    var sampleDelta = [UInt32]()
    
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
        \(indent)| Sample Delta - \(sampleDelta)
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
            
            let sampleOffset = i * 8
            
            let tempSampleCount = data[offSet+8+sampleOffset..<offSet+12+sampleOffset].QTUtilConvert(type: UInt32.self)
            sampleCount.append(tempSampleCount)
            
            let tempSampleDelta = data[offSet+12+sampleOffset..<offSet+16+sampleOffset].QTUtilConvert(type: UInt32.self)
            sampleDelta.append(tempSampleDelta)
        }
    }
    
    mutating func parseData() {}
}
