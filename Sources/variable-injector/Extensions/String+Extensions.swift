//
//  String+Extensions.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 03/11/18.
//

extension String {
    
    func matches(regex: String) -> Bool {
        return range(of: regex,
                     options: .regularExpression,
                     range: nil,
                     locale: nil) != nil
    }
}
