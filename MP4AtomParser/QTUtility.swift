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

