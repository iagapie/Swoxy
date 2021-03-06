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
    func beforeApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand)
    func afterApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand)
}

open class SkipStrategy: StateStrategy {
    public required init() {
        
    }
    
    open func beforeApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
    
    open func afterApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
}

open class SingleStateStrategy: StateStrategy {
    public required init() {
        
    }
    
    open func beforeApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand) {
        currentState.removeAll()
        currentState.append(incomingCommand)
    }
    
    open func afterApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
}

open class AddToEndStrategy: StateStrategy {
    public required init() {
        
    }
    
    open func beforeApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand) {
        currentState.append(incomingCommand)
    }
    
    open func afterApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
}

open class AddToEndSingleStrategy: StateStrategy {
    public required init() {
        
    }
    
    open func beforeApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand) {
        let type = Mirror(reflecting: incomingCommand).subjectType
        
        if let i = currentState.index(where: { type == Mirror(reflecting: $0).subjectType }) {
            currentState.remove(at: i)
        }
        currentState.append(incomingCommand)
    }
    
    open func afterApply(_ currentState: inout [ViewCommand], _ incomingCommand: ViewCommand) {
        
    }
}
