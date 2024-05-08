//
//  QTAtom.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation

enum QTAtomType: String {
    case root
    
    case ftyp // File Type Box
    case free // Free Space Box
    case mdat // Media Data Box
    case meta // Meta Box
    case uuid
    case moov // Movie Box
    case mvhd // Movie Header Box
    case trak // Track Box
    case tkhd // Track Header Box
    case mdia // Media Box
    case mdhd // Media Header Box
    case hdlr // Handler Reference Box
    case minf // Media Information Box
    case dinf // Data Information Box
    case dref // Data Reference Box
    case stbl // Sample Table Box
    case smhd // Sound Media Header Box
    case stsd // Sample Description Box
    case stts // Dacoding Time to Sample Box
    case ctts // Composition Time to Sample Box
    case stsc // Sample To Chunk Box
    case stsz // Sample Size Boxes
    case stco // Chunk Offset Box
    case stss // Sync Sample Box
    case edts // Edit Box
    case elst // Edit List Box
}

enum QTAtomHandlerType {
    case vide
    case soun
    case hint
    case meta
}

protocol QTAtom {
    var data: Data { get }
    var size: UInt32? { get set}
    var extSize: UInt64? { get set }
    var type: QTAtomType { get }
    var atomName: String { get }
    var location: Range<Int> { get }
    var children: [QTAtom] { get set}
    var level: Int { get set }
    
    var description: String { get }
    var extDescription: String? { get }
    mutating func parseData()
}

struct QTAtomParser: QTAtom {
    internal var data: Data
    var size: UInt32?
    var extSize: UInt64?
    var type: QTAtomType = .root
    var atomName = "Root"
    var location: Range<Int>
    var level: Int = 0
    
    var children = [QTAtom]()
    
    var extDescription: String?
    
    init(url: URL) throws {
        self.data = try Data(contentsOf: url, options: .mappedIfSafe)
        self.location = 0..<data.count
        
        startProcess()
    }
    
    mutating func parseData() {}
}

extension QTAtom {
    
    var description: String {
        
        var indent: String = ""
        
        for _ in 0..<level {
            indent = indent + "   "
        }
        
        var output = ""
        
        output += "\(indent)Type: \(type) - \(atomName)\n"
        
        if let size {
            output += "\(indent)| Size  - \(size)\n"
        }
        
        output += "\(indent)| Range - \(location)\n"
        output += "\(indent)| Level - \(level)"
        
        
        if let extDescription = extDescription {
            output += extDescription
        }
        
        output += "\n\n"
        
        for atom in children {
            output += atom.description
        }
        
        return output
    }
    
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
        
        var offSet: Int
        
        if type == .root {
            offSet = 0
        } else {
            offSet = 8
        }
        
        var i: Int = location.lowerBound + offSet
        
        while i != location.upperBound {
            
            var size: UInt32 = 0
            var extSize: UInt64?
            var location: Range<Int>
            
            guard let type = String(data: data[i+4..<i+8], encoding: .utf8) else {
                preconditionFailure()
            }
            
            size = data[i..<i+4].QTUtilConvert(type: UInt32.self)
            
            if size == 1 {
                extSize = data[i+8..<i+16].QTUtilConvert(type: UInt64.self)
                
                location = i..<i+Int(extSize!)
                i += Int(extSize!)
            } else {
                location = i..<i+Int(size)
                i += Int(size)
            }
            
            var qtAtom: QTAtom?
            
            switch type {
            case "ftyp":
                qtAtom = QTFtyp(data: data,size: size, extSize: extSize, location: location)
            case "moov":
                qtAtom = QTMoov(data: data,size: size, extSize: extSize, location: location)
            case "mdat":
                qtAtom = QTMdat(data: data,size: size, extSize: extSize, location: location)
            case "free":
                qtAtom = QTFree(data: data,size: size, extSize: extSize, location: location)
            case "meta":
                qtAtom = QTMeta(data: data,size: size, extSize: extSize, location: location)
            case "uuid":
                qtAtom = QTUuid(data: data,size: size, extSize: extSize, location: location)
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
            case "ctts":
                qtAtom = QTCtts(data: data ,size: size, extSize: extSize, location: location)
            case "stsc":
                qtAtom = QTStsc(data: data ,size: size, extSize: extSize, location: location)
            case "stsz":
                qtAtom = QTStsz(data: data ,size: size, extSize: extSize, location: location)
            case "stco":
                qtAtom = QTStco(data: data ,size: size, extSize: extSize, location: location)
            case "stss":
                qtAtom = QTStss(data: data ,size: size, extSize: extSize, location: location)
            case "edts":
                qtAtom = QTEdts(data: data ,size: size, extSize: extSize, location: location)
            case "elst":
                qtAtom = QTElst(data: data ,size: size, extSize: extSize, location: location)
                
            default:
                qtAtom = nil
            }
            
            guard let qtAtom else {
                continue
            }
            
            addChild(qtAtom: qtAtom)
        }
    }
}

protocol QTAtomProcessAvailable {
    mutating func startProcess()
}
