import Foundation

struct OrbisSPRX: Codable {
    let shared_object_name: String?
    let shared_object_names: [String]?
    let modules: [OrbisModule]
    
    var assemblyFiles: [String: String] {
        modules.reduce(into: [:]) {
            $0.merge($1.assemblyFiles) { (current, _) in current }
        }
    }
}
