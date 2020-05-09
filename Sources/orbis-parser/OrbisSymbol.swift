import Foundation

struct OrbisSymbol: Codable {
    enum SymbolType: String, Codable {
        case Object
        case Function
        case TLS
        case Unknown11
    }

    let id: Double
    let name: String?
    let hex_id: String
    let encoded_id: String
    let type: SymbolType?
    private var assemblyType: String { self.type == .Object ? "@object" : "@function" }
    private var assemblySection: String { self.type == .Object ? "ostubs" : "fstubs" }
    
    var assembly: String {
        guard let name = name else { return ""}
        return """
            .global \(name)
            .type \(name), \(assemblyType)
            \(name):
                .quad 0x\(hex_id)
            
            """.trimmingCharacters(in: .whitespaces)
    }
    
    func assembly(section: String) -> String {
        guard let name = name else { return ""}
        return """
            .section .orbis.\(assemblySection).\(section).\(name),\"ax\",%progbits
            .global \(name)
            .type \(name), \(assemblyType)
            \(name):
                .quad 0x\(hex_id)
            
            """.trimmingCharacters(in: .whitespaces)
    }
}
