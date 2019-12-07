//
//  String+Extensions.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 06/12/19.
//

import SwiftSyntax

extension TokenSyntax {
  var stringLiteral: String? {
    switch tokenKind {
    case .stringLiteral(let text), .stringSegment(let text):
      return text
    default:
      return nil
    }
  }
  
  func byReplacingStringLiteral(string: String) -> TokenSyntax {
    switch tokenKind {
    case .stringLiteral:
      return withKind(.stringLiteral("\"\(string)\""))
    case .stringSegment:
      return withKind(.stringSegment("\(string)"))
    default:
      return self
    }
  }
    
}
