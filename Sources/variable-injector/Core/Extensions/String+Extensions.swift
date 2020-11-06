//
//  String+Extensions.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 03/11/18.
//

public extension String {
  static func * (string: String, times: Int) -> String {
    var result: String = ""
    for _ in 0..<times {
      result.append(string)
    }
    return result
  }
}
