//
//  Utils.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public let propertyStorage = PropertyStorage()

public func synchronized(lock: NSObject, work: () -> Void) {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    work()
}

public func synchronized<T>(lock: NSObject, work: () -> T) -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return work()
}

internal func removeView(inout views: [View], view: View) {
    for i in 0..<views.count {
        if views[i] === view {
            views.removeAtIndex(i)
            break
        }
    }
}

internal func containsView(views: [View], view: View) -> Bool {
    for i in 0..<views.count {
        if views[i] === view {
            return true
        }
    }
    
    return false
}
