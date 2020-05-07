import Foundation

private enum Constants {
    static let outputPath = URL(fileURLWithPath: "output")
    static let inputPath = URL(fileURLWithPath: "ps4libdoc")
}

class OrbisParser {
    init() {
        prepare()
    }
    
    func parse() {
        printFolders()
        let fileName = "libScePad"
        let fileURL = URL(fileURLWithPath: "\(fileName).sprx.json")

        guard let data = try? Data(contentsOf: fileURL) else { return }
        do {
            let sprx = try JSONDecoder().decode(OrbisSPRX.self, from: data)

            createAssemblyFile("\(fileName).s", content: sprx.assembly)
        } catch {
            print(error)
        }
    }
    
    private func createAssemblyFile(_ fileName: String, content: String) {
        let fileManager = FileManager.default
        let newFile = Constants.outputPath.appendingPathComponent(fileName).path
        
        if(!fileManager.fileExists(atPath:newFile)){
            fileManager.createFile(atPath: newFile, contents: content.data(using: .utf8), attributes: nil)
        }else{
            print("File is already created")
        }
    }
    
    private func prepare() {
        // Remove and create output dir
        try? FileManager.default.removeItem(at: Constants.outputPath)
        try? FileManager.default.createDirectory(at: Constants.outputPath, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func printFolders() {
        var files = [URL]()
        if let enumerator = FileManager.default.enumerator(at: Constants.inputPath, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        files.append(fileURL)
                    }
                } catch { print(error, fileURL) }
            }
            print(files)
        }
    }

}
