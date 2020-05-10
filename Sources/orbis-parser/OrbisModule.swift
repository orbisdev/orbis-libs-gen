import Foundation

struct OrbisModule: Codable {
    let name: String
    let version_major: Int
    let version_minor: Int
    let libraries: [OrbisLibrary]
        
    var assembly: String {
        libraries.reduce("") {
            guard name == $1.name else { return $0 }
            let section = "\(name).\(version_major).\(version_minor).\($1.name).\($1.version)"
            return """
            \($0)
            \($1.assembly(section: section))
            """.trimmingCharacters(in: .whitespaces)
        }
    }
}
