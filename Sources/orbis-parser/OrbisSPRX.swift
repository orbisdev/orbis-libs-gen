import Foundation

struct OrbisSPRX: Codable {
    let shared_object_name: String?
    let shared_object_names: [String]?
    let modules: [OrbisModule]
    
    var assemblyContent: String { modules.reduce("") { $0 + $1.assemblyFiles } }
}
