//
//  MvpDelegate.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public class MvpDelegate {
    private let processor: MvpProcessor
    
    private var isAttached: Bool = false
    private weak var delegated: View!
    private var presenters: [Presenter] = []
    
    public init(processor: MvpProcessor) {
        self.processor = processor
    }
    
    public func onCreate<V: View>(delegated: V) {
        self.delegated = delegated
        isAttached = false
        presenters = processor.getMvpPresenters(delegated)
    }
    
    public func attachView() {
        if delegated == nil {
            fatalError("You should call attachView() after onCreate(View)")
        }
        
        if isAttached {
            return
        }
        
        for presenter in presenters {
            if presenter.contains(delegated) {
                continue
            }
            
            presenter.attachView(delegated)
        }
        
        isAttached = true
    }
    
    public func detachView() {
        for presenter in presenters {
            presenter.detachView(delegated)
        }
        
        isAttached = false
    }
    
    public func onDestroy() {
        for presenter in presenters {
            presenter.onDestroy()
        }
        
        presenters.removeAll()
        delegated = nil
    }
}
