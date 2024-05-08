//
//  QElst.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 5/7/24.
//

import Foundation

// Edit List Box

struct QTElst: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .elst
    var atomName: String = "Edit List Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32?
    var entryCount: UInt32?
    var segmentDuration = [UInt32]()
    var mediaTime = [Int32]()
    var mediaRateInteger = [Int16]()
    var mediaRateFraction = [Int16]()
    
    var extDescription: String? {
        
        guard let entryCount else { return nil }
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        let output = """
        \n\(indent)|
        \(indent)| Entry Count - \(entryCount)
        \(indent)| Segment Duration - \(segmentDuration)
        \(indent)| Media Time - \(mediaTime)
        \(indent)| Media Rate Integer - \(mediaRateInteger)
        \(indent)| Media Rate Fraction - \(mediaRateFraction)
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
            
            let offsetEntryCount = i * 4
            
            if version == 1 {
                
            } else {
                let tempSegmentDuration = data[offSet+8+offsetEntryCount..<offSet+12+offsetEntryCount].QTUtilConvert(type: UInt32.self)
                segmentDuration.append(tempSegmentDuration)
                
                let tempMediaTime = data[offSet+12+offsetEntryCount..<offSet+16+offsetEntryCount].QTUtilConvert(type: Int32.self)
                mediaTime.append(tempMediaTime)
            }
            
            let tempMediaRateInteger = data[offSet+16+offsetEntryCount..<offSet+18+offsetEntryCount].QTUtilConvert(type: Int16.self)
            mediaRateInteger.append(tempMediaRateInteger)
            
            let tempMediaRateFraction = data[offSet+18+offsetEntryCount..<offSet+20+offsetEntryCount].QTUtilConvert(type: Int16.self)
            mediaRateFraction.append(tempMediaRateFraction)
        }
    }
    
    mutating func parseData() {}
}
