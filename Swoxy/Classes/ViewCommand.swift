//
//  ViewCommand.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public class ViewCommand {
    public private(set) var tag: String
    public private(set) var stateStrategyType: StateStrategy.Type
    
    public init(tag: String, stateStrategyType: StateStrategy.Type) {
        self.tag = tag
        self.stateStrategyType = stateStrategyType
    }
    
    public func apply(view: View) {
        
    }
}

public class ViewCommands {
    private var state: [ViewCommand] = []
    private var strategies: [StateStrategy] = []
    
    public init() {
    }
    
    public var isEmpty: Bool {
        return state.isEmpty
    }
    
    public func beforeApply(viewCommand: ViewCommand) {
        let stateStrategy = getStateStrategy(viewCommand)
        stateStrategy.beforeApply(&state, viewCommand)
    }
    
    public func afterApply(viewCommand: ViewCommand) {
        let stateStrategy = getStateStrategy(viewCommand)
        stateStrategy.afterApply(&state, viewCommand)
    }
    
    public func reapply(view: View) {
        for command in Array(state) {
            command.apply(view)
            afterApply(command)
        }
    }
    
    private func getStateStrategy(viewCommand: ViewCommand) -> StateStrategy {
        for strategy in strategies {
            if Mirror(reflecting: strategy).subjectType == viewCommand.stateStrategyType {
                return strategy
            }
        }
        
        let strategy = viewCommand.stateStrategyType.init()
        strategies.append(strategy)
        return strategy
    }
    
    deinit {
        state.removeAll()
    }
}
