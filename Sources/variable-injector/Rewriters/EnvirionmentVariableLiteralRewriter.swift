//
//  EnvirionmentVariableLiteralRewriter.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 02/11/18.
//

import Foundation
import SwiftSyntax

class EnvirionmentVariableLiteralRewriter: SyntaxRewriter {
    
    static let envVarPatter: String = "\"\\$\\(\\w+\\)\""
    
    var ignoredLiteralValues: Set<String> = []
    var includedLiteralValues: Set<String> = []
    
    convenience init(includedLiteralValues: [String], ignoredLiteralValues: [String]) {
        self.init()
        self.ignoredLiteralValues = Set(ignoredLiteralValues)
        self.includedLiteralValues = Set(includedLiteralValues)
    }
    
    override func visit(_ token: TokenSyntax) -> Syntax {
        guard case .stringLiteral(let text) = token.tokenKind else { return token }
    
        //Matching ENV var pattern e.g. $(ENV_VAR)
        guard text.matches(regex: EnvirionmentVariableLiteralRewriter.envVarPatter) else { return token }
        
        guard shouldPerformSubstitution(for: text) else { return token }
        
        let envVar = extractTextEnvVariableName(text: text)
        
        guard let envValue = ProcessInfo.processInfo.environment[envVar] else {
            return token
        }
        print("Injecting ENV_VAR: \(text), value: \(envValue)")
        return token.withKind(.stringLiteral("\"\(envValue)\""))
    }
    
    private func shouldPerformSubstitution(for text: String) -> Bool {
        return includedLiteralValues.contains(text) || !ignoredLiteralValues.contains(text)
    }
    
    private func extractTextEnvVariableName(text: String) -> String {
        return String(text[text.index(text.startIndex, offsetBy: 3)..<text.index(text.endIndex, offsetBy: -2)])
    }
    
}
