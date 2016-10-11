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
    
    func attachView(_ view: View)
    func detachView(_ view: View)
    func getViewState<T: View>() -> T?
    func contains(_ view: View) -> Bool
    func isInRestoreState(_ view: View) -> Bool
    func onDestroy()
}

open class MvpPresenter: Presenter {
    open var views: [View] = []
    open var viewState: ViewState?
    
    fileprivate var firstLaunch: Bool = true
    
    public init() {
    }
    
    open func attachView(_ view: View) {
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
    
    open func onFirstViewAttach() {
    }
    
    open func detachView(_ view: View) {
        if let viewState = viewState {
            viewState.detachView(view)
        } else {
            remove(view)
        }
    }
    
    open func getViewState<T: View>() -> T? {
        return viewState as? T
    }
    
    open func isInRestoreState(_ view: View) -> Bool {
        if let viewState = viewState {
            return viewState.isInRestoreState(view)
        }
        
        return false
    }
    
    open func onDestroy() {
    }
    
    open func contains(_ view: View) -> Bool {
        for i in 0..<views.count {
            if views[i] >!< view {
                return true
            }
        }
        
        return false
    }
    
    fileprivate func remove(_ view: View) {
        for i in 0..<views.count {
            if views[i] >!< view {
                views.remove(at: i)
                break
            }
        }
    }
    
    deinit {
        viewState = nil
        views.removeAll()
    }
}
