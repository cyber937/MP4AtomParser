//
//  QTUtility.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/30/24.
//

import Foundation

func QTUtilUTCConvert(data: Data) -> Date {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    let utcMidnightJan01904DateTime = formatter.date(from: "1904/01/01 00:00")
    
    let tempCtrationTimeSecond = data
        .reduce(0, { soFar, new in
            (soFar << 8) | UInt64(new)
        })
    
    let tempCtrationTimeInterval = TimeInterval(tempCtrationTimeSecond)
    let result = Date(timeInterval: tempCtrationTimeInterval, since: utcMidnightJan01904DateTime!)
    
    return result
}

func QTFixedPointConvert<Above: UnsignedInteger, Below: UnsignedInteger>(data: Data, aboveType: Above.Type, belowType: Below.Type) -> Float {
    
    let aboveTypeSize = MemoryLayout<Above>.size
    let belowTypeSize = MemoryLayout<Below>.size
    
    guard data.count == aboveTypeSize + belowTypeSize else { preconditionFailure() }
    
    let aboveDecimalPoint = data[0..<aboveTypeSize]
        .reduce(0, { soFar, new in
            (soFar << 8) | Above(new)
        })
    
    let belowDecimalPoint = data[aboveTypeSize..<belowTypeSize]
        .reduce(0, { soFar, new in
            (soFar << 8) | Below(new)
        })
    
    let result = Float(aboveDecimalPoint) + Float(belowDecimalPoint) / Float(10 * belowDecimalPoint.words.count)
    
    return result
}

//func QTFixedPointConvert(data: Data, aboveCount: Int, belowCount: Int) -> Float {
//    
//    var aboveDecimalPoint: Int
//    var belowTypeSize: Int
//
//    guard data.count == aboveCount + belowCount else { preconditionFailure() }
//    
//    if aboveCount == 1 {
//        aboveDecimalPoint = data[0..<aboveTypeSize]
//            .reduce(0, { soFar, new in
//                (soFar << 8) | Above(new)
//            })
//    }
//    
//    let aboveDecimalPoint = data[0..<aboveTypeSize]
//        .reduce(0, { soFar, new in
//            (soFar << 8) | Above(new)
//        })
//    
//    let belowDecimalPoint = data[aboveTypeSize..<belowTypeSize]
//        .reduce(0, { soFar, new in
//            (soFar << 8) | Below(new)
//        })
//    
//    let result = Float(aboveDecimalPoint) / Float(10 * belowDecimalPoint.words.count)
//    
//    return result
//}

func QTMatrixConvert(data: Data) -> [Float] {
    
    var result = [Float]()
    var i: Int = 0
    
    while i != 36 {
        let matrixValueData = data.subdata(in: i..<i+4)
        
        var matrixValue: Float
        
        if i%3 == 2 {
            let aboveDecimalPoint = data[0..<3]
                .reduce(0, { soFar, new in
                    (soFar << 8) | Int(new)
                })
            
            let belowDecimalPoint = data[3..<4]
                .reduce(0, { soFar, new in
                    (soFar << 8) | Int(new)
                })
 
            matrixValue = Float(aboveDecimalPoint) / Float(10 * belowDecimalPoint.words.count)
        } else {
            matrixValue = QTFixedPointConvert(data: matrixValueData, aboveType: UInt16.self, belowType: UInt16.self)
        }
            
        result.append(matrixValue)
        i = i + 4
    }
    
    return result
}

