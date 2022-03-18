//
//  ArgumentsHandler.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 03/11/18.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser
import ArgumentParser

public struct VariableInjectorTool: ParsableCommand {
  
  public static let configuration = CommandConfiguration(abstract:
    "Variable injector is a very simple project with the goal of inject CI" +
    "pipelines environment variables values into Swift code static members before compilation")
  
  @Flag(name: [.customLong("verbose"), .customShort("v")],
        help: "Indicates if the tool will run in verbose mode or not")
  public var isVerbose: Bool = false
  
  @Option(name: [.customLong("file"), .customShort("f")],
          help: "The path(s) to the file(s) where the tool should run.")
  public var files: [String] = []
  
  @Option(name: [.customLong("ignore"), .customShort("i")],
          help: "The names of variables that will be ignored even if that matches $(ENV_VAR) to avoid the replacing")
  public var varLiteralsToIgnore: [String] = []
    
  public init() {}
  
  public mutating func validate() throws {
    if files.isEmpty {
      throw ValidationError("The path to at least one file where the variables will be injected should be provided. Use --file $path-to-file")
    }
  }
  
  public func run() throws {
    //Separator
    let printSeparator = "=" * 70
    // Logger
    let logger = isVerbose ? Logger() : nil

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

        let sourceFile = try SyntaxParser.parse(url)
        
        let envVarRewriter = EnvironmentVariableLiteralRewriter(
                                environment: ProcessInfo.processInfo.environment,
                                ignoredLiteralValues: varLiteralsToIgnore,
                                logger: logger
                             )
        let result = envVarRewriter.visit(sourceFile)
        
        var contents: String = ""
        result.write(to: &contents)
        
        try contents.write(to: url, atomically: true, encoding: .utf8)
        
        logger?.log(message: "\(printSeparator)\n")
        logger?.log(message: contents)
    }
  }
}
