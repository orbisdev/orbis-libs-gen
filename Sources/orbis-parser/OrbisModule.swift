import Foundation

struct OrbisModule: Codable {
    let name: String
    let version_major: Int
    let version_minor: Int
    let libraries: [OrbisLibrary]
    
    var assemblyFiles: [String: String] {
        libraries.reduce(into: [:]) {
            guard $1.name == name else { return }
            let section = "\(name).\(version_major).\(version_minor).\($1.name).\($1.version)"
            $0.merge($1.assemblyFiles(section: section)) { (current, _) in current }
        }
    }
}
