//
//  Logger.swift
//  variable-injector-core
//
//  Created by Luciano Almeida on 04/11/18.
//

public class Logger {
    public init() {}
    
    public func log(message: @autoclosure () -> Any) {
      print(message())
    }
}
