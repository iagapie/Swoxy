//
//  StateStrategy.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public protocol StateStrategy {
    init()
    func beforeApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand)
    func afterApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand)
}

public class SkipStrategy: StateStrategy {
    public required init() {
        
    }
    
    public func beforeApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
    
    public func afterApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
}

public class SingleStateStrategy: StateStrategy {
    public required init() {
        
    }
    
    public func beforeApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand) {
        currentState.removeAll()
        currentState.append(incomingCommand)
    }
    
    public func afterApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
}

public class AddToEndStrategy: StateStrategy {
    public required init() {
        
    }
    
    public func beforeApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand) {
        currentState.append(incomingCommand)
    }
    
    public func afterApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
}

public class AddToEndSingleStrategy: StateStrategy {
    public required init() {
        
    }
    
    public func beforeApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand) {
        let type = Mirror(reflecting: incomingCommand).subjectType
        for (i, command) in currentState.enumerate() {
            if Mirror(reflecting: command).subjectType == type {
                currentState.removeAtIndex(i)
                break
            }
        }
        currentState.append(incomingCommand)
    }
    
    public func afterApply(inout currentState: [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
}
