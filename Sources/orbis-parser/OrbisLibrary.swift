import Foundation

struct OrbisLibrary: Codable {
    let name: String
    let version: Int
    let is_export: Bool
    let symbols: [OrbisSymbol]
    
    var assembly: String { symbols.reduce("") { $0 + $1.assembly }}
}