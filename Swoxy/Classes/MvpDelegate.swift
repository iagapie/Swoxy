//
//  MvpDelegate.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public class MvpDelegate {
    private var isAttached: Bool = false
    private var delegated: View!
    
    public init() {
    }
    
    public func onCreate<V: View>(delegated: V) {
        self.delegated = delegated
        isAttached = false
    }
    
    public func attachView() {
        if delegated == nil {
            fatalError("You should call attachView() after onCreate(View)")
        }
        
        if isAttached {
            return
        }
        
        for presenter in delegated.presenters {
            if presenter.contains(delegated) {
                continue
            }
            
            presenter.attachView(delegated)
        }
        
        isAttached = true
    }
    
    public func detachView() {
        for presenter in delegated.presenters {
            presenter.detachView(delegated)
        }
        
        isAttached = false
    }
    
    public func onDestroy() {
        for presenter in delegated.presenters {
            presenter.onDestroy()
        }
        
        delegated = nil
    }
}
