import Foundation

struct OrbisModule: Codable {
    let name: String
    let version_major: Int
    let version_minor: Int
    let libraries: [OrbisLibrary]
    
    var assembly: String {
        libraries.reduce("") { $1.is_export ? """
            \($0)
            .section .orbis.fstubs.\(name).\(version_major).\(version_minor).\($1.name).\($1.version),\"ax\",%progbits"
            \($1.assembly)
            """.trimmingCharacters(in: .whitespaces) : $0
        }
    }
}