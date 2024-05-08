//
//  QTStsc.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

// Sample To Chunk Box

struct QTStsc: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .stsc
    var atomName: String = "Sample To Chunk Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32 = 0
    var entryCount: UInt32?
    var firstChunk = [UInt32]()
    var samplePerChunk = [UInt32]()
    var sampleDescriptionIndex = [UInt32]()
    
    var extDescription: String? {
        
        guard let entryCount else { return nil }
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        let output = """
        \n\(indent)|
        \(indent)| Entry Count - \(entryCount)
        \(indent)| First Chunk - \(firstChunk)
        \(indent)| Sample Per Chunk - \(samplePerChunk)
        \(indent)| Sample Description Index - \(sampleDescriptionIndex)
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
            
            let sampleOffset = i * 12
            
            let tempFirstChunk = data[offSet+8+sampleOffset..<offSet+12+sampleOffset].QTUtilConvert(type: UInt32.self)
            firstChunk.append(tempFirstChunk)
            
            let tempSamplePerChunk = data[offSet+12+sampleOffset..<offSet+16+sampleOffset].QTUtilConvert(type: UInt32.self)
            samplePerChunk.append(tempSamplePerChunk)
            
            let tempSampleDescriptionIndex = data[offSet+16+sampleOffset..<offSet+20+sampleOffset].QTUtilConvert(type: UInt32.self)
            sampleDescriptionIndex.append(tempSampleDescriptionIndex)
        }
    }
    
    mutating func parseData() {}
}
