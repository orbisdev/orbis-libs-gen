#!/usr/bin/swift
//
//  main.swift
//  orbis-parser
//
//  Created by Francisco Javier Trujillo Mata on 06/05/2020.
//  Copyright © 2020 MakeMeGolden. All rights reserved.
//

import Foundation

private enum Constants {
    static let outputPath = URL(fileURLWithPath: "output")
}

struct OrbisSymbol: Codable {
    let id: Double
    let name: String?
    let hex_id: String
    let encoded_id: String
    
    var assembly: String {
        guard let name = name else { return ""}
        return """
            .global \(name)
            .type \(name), @function
            __\(name):
                .qword 0x\(hex_id)
            
            """.trimmingCharacters(in: .whitespaces)
    }
}

struct OrbisLibrary: Codable {
    let name: String
    let version: Int
    let is_export: Bool
    let symbols: [OrbisSymbol]
    
    var assembly: String { symbols.reduce("") { $0 + $1.assembly }}
}

struct OrbisModule: Codable {
    let name: String
    let version_major: Int
    let version_minor: Int
    let libraries: [OrbisLibrary]
    
    var assembly: String {
        libraries.reduce("") { $1.is_export ? """
            \($0)
            .section .orbis.fstubs.\(name).\(version_major).\(version_minor).\($1.name).\($1.version),\"ax\",%progbits"
            \($1.assembly)
            """.trimmingCharacters(in: .whitespaces) : $0
        }
    }
}

struct OrbisSPRX: Codable {
    let shared_object_name: String
    let shared_object_names: [String]
    let modules: [OrbisModule]
    
    var assembly: String { modules.reduce("") { $0 + $1.assembly } }
}

class OrbisParser {
    func parse() {
        prepare()
        
        let fileName = "libScePad"
        let fileURL = URL(fileURLWithPath: "\(fileName).sprx.json")
        
        guard let data = try? Data(contentsOf: fileURL) else { return }
        do {
            let sprx = try JSONDecoder().decode(OrbisSPRX.self, from: data)
            
            createAssemblyFile("\(fileName).s", content: sprx.assembly)
        } catch {
            print(error)
        }
    }
    
    private func createAssemblyFile(_ fileName: String, content: String) {
        let fileManager = FileManager.default
        let newFile = URL(fileURLWithPath:fileName, relativeTo: Constants.outputPath).path
        
        if(!fileManager.fileExists(atPath:newFile)){
            fileManager.createFile(atPath: newFile, contents: content.data(using: .utf8), attributes: nil)
        }else{
            print("File is already created")
        }
    }
    
    private func prepare() {
        // Remove and create output dir
        try? FileManager.default.removeItem(at: Constants.outputPath)
        try? FileManager.default.createDirectory(at: Constants.outputPath, withIntermediateDirectories: true, attributes: nil)
    }
}

print("***************** START *****************\n")
let parser = OrbisParser()
parser.parse()
print("***************** END *****************\n")
