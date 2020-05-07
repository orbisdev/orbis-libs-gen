import Foundation

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