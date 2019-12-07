//
//  String+Extensions.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 03/11/18.
//

public extension String {
  
  func matches(regex: String) -> Bool {
    return range(of: regex,
                 options: .regularExpression,
                 range: nil,
                 locale: nil) != nil
  }
  
  static func * (string: String, times: Int) -> String {
    var result: String = ""
    for _ in 0..<times {
      result.append(string)
    }
    return result
  }
}
