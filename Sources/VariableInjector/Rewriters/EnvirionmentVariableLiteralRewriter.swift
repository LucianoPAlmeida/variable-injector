//
//  EnvirionmentVariableLiteralRewriter.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 02/11/18.
//

import Foundation
import SwiftSyntax

class EnvirionmentVariableLiteralRewriter: SyntaxRewriter {
    
    var ignoredLiteralVariables: Set<String> = []
    var includedLiteralVariables: Set<String> = []
    
    override func visit(_ token: TokenSyntax) -> Syntax {
        guard case .stringLiteral(let text) = token.tokenKind else { return token }
        
        print("String literal: \(text)")
        
        //Matching ENV var pattern e.g. $(ENV_VAR)
        guard text.matches(regex: "\"\\$\\(\\w+\\)\"") else { return token }
        
        guard shouldPerformSubstitution(for: text) else { return token }
        
        let envVar = extractTextEnvVariableName(text: text)
        
        guard let envValue = ProcessInfo.processInfo.environment[envVar] else {
            return token
        }
    
        return token.withKind(.stringLiteral("\"\(envValue)\""))
    }
    
    private func shouldPerformSubstitution(for text: String) -> Bool {
        return includedLiteralVariables.contains(text) || !ignoredLiteralVariables.contains(text)
    }
    
    private func extractTextEnvVariableName(text: String) -> String {
        return String(text[text.index(text.startIndex, offsetBy: 3)..<text.index(text.endIndex, offsetBy: -2)])
    }
    
}
