//
//  EnvironmentVariableLiteralRewriter.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 02/11/18.
//

import Foundation
import SwiftSyntax

private let stringLiteralEnvVarPattern: String = "\"\\$\\(\\w+\\)\""
private let stringSegmentEnvVarPattern: String = "\\$\\(\\w+\\)"

public class EnvironmentVariableLiteralRewriter: SyntaxRewriter {
    public var ignoredLiteralValues: Set<String> = []    
    private var environment: [String: String] = [:]    
    public var logger: Logger?
    
    public init(environment: [String: String] = ProcessInfo.processInfo.environment) {
        self.environment = environment
    }
    
    public convenience init(
        environment: [String: String] = ProcessInfo.processInfo.environment,
        ignoredLiteralValues: [String]) {
        self.init(environment: environment)
        self.ignoredLiteralValues = Set(ignoredLiteralValues)
    }
    
    override public func visit(_ token: TokenSyntax) -> Syntax {
        //Matching ENV var pattern e.g. $(ENV_VAR)
        guard let text = token.tokenKind.envVarText else { return token }
        
        let envVar = extractTextEnvVariableName(text: text, tokenKind: token.tokenKind)

        guard shouldPerformSubstitution(for: envVar), let envValue = environment[envVar] else {
            return token
        }
        
        logger?.log(message: "Injecting ENV_VAR: \(text), value: \(envValue)")
        return token.with(envValue: envValue)
    }
    
    private func shouldPerformSubstitution(for text: String) -> Bool {
        return !ignoredLiteralValues.contains(text)
    }
    
    private func extractTextEnvVariableName(text: String, tokenKind: TokenKind) -> String {
        let (startOffset, endOffset) = tokenKind.variableNameOffsets
        let startIndex = text.index(text.startIndex, offsetBy: startOffset)
        let endIndex = text.index(text.endIndex, offsetBy: -endOffset)
        return String(text[startIndex..<endIndex])
    }
    
}

private extension TokenSyntax {
    func with(envValue: String) -> TokenSyntax {
        switch tokenKind {
            case .stringLiteral:
                return withKind(.stringLiteral("\"\(envValue)\""))
            case .stringSegment:
                return withKind(.stringSegment("\(envValue)"))
            default:
                return self
        }
    }
}

private extension TokenKind {
    var envVarText: String?  {
        switch self {
            case .stringLiteral(let text):
                return text.matches(regex: stringLiteralEnvVarPattern) ? text : nil
            case .stringSegment(let text):
                return text.matches(regex: stringSegmentEnvVarPattern) ? text : nil
            default:
                return nil
        }
    }

    var variableNameOffsets: (Int, Int) {
        switch self {
            case .stringLiteral:
                return (3, 2)
            case .stringSegment:
                return (2, 1)
            default:
                return (0, 0)
        }
    }
}