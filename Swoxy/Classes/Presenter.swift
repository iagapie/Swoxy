//
//  Presenter.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public protocol Presenter {
    var views: [View] { get set }
    var viewState: ViewState? { get set }
    
    func attachView(view: View)
    func detachView(view: View)
    func getViewState<T: View>() -> T?
    func contains(view: View) -> Bool
    func isInRestoreState(view: View) -> Bool
    func onDestroy()
}

public class MvpPresenter: Presenter {    
    public var views: [View] = []
    public var viewState: ViewState?
    
    private var lock = NSObject()
    private var firstLaunch: Bool = true
    
    public init() {
    }
    
    public func attachView(view: View) {
        if let viewState = viewState {
            viewState.attachView(view)
        } else {
            synchronized(lock) {
                if !self.contains(view) {
                    self.views.append(view)
                }
            }
        }
        
        if firstLaunch {
            firstLaunch = false
            onFirstViewAttach()
        }
    }
    
    public func onFirstViewAttach() {
    }
    
    public func detachView(view: View) {
        if let viewState = viewState {
            viewState.detachView(view)
        } else {
            synchronized(lock) { removeView(&self.views, view: view) }
        }
    }
    
    public func getViewState<T: View>() -> T? {
        return viewState as? T
    }
    
    public func contains(view: View) -> Bool {
        return containsView(self.views, view: view)
    }
    
    public func isInRestoreState(view: View) -> Bool {
        if let viewState = viewState {
            return viewState.isInRestoreState(view)
        }
        
        return false
    }
    
    public func onDestroy() {
    }
    
    deinit {
        viewState = nil
        synchronized(lock) {
            self.views.removeAll()
        }
    }
}
