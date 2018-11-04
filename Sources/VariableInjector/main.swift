
import Foundation
import SwiftSyntax

let file = CommandLine.arguments[1]
let url = URL(fileURLWithPath: file)
let sourceFile = try SyntaxTreeParser.parse(url)

let result = EnvirionmentVariableLiteralRewriter().visit(sourceFile)

var contents: String = ""
result.write(to: &contents)

try? contents.write(to: url, atomically: true, encoding: .utf8)
print(contents)
