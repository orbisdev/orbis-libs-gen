import Foundation

private enum Constants {
    static let outputPath = URL(fileURLWithPath: "output")
    static let inputPath = URL(fileURLWithPath: "ps4libdoc")
    static let sprxFiles = ".sprx.json"
    static let sFiles = ".s"
}

class OrbisParser {
    init() { prepare() }
    func parse() { filesToParse.forEach { parseFile($0) } }
}

// MARK: - Private Methods
private extension OrbisParser {
    private var filesToParse: [URL] {
        guard let enumerator = FileManager.default.enumerator(at: Constants.inputPath,
                                                              includingPropertiesForKeys: [.isRegularFileKey],
                                                              options: [.skipsHiddenFiles, .skipsPackageDescendants])
        else { return [] }
        
        return enumerator.reduce(into: [URL]()) {
            guard let fileURL = $1 as? URL, fileURL.absoluteString.hasSuffix(Constants.sprxFiles),
            let attrs = try? fileURL.resourceValues(forKeys:[.isRegularFileKey]),
            attrs.isRegularFile == true  else { return }
            $0.append(fileURL)
        }
    }
    
    func parseFile(_ fileURL: URL) {
        let filename = fileURL.lastPathComponent.replacingOccurrences(of: Constants.sprxFiles, with: Constants.sFiles)

        guard let data = try? Data(contentsOf: fileURL) else { return }
        do {
            let sprx = try JSONDecoder().decode(OrbisSPRX.self, from: data)

            createAssemblyFile(filename, content: sprx.assembly)
        } catch {
            print(fileURL.lastPathComponent)
            print(error)
        }
    }
    
    func createAssemblyFile(_ fileName: String, content: String) {
        let fileManager = FileManager.default
        let newFile = Constants.outputPath.appendingPathComponent(fileName).path
        
        if(!fileManager.fileExists(atPath:newFile)){
            fileManager.createFile(atPath: newFile, contents: content.data(using: .utf8), attributes: nil)
        }else{
            print("File is already created")
        }
    }
    
    func prepare() {
        // Remove and create output dir
        try? FileManager.default.removeItem(at: Constants.outputPath)
        try? FileManager.default.createDirectory(at: Constants.outputPath, withIntermediateDirectories: true, attributes: nil)
    }
}
