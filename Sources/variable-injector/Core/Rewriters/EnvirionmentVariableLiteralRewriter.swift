//
//  EnvirionmentVariableLiteralRewriter.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 02/11/18.
//

import Foundation
import SwiftSyntax

public class EnvirionmentVariableLiteralRewriter: SyntaxRewriter {
    
    static let envVarPatter: String = "\"\\$\\(\\w+\\)\""
    
    public var ignoredLiteralValues: Set<String> = []
    
    private var envirionment: [String: String] = [:]
    
    public init(envirionment: [String: String] = ProcessInfo.processInfo.environment) {
        self.envirionment = envirionment
    }
    
    public convenience init(
        envirionment: [String: String] = ProcessInfo.processInfo.environment,
        ignoredLiteralValues: [String]) {
        self.init(envirionment: envirionment)
        self.ignoredLiteralValues = Set(ignoredLiteralValues)
    }
    
    override public func visit(_ token: TokenSyntax) -> Syntax {
        guard case .stringLiteral(let text) = token.tokenKind else { return token }
    
        //Matching ENV var pattern e.g. $(ENV_VAR)
        guard text.matches(regex: EnvirionmentVariableLiteralRewriter.envVarPatter) else { return token }
        
        let envVar = extractTextEnvVariableName(text: text)
        
        guard shouldPerformSubstitution(for: envVar) else { return token }
        
        guard let envValue = envirionment[envVar] else {
            return token
        }
        print("Injecting ENV_VAR: \(text), value: \(envValue)")
        return token.withKind(.stringLiteral("\"\(envValue)\""))
    }
    
    private func shouldPerformSubstitution(for text: String) -> Bool {
        return !ignoredLiteralValues.contains(text)
    }
    
    private func extractTextEnvVariableName(text: String) -> String {
        return String(text[text.index(text.startIndex, offsetBy: 3)..<text.index(text.endIndex, offsetBy: -2)])
    }
    
}
