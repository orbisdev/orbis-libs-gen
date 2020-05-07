import Foundation

private enum Constants {
    static let outputPath = URL(fileURLWithPath: "output")
}

class OrbisParser {
    func parse() {
        prepare()
        
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

}
