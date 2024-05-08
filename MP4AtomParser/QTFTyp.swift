//
//  QTType.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

struct QTFtyp: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .ftyp
    var atomName: String = "File Type Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    // ftyp data
    var majorBrand: String = ""
    var minorVersion: UInt32 = 0
    var compatibleBrands: [String] = [String]()
    
    init(data: Data, size: UInt32, extSize: UInt64?, location: Range<Int>) {
        self.data = data
        self.size = size
        self.extSize = extSize
        self.location = location
        
        // Offset value the data's started value + size value (32 bit) + type value (32 bit)
        let offSet = location.lowerBound+8
        
        // Extract major brand as String
        guard let majorBrandTemp = String(data: data[offSet..<offSet+4], encoding: .utf8) else {
            preconditionFailure()
        }
        majorBrand = majorBrandTemp
        
        // Extract minot version as Int
        minorVersion = data[offSet+4..<offSet+8].QTUtilConvert(type: UInt32.self)
        
        // Extract compatible brands as [String]
        var i: Int = offSet+8
        while i != location.upperBound {
            
            guard let compatibleBrand = String(data: data[i..<i+4], encoding: .utf8) else {
                preconditionFailure()
            }
            
            compatibleBrands.append(compatibleBrand)
            
            i += 4
        }
    }
    
    var extDescription: String? {
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        let output = """
        \n\(indent)|
        \(indent)| Major Brand - \(majorBrand)
        \(indent)| Minor Version  - \(minorVersion)
        \(indent)| Compatible Brands - \(compatibleBrands)
        """
        
        return output
    }
    
    mutating func parseData() {
        
        guard let majorBrandTemp = String(data: data[location!.lowerBound+8..<4], encoding: .utf8) else {
            preconditionFailure()
        }
        
        majorBrand = majorBrandTemp
    }
}
