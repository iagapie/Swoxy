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
    fileprivate weak var view: MvpView?
    
    public init() {
    }
    
    open func onCreate<V: MvpView>(_ view: V) {
        self.view = view
        isAttached = false
    }
    
    open func attachView() {
        guard let view = self.view else {
            fatalError("You should call attachView() after onCreate(View)")
        }
        
        guard false == isAttached else {
            return
        }
        
        view.presenters.forEach { $0.attach(view: view) }
        
        isAttached = true
    }
    
    open func detachView() {
        guard let view = self.view else {
            return
        }
        
        view.presenters.forEach { $0.detach(view: view) }
        
        isAttached = false
    }
    
    open func onDestroy() {
        guard let view = self.view else {
            return
        }
        
        if isAttached {
            detachView()
        }
        
        view.presenters.forEach { $0.onDestroy() }
        
        self.view = nil
    }
}
