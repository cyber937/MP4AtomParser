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
            
            let qtAtomPerser = try QTAtomParser(url: url)
            
            qtAtomPerser.startProcess()

            print(qtAtomPerser.description)

        } catch {
            print(error)
        }
        
    }
}

MP4AtomParser.main()
