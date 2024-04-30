//
//  QTAtom.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

enum QTAtomType: String {
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
    var size: UInt32 { get set}
    var extSize: UInt64? { get set }
    var type: QTAtomType { get }
    var location: Range<Int> { get set}
    var children: [QTAtom] { get set}
    var description: String { get }
    var level: Int { get set }
    
    mutating func parseData()
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
            
            var size: UInt32 = 0
            var extSize: UInt64?
            var location: Range<Int>
            
            guard let type = String(data: data[i+4..<i+8], encoding: .utf8) else {
                preconditionFailure()
            }
            
            size = data[i..<i+4]
                .reduce(0, { soFar, new in
                    (soFar << 8) | UInt32(new)
                })
            
            if size == 1 {
                extSize = data[i+8..<i+16]
                    .reduce(0, { soFar, new in
                        (soFar << 8) | UInt64(new)
                    })
                location = i..<i+Int(extSize!)
                i += Int(extSize!)
            } else {
                location = i..<i+Int(size)
                i += Int(size)
            }
            
            var qtAtom: QTAtom?
            
            switch type {
            case "mvhd":
                qtAtom = QTMvhd(data: data ,size: size, extSize: extSize, location: location)
            case "trak":
                qtAtom = QTTrak(data: data ,size: size, extSize: extSize, location: location)
            case "tkhd":
                qtAtom = QTTkhd(data: data ,size: size, extSize: extSize, location: location)
            case "mdia":
                qtAtom = QTMdia(data: data ,size: size, extSize: extSize, location: location)
            case "mdhd":
                qtAtom = QTMdhd(data: data ,size: size, extSize: extSize, location: location)
            case "hdlr":
                qtAtom = QTHdlr(data: data ,size: size, extSize: extSize, location: location)
            case "minf":
                qtAtom = QTMinf(data: data ,size: size, extSize: extSize, location: location)
            case "smhd":
                qtAtom = QTSmhd(data: data ,size: size, extSize: extSize, location: location)
            case "dinf":
                qtAtom = QTDinf(data: data ,size: size, extSize: extSize, location: location)
            case "dref":
                qtAtom = QTDref(data: data ,size: size, extSize: extSize, location: location)
            case "stbl":
                qtAtom = QTStbl(data: data ,size: size, extSize: extSize, location: location)
            case "stsd":
                qtAtom = QTStsd(data: data ,size: size, extSize: extSize, location: location)
            case "stts":
                qtAtom = QTStts(data: data ,size: size, extSize: extSize, location: location)
            case "stsc":
                qtAtom = QTStsc(data: data ,size: size, extSize: extSize, location: location)
            case "stsz":
                qtAtom = QTStsz(data: data ,size: size, extSize: extSize, location: location)
            case "stco":
                qtAtom = QTStco(data: data ,size: size, extSize: extSize, location: location)
                
            default:
                qtAtom = nil
            }
            
            guard let qtAtom else {
                continue
            }
            
            addChild(qtAtom: qtAtom)
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
