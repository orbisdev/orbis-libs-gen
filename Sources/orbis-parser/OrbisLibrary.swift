import Foundation

struct OrbisLibrary: Codable {
    let name: String
    let version: Int
    let is_export: Bool
    let symbols: [OrbisSymbol]
    
    func assembly(section: String) -> String {
        is_export ? symbols.reduce("") { $0 + $1.assembly(section: section) }  : ""
    }
} 
