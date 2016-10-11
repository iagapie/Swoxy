//
//  MvpDelegate.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

open class MvpDelegate {
    fileprivate var isAttached: Bool = false
    fileprivate var mvpView: MvpView?
    fileprivate var delegated: View!
    
    public init() {
    }
    
    open func onCreate<V: View>(_ delegated: V) {
        self.delegated = delegated
        self.mvpView = delegated as? MvpView
        isAttached = false
    }
    
    open func attachView() {
        if delegated == nil {
            fatalError("You should call attachView() after onCreate(View)")
        }
        
        if isAttached {
            return
        }
        
        for presenter in mvpView?.presenters ?? [] {
            if presenter.contains(delegated) {
                continue
            }
            
            presenter.attachView(delegated)
        }
        
        isAttached = true
    }
    
    open func detachView() {
        for presenter in mvpView?.presenters ?? [] {
            presenter.detachView(delegated)
        }
        
        isAttached = false
    }
    
    open func onDestroy() {
        for presenter in mvpView?.presenters ?? [] {
            presenter.onDestroy()
        }
        
        mvpView = nil
        delegated = nil
    }
}
