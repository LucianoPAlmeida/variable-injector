//
//  ArgumentsHandler.swift
//  VariableInjector
//
//  Created by Luciano Almeida on 03/11/18.
//

struct ArgumentsHandler {
    var _parsedArgs: [Argument] = []
    
    init(args: [String]) {
        _parsedArgs = ArgumentsHandler.arguments(from: args)
    }
    
    func argumentValue(for arg: String) -> String? {
        return argumentValues(for: arg).first
    }
    
    func argumentValues(for arg: String) -> [String] {
        return _parsedArgs.first(where: { $0.name == arg })?.values ?? []
    }
    
    static func arguments(from args: [String]) -> [Argument] {
        var current: Argument!
        var arguments: [Argument] = []
        for arg in args {
            if arg.starts(with: "--") {
                if current != nil {
                    arguments.append(current)
                }
                var mutableArg = arg
                mutableArg.removeSubrange(...arg.index(arg.startIndex, offsetBy: 1))
                current = Argument(name: mutableArg)
            } else if current != nil {
                current.add(value: arg)
            }
        }
        return arguments
    }
}

struct Argument: Equatable, Hashable {
    private(set) var name: String
    private(set) var values: [String] = []
    
    init(name: String) {
        self.name = name
    }
    
    mutating func add(value: String) {
        self.values.append(value)
    }
    
}
