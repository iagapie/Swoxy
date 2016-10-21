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
    var inRestore: [View] { get set }
    
    func contains(view: View) -> Bool
    func attach(view: View) -> Bool
    func detach(view: View) -> Bool
    func restore(view: View)
    func isRestoring(view: View) -> Bool
}

open class MvpViewState: ViewState {
    open var commands: ViewCommands = ViewCommands()
    open var views: [View] = []
    open var inRestore: [View] = []
    
    public init() {
    }
    
    open func add<Command: ViewCommand>(command: Command, action: @escaping (_ view: View) -> Void) {
        commands.beforeApply(command)
        
        if views.isEmpty {
            return
        }
        
        views.forEach { action($0) }
        
        commands.afterApply(command)
    }
    
    open func restore(view: View) {
        if commands.isEmpty {
            return
        }
        
        commands.reapply(view)
    }
    
    open func attach(view: View) -> Bool {
        if contains(view: view) {
            return false
        }
        
        views.append(view)
        inRestore.append(view)
        
        restore(view: view)
        MvpViewState.remove(views: &inRestore, view: view)
        
        return true
    }
    
    open func detach(view: View) -> Bool {
        guard let i = views.index(where: { $0 >!< view }) else {
            return false
        }
        
        views.remove(at: i)
        MvpViewState.remove(views: &inRestore, view: view)
        
        return true
    }
    
    open func isRestoring(view: View) -> Bool {
        return MvpViewState.contains(views: inRestore, view: view)
    }
    
    open func contains(view: View) -> Bool {
        return MvpViewState.contains(views: views, view: view)
    }
    
    fileprivate static func contains(views: [View], view: View) -> Bool {
        return views.contains(where: { $0 >!< view })
    }
    
    fileprivate static func remove(views: inout [View], view: View) {
        if let i = views.index(where: { $0 >!< view }) {
            views.remove(at: i)
        }
    }
    
    deinit {
        views.removeAll()
        inRestore.removeAll()
    }
}
