import Foundation

struct OrbisModule: Codable {
    let name: String
    let version_major: Int
    let version_minor: Int
    let libraries: [OrbisLibrary]
    
    var assembly: String {
        libraries.reduce("") {
            guard name == $1.name else { return $0 }
            return """
            \($0)
            .section .orbis.fstubs.\(name).\(version_major).\(version_minor).\($1.name).\($1.version),\"ax\",%progbits
            \($1.assembly)
            """.trimmingCharacters(in: .whitespaces)
        }
    }
}
