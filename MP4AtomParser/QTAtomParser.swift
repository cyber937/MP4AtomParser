//
//  QTAtomParser.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

class QTAtomParser: CustomStringConvertible {
    
    private let qtAtomData: Data
    private var children = [QTAtom]()
    
    var description: String {
        
        var description: String = ""
        
        for atom in children {
            description = description + atom.description
        }
        
        return description
        
    }
    
    init(url: URL) throws {
        self.qtAtomData = try Data(contentsOf: url, options: .mappedIfSafe)
    }
    
    func addChild(qtAtom: QTAtom) {
        if var qtAtomProcessAvailable = qtAtom as? QTAtomProcessAvailable {
            qtAtomProcessAvailable.startProcess()
            children.append(qtAtomProcessAvailable as! QTAtom)
        } else {
            children.append(qtAtom)
        }
    }
    
    func startProcess() {
        
        var i: Int = 0
    
        while i != qtAtomData.count {
            
            var size: UInt32 = 0
            var extSize: UInt64?
            var location: Range<Int>
            
            guard let type = String(data: qtAtomData[i+4..<i+8], encoding: .utf8) else {
                preconditionFailure()
            }
            
            size = qtAtomData[i..<i+4].QTUtilConvert(type: UInt32.self)
            
            if size == 1 {
                extSize = qtAtomData[i+8..<i+16].QTUtilConvert(type: UInt64.self)
                
                location = i..<i+Int(extSize!)
                i += Int(extSize!)
            } else {
                location = i..<i+Int(size)
                i += Int(size)
            }
            
            var qtAtom: QTAtom?
            
            switch type {
            case "ftyp":
                qtAtom = QTFtyp(data: qtAtomData,size: size, extSize: extSize, location: location)
            case "moov":
                qtAtom = QTMoov(data: qtAtomData,size: size, extSize: extSize, location: location)
            case "mdat":
                qtAtom = QTMdat(data: qtAtomData,size: size, extSize: extSize, location: location)
            case "free":
                qtAtom = QTFree(data: qtAtomData,size: size, extSize: extSize, location: location)
            case "meta":
                qtAtom = QTMeta(data: qtAtomData,size: size, extSize: extSize, location: location)
            case "uuid":
                qtAtom = QTUuid(data: qtAtomData,size: size, extSize: extSize, location: location)
            default:
                qtAtom = nil
            }
            
            guard let qtAtom else {
                print(type)
                continue
            }
            
            addChild(qtAtom: qtAtom)
        }
    }
}
