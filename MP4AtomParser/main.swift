//
//  main.swift
//  MP4AtomParser
//
//  Created by Kiyoshi Nagahama on 4/28/24.
//

import Foundation
import ArgumentParser

struct MP4AtomParser: ParsableCommand {
    @Argument() var filePath: String

    func run() {
        let url = URL(fileURLWithPath: filePath)
        
        do {
            
            let qtAtomParser = try QTAtomParser(url: url)
            print(qtAtomParser.description)

        } catch {
            print(error)
        }
        
    }
}

MP4AtomParser.main()
