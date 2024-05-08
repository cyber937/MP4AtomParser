//
//  QTHdlr.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

// Handler Reference Box

struct QTHdlr: QTAtom, CustomStringConvertible {
    var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .hdlr
    var atomName: String = "Handler Reference Box"
    var location: Range<Int>?
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var version: UInt32 = 0
    var handlerType: QTAtomHandlerType?
    var name: String?
    
    var extDescription: String? {
        
        guard let handlerType,
              let name else { return nil }
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        let output = """
        \n\(indent)|
        \(indent)| Handler Type - \(handlerType)
        \(indent)| Name - \(name)
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
        
        // pre_defined UInt(32)
        
        guard let handlerTypeStr = String(data: data[offSet+8..<offSet+12], encoding: .utf8) else {
            preconditionFailure()
        }
        
        switch handlerTypeStr {
        case "vide":
            handlerType = .vide
        case "soun":
            handlerType = .soun
        case "hint":
            handlerType = .hint
        case "meta":
            handlerType = .meta
            
        default:
            print("Handler Error ... \(handlerTypeStr)")
        }
        
        // reserved unsigned int (32) [3] // 96
        
        if let handlerTypeStr = String(data: data[offSet+24..<location.upperBound], encoding: .utf8) {
            name = handlerTypeStr
        } else {
            name = "Undifined"
        }
    }
    
    mutating func parseData() {}
}
