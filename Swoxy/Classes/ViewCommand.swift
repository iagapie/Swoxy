//
//  ViewCommand.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

open class ViewCommand {
    open fileprivate(set) var tag: String
    open fileprivate(set) var stateStrategyType: StateStrategy.Type
    
    public init(tag: String, stateStrategyType: StateStrategy.Type) {
        self.tag = tag
        self.stateStrategyType = stateStrategyType
    }
    
    open func apply(_ view: View) {
        
    }
}

open class ViewCommands {
    fileprivate var state: [ViewCommand] = []
    fileprivate var strategies: [StateStrategy] = []
    
    public init() {
    }
    
    open var isEmpty: Bool {
        return state.isEmpty
    }
    
    open func beforeApply(_ viewCommand: ViewCommand) {
        let stateStrategy = getStateStrategy(viewCommand)
        stateStrategy.beforeApply(&state, viewCommand)
    }
    
    open func afterApply(_ viewCommand: ViewCommand) {
        let stateStrategy = getStateStrategy(viewCommand)
        stateStrategy.afterApply(&state, viewCommand)
    }
    
    open func reapply(_ view: View) {
        for command in Array(state) {
            command.apply(view)
            afterApply(command)
        }
    }
    
    fileprivate func getStateStrategy(_ viewCommand: ViewCommand) -> StateStrategy {
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
