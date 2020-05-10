import Foundation

private enum Constants {
    static let outputPath = URL(fileURLWithPath: "lib_s")
    static let inputPath = URL(fileURLWithPath: "ps4libdoc")
    static let sprxFiles = ".sprx.json"
    static let sFiles = ".S"
}

class OrbisParser {
    init() { prepareFolder(url: Constants.outputPath) }
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
            let attrs = try? fileURL.resourceValues(forKeys:[.isRegularFileKey]), attrs.isRegularFile == true
                else { return }
            $0.append(fileURL)
        }
    }
    
    func parseFile(_ fileURL: URL) {
        let libraryName = fileURL.lastPathComponent.replacingOccurrences(of: Constants.sprxFiles, with: "")
        
        guard Libraries().known.contains(libraryName), let data = try? Data(contentsOf: fileURL) else { return }
        do {
            let sprx = try JSONDecoder().decode(OrbisSPRX.self, from: data)
            let folderUlr = Constants.outputPath.appendingPathComponent(libraryName)
            let symbols = sprx.assemblyFiles
            guard symbols.count > 0  else { return }
            
            prepareFolder(url: folderUlr)
            symbols.forEach {
                createAssemblyFile(folderUlr.appendingPathComponent($0.key).appendingPathExtension("S").path,
                                   content: $0.value)
            }
            
        } catch {
            print(fileURL.lastPathComponent)
            print(error)
        }
    }
    
    func createAssemblyFile(_ fileName: String, content: String) {
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath:fileName)){
            fileManager.createFile(atPath: fileName, contents: content.data(using: .utf8), attributes: nil)
        }else{
            print("\(fileName) was already created")
        }
    }
    
    func prepareFolder(url: URL) {
        // Remove and create output dir
        try? FileManager.default.removeItem(at: url)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
}
