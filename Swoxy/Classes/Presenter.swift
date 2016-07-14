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

    private var firstLaunch: Bool = true
    
    public init() {
    }
    
    public func attachView(view: View) {
        if let viewState = viewState {
            viewState.attachView(view)
        } else {
            if !contains(view) {
                views.append(view)
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
            remove(view)
        }
    }
    
    public func getViewState<T: View>() -> T? {
        return viewState as? T
    }
    
    public func isInRestoreState(view: View) -> Bool {
        if let viewState = viewState {
            return viewState.isInRestoreState(view)
        }
        
        return false
    }
    
    public func onDestroy() {
    }
    
    public func contains(view: View) -> Bool {
        for i in 0..<views.count {
            if views[i] >!< view {
                return true
            }
        }
        
        return false
    }
    
    private func remove(view: View) {
        for i in 0..<views.count {
            if views[i] >!< view {
                views.removeAtIndex(i)
                break
            }
        }
    }
    
    deinit {
        viewState = nil
        views.removeAll()
    }
}
