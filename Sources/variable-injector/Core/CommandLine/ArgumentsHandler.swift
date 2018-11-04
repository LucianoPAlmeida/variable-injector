//
//  ArgumentsHandler.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 03/11/18.
//
public struct ArgumentsHandler {
    internal(set) var _parsedArgs: [Argument] = []
    
    public init(args: [String]) {
        _parsedArgs = ArgumentsHandler.arguments(from: args)
    }
    
    public func contains(arg: String) -> Bool {
        return _parsedArgs.contains { $0.name == arg }
    }
    
    public func argumentValue(for arg: String) -> String? {
        return argumentValues(for: arg).first
    }
    
    public func argumentValues(for arg: String) -> [String] {
        return _parsedArgs.first(where: { $0.name == arg })?.values ?? []
    }
    
    private static func arguments(from args: [String]) -> [Argument] {
        var current: Argument!
        var arguments: [Argument] = []
        var idx = 0
        repeat {
            var arg = args[idx]
            if arg.starts(with: "--") {
                arg.removeSubrange(...arg.index(arg.startIndex, offsetBy: 1))
                current = Argument(name: arg)
                arguments.append(current)
            } else if current != nil {
                current.add(value: arg)
                arguments[arguments.endIndex.advanced(by: -1)] = current
            }
            idx+=1
        } while idx < args.count
        return arguments
    }
}

public struct Argument: Equatable {
    public private(set) var name: String
    public private(set) var values: [String] = []
    
    public init(name: String) {
        self.name = name
    }
    
    public init(name: String, values: [String]) {
        self.init(name: name)
        self.values = values
    }
    
    public mutating func add(value: String) {
        self.values.append(value)
    }
}
