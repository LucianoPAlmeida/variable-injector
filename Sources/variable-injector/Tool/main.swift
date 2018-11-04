import SwiftSyntax
import Foundation
import variable_injector_core

// Handling arguments
let arguments = ArgumentsHandler(args: CommandLine.arguments)

let files = arguments.argumentValues(for: "file")
guard !files.isEmpty else {
    fatalError("The path to at least one file where the variables will be injected should be passed. Use --file $path-to-file")
}

let varLiteralsToIgnore = arguments.argumentValues(for: "ignore")

// Loading files
for file in files {
    let url = URL(fileURLWithPath: file)
    let sourceFile = try SyntaxTreeParser.parse(url)
    
    let envVarRewriter = EnvirionmentVariableLiteralRewriter(ignoredLiteralValues: varLiteralsToIgnore)
    let result = envVarRewriter.visit(sourceFile)
    
    var contents: String = ""
    result.write(to: &contents)
    
    try? contents.write(to: url, atomically: true, encoding: .utf8)
    
    print("========================================================================\n")
    print(contents)
}

