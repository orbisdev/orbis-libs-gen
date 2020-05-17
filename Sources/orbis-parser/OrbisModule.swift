import Foundation

struct OrbisModule: Codable {
    let name: String
    let version_major: Int
    let version_minor: Int
    let libraries: [OrbisLibrary]
    
    var assemblyFiles: String {
        libraries.reduce(into: "") {
            guard $1.name == name else { return }
            let section = "\(name).\(version_major).\(version_minor).\($1.name).\($1.version)"
            let sectionFooter = """
                .section .comment,"MS",@progbits,8
                .string "\(section)"
            """.trimmingCharacters(in: .whitespaces)
            let assemblyFunctions = $1.assemblyFunctions(section: section)
            guard assemblyFunctions.count > 0 else { return }
            let libraryFunctions = assemblyFunctions.reduce("") { "\($0)\n\($1.value)" }
            $0.append("\(libraryFunctions)\n\(sectionFooter)\n")
        }
    }
}
