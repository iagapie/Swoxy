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
    
    func attachView(_ view: View)
    func detachView(_ view: View)
    func restoreState(_ view: View)
    func isInRestoreState(_ view: View) -> Bool
}

open class MvpViewState: ViewState {
    open var commands: ViewCommands = ViewCommands()
    open var views: [View] = []
    open var inRestoreState: [View] = []
    
    public init() {
    }
    
    open func addCommand<Command: ViewCommand>(_ command: Command, action: @escaping (_ view: View) -> Void) {
        commands.beforeApply(command)
        
        if views.isEmpty {
            return
        }
        
        views.forEach { action($0) }
        
        commands.afterApply(command)
    }
    
    open func restoreState(_ view: View) {
        if commands.isEmpty {
            return
        }
        
        commands.reapply(view)
    }
    
    open func attachView(_ view: View) {
        if containsView(views, view: view) {
            return
        }
        
        views.append(view)
        inRestoreState.append(view)
        
        restoreState(view)
        removeView(&inRestoreState, view: view)
    }
    
    open func detachView(_ view: View) {
        removeView(&views, view: view)
        removeView(&inRestoreState, view: view)
    }
    
    open func isInRestoreState(_ view: View) -> Bool {
        return containsView(inRestoreState, view: view)
    }
    
    fileprivate func containsView(_ views: [View], view: View) -> Bool {
        for i in 0..<views.count {
            if views[i] >!< view {
                return true
            }
        }
        
        return false
    }
    
    fileprivate func removeView(_ views: inout [View], view: View) {
        for i in 0..<views.count {
            if views[i] >!< view {
                views.remove(at: i)
                break
            }
        }
    }
    
    deinit {
        views.removeAll()
        inRestoreState.removeAll()
    }
}
