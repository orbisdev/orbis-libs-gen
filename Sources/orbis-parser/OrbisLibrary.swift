import Foundation

struct OrbisLibrary: Codable {
    let name: String
    let version: Int
    let is_export: Bool
    let symbols: [OrbisSymbol]
    
    func assemblyFiles(section: String) -> [String: String] {
        symbols.reduce(into: [:]) {
            guard let symbolName = $1.name else { return }
            let keyName = "\(name).\(symbolName)"
            $0[keyName] = $1.assembly(section: section)
        }
    }
} 
