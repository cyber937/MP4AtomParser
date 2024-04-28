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
    
    func startProcess() {
        
        var i: Int = 0
        
        while i != qtAtomData.count {
            
            let size = qtAtomData[i..<i+4]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            guard let type = String(data: qtAtomData[i+4..<i+8], encoding: .utf8) else {
                preconditionFailure()
            }
            
            var qtAtom: QTAtom?
            
            switch type {
            case "ftyp":
                qtAtom = QTFtyp(data: qtAtomData,size: size, location: i..<i+Int(size))
            case "moov":
                qtAtom = QTMoov(data: qtAtomData, size: size, location: i..<i+Int(size))
            case "mdat":
                qtAtom = QTMdat(data: qtAtomData,size: size, location: i..<i+Int(size))
            case "free":
                qtAtom = QTFree(data: qtAtomData,size: size, location: i..<i+Int(size))
                
            default:
                qtAtom = nil
            }
            
            guard let qtAtom else {
                i = i + Int(size)
                print(type)
                continue
            }
            
            addChild(qtAtom: qtAtom)
            
            i += Int(size)
        }
    }
    
    func addChild(qtAtom: QTAtom) {
        if var qtAtomProcessAvailable = qtAtom as? QTAtomProcessAvailable {
            qtAtomProcessAvailable.startProcess()
            children.append(qtAtomProcessAvailable as! QTAtom)
        } else {
            children.append(qtAtom)
        }
    }
}
