//
//  QTAtom.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

enum QTAtomType {
    case ftyp
    case moov
    case mdat
    case free
    
    // ----- Inside 'moov'
    case mvhd
    case trak
    
    // ----- Inside 'trak'
    case tkhd
    case mdia
    
    // ----- Inside 'mdia'
    case mdhd
    case hdlr
    case minf
    
    // ----- Inside 'minf'
    case smhd
    case dinf
    case stbl
    
    // ----- Inside 'dinf'
    case dref
    
    // ----- Inside 'stbl'
    case stsd
    case stts
    case stsc
    case stsz
    case stco
}

protocol QTAtom {
    var data: Data { get }
    var size: UInt32 { get }
    var type: QTAtomType { get }
    var location: Range<Int> { get }
    var children: [QTAtom] { get set}
    var description: String { get }
    var level: Int { get set }
}

extension QTAtom {
    mutating func addChild(qtAtom: QTAtom) {
        var qtAtom = qtAtom
        qtAtom.level =  self.level + 1
        
        if var qtAtomProcessAvailable = qtAtom as? QTAtomProcessAvailable {
            qtAtomProcessAvailable.startProcess()
            children.append(qtAtomProcessAvailable as! QTAtom)
        } else {
            children.append(qtAtom)
        }
    }
    
    mutating func startProcess() {
        var i: Int = location.lowerBound + 8
        
        while i != location.upperBound {
            
            let size: UInt32 = data[i..<i+4]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            guard let type = String(data: data[i+4..<i+8], encoding: .utf8) else {
                preconditionFailure()
            }
            
            var qtAtom: QTAtom?
            
            switch type {
            case "mvhd":
                qtAtom = QTMvhd(data: data ,size: size, location: i..<i+Int(size))
            case "trak":
                qtAtom = QTTrak(data: data ,size: size, location: i..<i+Int(size))
            case "tkhd":
                qtAtom = QTTkhd(data: data ,size: size, location: i..<i+Int(size))
            case "mdia":
                qtAtom = QTMdia(data: data ,size: size, location: i..<i+Int(size))
            case "mdhd":
                qtAtom = QTMdhd(data: data ,size: size, location: i..<i+Int(size))
            case "hdlr":
                qtAtom = QTHdlr(data: data ,size: size, location: i..<i+Int(size))
            case "minf":
                qtAtom = QTMinf(data: data ,size: size, location: i..<i+Int(size))
            case "smhd":
                qtAtom = QTSmhd(data: data ,size: size, location: i..<i+Int(size))
            case "dinf":
                qtAtom = QTDinf(data: data ,size: size, location: i..<i+Int(size))
            case "dref":
                qtAtom = QTDref(data: data ,size: size, location: i..<i+Int(size))
            case "stbl":
                qtAtom = QTStbl(data: data ,size: size, location: i..<i+Int(size))
            case "stsd":
                qtAtom = QTStsd(data: data ,size: size, location: i..<i+Int(size))
            case "stts":
                qtAtom = QTStts(data: data ,size: size, location: i..<i+Int(size))
            case "stsc":
                qtAtom = QTStsc(data: data ,size: size, location: i..<i+Int(size))
            case "stsz":
                qtAtom = QTStsz(data: data ,size: size, location: i..<i+Int(size))
            case "stco":
                qtAtom = QTStco(data: data ,size: size, location: i..<i+Int(size))
                
            default:
                qtAtom = nil
            }
            
            guard let qtAtom else {
                i += Int(size)
                continue
            }
            
            addChild(qtAtom: qtAtom)
            
            i += Int(size)
        }
    }
    
    var description: String {
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        var output = """
        \(indent)Type: \(type)
        \(indent)Size  - \(size)
        \(indent)Range - \(location)
        \(indent)Level - \(level)\n
        
        """
        
        for atom in children {
            output += atom.description
        }
        
        return output
    }
}

protocol QTAtomProcessAvailable {
    mutating func startProcess()
}

protocol QTAtomChild {
    var level: Int { get set }
}
