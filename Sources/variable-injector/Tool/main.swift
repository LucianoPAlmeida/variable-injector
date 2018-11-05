import SwiftSyntax
import Foundation
import variable_injector_core

//Separator
let printSeparator = "=" * 70

// Logger
var logger: Logger?

// Handling arguments
let arguments = ArgumentsHandler(args: CommandLine.arguments)

let files = arguments.argumentValues(for: "file")
guard !files.isEmpty else {
    print("The path to at least one file where the variables will be injected should be passed. Use --file $path-to-file")
    exit(1)
}

let varLiteralsToIgnore = arguments.argumentValues(for: "ignore")

let isVerbose = arguments.contains(arg: "verbose")

if isVerbose {
    logger = Logger()
}

// Loading files
for file in files {
    let url = URL(fileURLWithPath: file)
    
    guard FileManager.default.fileExists(atPath: file) else {
        logger?.log(message: "File not found. Skipping: \(url)")
        continue;
    }
    
    logger?.log(message: "\(printSeparator)\n")
    logger?.log(message: "FILE: \(url.lastPathComponent)")
    logger?.log(message: "\(printSeparator)\n")

    let sourceFile = try SyntaxTreeParser.parse(url)
    
    let envVarRewriter = EnvirionmentVariableLiteralRewriter(ignoredLiteralValues: varLiteralsToIgnore)
    envVarRewriter.logger = logger
    let result = envVarRewriter.visit(sourceFile)
    
    var contents: String = ""
    result.write(to: &contents)
    
    try? contents.write(to: url, atomically: true, encoding: .utf8)
    
    logger?.log(message: "\(printSeparator)\n")
    logger?.log(message: contents)
}
