//
//  QTStsz.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

// Sample Size Boxes

struct QTStsz: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .stsz
    var atomName: String = "Sample Size Boxes"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32 = 0
    var sampleSize: UInt32?
    var sampleCount: UInt32?
    var entrySize = [UInt32]()
    
    var extDescription: String? {
        
        guard let sampleSize, let sampleCount else { return nil }
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        let output = """
        \n\(indent)|
        \(indent)| Sample Size - \(sampleSize)
        \(indent)| Sample Count - \(sampleCount)
        \(indent)| Entry Size - \(entrySize)
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
        
        sampleSize = data[offSet+4..<offSet+8].QTUtilConvert(type: UInt32.self)
        
        sampleCount = data[offSet+8..<offSet+12].QTUtilConvert(type: UInt32.self)
        
        if sampleSize == 0 {
            
            for i in 0..<sampleCount! {
                
                let entrySizeOffset = i * 4
                
                let tempEntrySize = data[offSet+12+Int(entrySizeOffset)..<offSet+16+Int(entrySizeOffset)].QTUtilConvert(type: UInt32.self)
                
                entrySize.append(tempEntrySize)
            }
        }
    }
    
    mutating func parseData() {}
}
