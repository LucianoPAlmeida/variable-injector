//
//  EnvironmentVariableLiteralRewriter.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 02/11/18.
//

import Foundation
import SwiftSyntax

private let stringLiteralEnvVarPattern: String = "\"*\\$\\((\\w+)\\)\"*"

public class EnvironmentVariableLiteralRewriter: SyntaxRewriter {
  public var ignoredLiteralValues: Set<String> = []
  private var environment: [String: String] = [:]
  public var logger: Logger?
  
  public init(environment: [String: String]) {
    self.environment = environment
  }
  
  public convenience init(
    environment: [String: String],
    ignoredLiteralValues: [String],
    logger: Logger? = nil) {
    self.init(environment: environment)
    self.ignoredLiteralValues = Set(ignoredLiteralValues)
    self.logger = logger
  }
  
  override public func visit(_ token: TokenSyntax) -> Syntax {
    // Matching ENV var pattern e.g. $(ENV_VAR)
    guard matchesLiteralPattern(token) else { return Syntax(token) }
    
    guard let text = token.stringLiteral else { return Syntax(token) }
    
    let envVar = extractTextEnvVariableName(text)
    
    guard shouldPerformSubstitution(for: envVar), let envValue = environment[envVar] else {
      return Syntax(token)
    }
    
    logger?.log(message: "Injecting ENV_VAR: \(text), value: \(envValue)")
    return Syntax(token.byReplacingStringLiteral(string: envValue))
  }
  
  private func shouldPerformSubstitution(for text: String) -> Bool {
    return !ignoredLiteralValues.contains(text)
  }
  
  private func extractTextEnvVariableName(_ text: String) -> String {
    let regex = try? NSRegularExpression(pattern: stringLiteralEnvVarPattern, options: .caseInsensitive)
    let matches = regex?.matches(in: text, options: .anchored, range: NSRange(location: 0, length: text.count))
    
    guard let match = matches?.first else { return "" }
  
    let range = match.range(at: 1)
    let start = text.index(text.startIndex, offsetBy: range.location)
    let end = text.index(start, offsetBy: range.length)

    return String(text[start..<end])
  }
  
}

extension EnvironmentVariableLiteralRewriter {
  func matchesLiteralPattern(_ token: TokenSyntax) -> Bool {
    switch token.tokenKind {
    case .stringLiteral(let text), .stringSegment(let text):
      return text.matches(regex: stringLiteralEnvVarPattern)
    default:
      return false
    }
  }
}
