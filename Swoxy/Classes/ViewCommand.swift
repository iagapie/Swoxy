//
//  ViewCommand.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

open class ViewCommand {
    open let stateStrategyType: StateStrategy.Type
    
    public init(stateStrategyType: StateStrategy.Type) {
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
        getStateStrategy(viewCommand).beforeApply(&state, viewCommand)
    }
    
    open func afterApply(_ viewCommand: ViewCommand) {
        getStateStrategy(viewCommand).afterApply(&state, viewCommand)
    }
    
    open func reapply(_ view: View) {
        Array(state).forEach {
            $0.apply(view)
            self.afterApply($0)
        }
    }
    
    fileprivate func getStateStrategy(_ viewCommand: ViewCommand) -> StateStrategy {
        if let strategy = strategies.first(where: { viewCommand.stateStrategyType == Mirror(reflecting: $0).subjectType }) {
            return strategy
        }
        
        let strategy = viewCommand.stateStrategyType.init()
        strategies.append(strategy)
        return strategy
    }
    
    deinit {
        state.removeAll()
    }
}
