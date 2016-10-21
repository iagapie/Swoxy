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
    
    func attach(view: View)
    func detach(view: View)
    func getViewState<T: View>() -> T?
    func contains(view: View) -> Bool
    func isRestoring(view: View) -> Bool
    func onDestroy()
}

open class MvpPresenter: Presenter {
    open var views: [View] = []
    open var viewState: ViewState?
    
    fileprivate var isFirstLaunch: Bool = true
    
    public init() {
    }
    
    open func attach(view: View) {
        if true != viewState?.attach(view: view) && !contains(view: view) {
            views.append(view)
        }
        
        if isFirstLaunch {
            isFirstLaunch = false
            onFirstAttach()
        }
    }
    
    open func onFirstAttach() {
    }
    
    open func detach(view: View) {
        if true != viewState?.detach(view: view) {
            remove(view: view)
        }
    }
    
    open func getViewState<T: View>() -> T? {
        return viewState as? T
    }
    
    open func isRestoring(view: View) -> Bool {
         return true == viewState?.isRestoring(view: view)
    }
    
    open func onDestroy() {
    }
    
    open func contains(view: View) -> Bool {
        return views.contains(where: { $0 >!< view })
    }
    
    fileprivate func remove(view: View) {
        if let i = views.index(where: { $0 >!< view }) {
            views.remove(at: i)
        }
    }
    
    deinit {
        viewState = nil
        views.removeAll()
    }
}
