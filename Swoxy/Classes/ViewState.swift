//
//  ViewState.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public protocol ViewState {
    var commands: ViewCommands { get set }
    var views: [View] { get set }
    var inRestoreState: [View] { get set }
    
    func attachView(view: View)
    func detachView(view: View)
    func restoreState(view: View)
    func isInRestoreState(view: View) -> Bool
}

public class MvpViewState: ViewState {
    public var commands: ViewCommands = ViewCommands()
    public var views: [View] = []
    public var inRestoreState: [View] = []
    
    private var lock = NSObject()
    
    public init() {
    }
    
    public func addCommand<Command: ViewCommand>(command: Command, action: (view: View) -> Void) {
        commands.beforeApply(command)
        
        if views.isEmpty {
            return
        }
        
        views.forEach { action(view: $0) }
        
        commands.afterApply(command)
    }
    
    public func restoreState(view: View) {
        if commands.isEmpty {
            return
        }
        
        commands.reapply(view)
    }
    
    public func attachView(view: View) {
        if containsView(views, view: view) {
            return
        }
        
        views.append(view)
        inRestoreState.append(view)
        
        restoreState(view)
        removeView(&inRestoreState, view: view)
    }
    
    public func detachView(view: View) {
        removeView(&views, view: view)
        removeView(&inRestoreState, view: view)
    }
    
    public func isInRestoreState(view: View) -> Bool {
        return containsView(inRestoreState, view: view)
    }
    
    private func containsView(views: [View], view: View) -> Bool {
        for i in 0..<views.count {
            if views[i] >!< view {
                return true
            }
        }
        
        return false
    }
    
    private func removeView(inout views: [View], view: View) {
        for i in 0..<views.count {
            if views[i] >!< view {
                views.removeAtIndex(i)
                break
            }
        }
    }
    
    deinit {
        views.removeAll()
        inRestoreState.removeAll()
    }
}
