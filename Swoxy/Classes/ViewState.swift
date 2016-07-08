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
        synchronized(lock, work: {
            if containsView(self.views, view: view) {
                return
            }
            
            self.views.append(view)
            self.inRestoreState.append(view)
        })
        
        restoreState(view)
        
        synchronized(lock) {
            removeView(&self.inRestoreState, view: view)
        }
    }
    
    public func detachView(view: View) {
        synchronized(lock) {
            removeView(&self.views, view: view)
            removeView(&self.inRestoreState, view: view)
        }
    }
    
    public func isInRestoreState(view: View) -> Bool {
        return synchronized(lock, work: { containsView(self.inRestoreState, view: view) })
    }
    
    deinit {
        synchronized(lock) {
            self.views.removeAll()
        }
        synchronized(lock) {
            self.inRestoreState.removeAll()
        }
    }
}
