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
    case .stringSegment(let text):
      return text
    default:
      return nil
    }
  }
  
  func byReplacingStringLiteral(string: String) -> TokenSyntax {
    switch tokenKind {
    case .stringSegment:
      return .stringSegment("\(string)")
    default:
      return self
    }
  }
}
