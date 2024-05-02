//
//  QTTkhd.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

struct QTTkhd: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32
    var extSize: UInt64?
    var type: QTAtomType = .tkhd
    var location: Range<Int>
    
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
        
        if version == 1 {
            creationTime = QTUtilUTCConvert(data: data[offSet+4..<offSet+16])
            
            modificationTime = QTUtilUTCConvert(data: data[offSet+16..<offSet+32])
            
            trackID = data[offSet+32..<offSet+36]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            duration = data[offSet+36..<offSet+44]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
        } else {
            creationTime = QTUtilUTCConvert(data: data[offSet+4..<offSet+8])
            modificationTime = QTUtilUTCConvert(data: data[offSet+8..<offSet+12])
            
            trackID = data[offSet+12..<offSet+16]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            reservedOne = data[offSet+16..<offSet+20]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            duration = data[offSet+20..<offSet+24]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            reservedTwo = [data[offSet+24..<offSet+28]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                }),
                           data[offSet+28..<offSet+32]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })]
            
            layer = data[offSet+32..<offSet+34]
                .reduce(0, { soFar, new in
                    (soFar << 8) | Int16(new)
                })
            
            alternateGroup = data[offSet+34..<offSet+36]
                .reduce(0, { soFar, new in
                    (soFar << 8) | Int16(new)
                })
            
            let volumeData = data.subdata(in: offSet+36..<offSet+38)
            volume = QTFixedPointConvert(data: volumeData, aboveType: UInt8.self, belowType: UInt8.self)
            
            reservedThree = data[offSet+38..<offSet+40]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt16(new)
                })
            
            let matrixData = data.subdata(in:offSet+40..<offSet+76)
            matrix = QTMatrixConvert(data: matrixData)
            
            let widthData = data.subdata(in: offSet+76..<offSet+80)
            width = QTFixedPointConvert(data: widthData, aboveType: UInt16.self, belowType: UInt16.self)
            
            let heightData = data.subdata(in: offSet+80..<offSet+84)
            height = QTFixedPointConvert(data: heightData, aboveType: UInt16.self, belowType: UInt16.self)
            //reserved = data[offSet+26..<offSet+36]
            
            //matrix = [data[offSet+36..<offSet+40], data[offSet+40..<offSet+44], data[offSet+44..<offSet+48],
            //          data[offSet+48..<offSet+52], data[offSet+52..<offSet+56], data[offSet+56..<offSet+60],
            //          data[offSet+60..<offSet+64], data[offSet+64..<offSet+68], data[offSet+68..<offSet+72]
            //]
            
            //predefines = data[offSet+72..<offSet+96]
            
            //nextTrackID = data[offSet+96..<offSet+100]
            //    .reduce(0, { soFar, new in
            //        (soFar << 8) | UInt32(new)
            //    })
        }
        
        print("Creating Time ... \(creationTime!)\nModification Time ... \(modificationTime!)\nTrack ID ... \(trackID!)\nDuration ... \(duration!)\nLayer ... \(layer!)\nVolume ... \(volume!)\nMatrix ... \(matrix!)\nWidth ... \(width!)\nHeight ... \(height!)")//nRate ... \(preferredRate!)\nVolume ... \(preferredVolume!)\nMatrix ... \(matrix!)\nNext Track ID ... \(nextTrackID!)")
        
        print(offSet+84, location.upperBound)
    }
    
    mutating func parseData() {}
}
