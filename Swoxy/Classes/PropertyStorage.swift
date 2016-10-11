//
//  PropertyStorage.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

open class PropertyStorage {
    fileprivate var items: [NSObject: [String: Any]] = [:]
    
    internal subscript(obj: NSObject) -> [String: Any]? {
        get {
            return items[obj]
        }
        
        set {
            items[obj] = newValue
        }
    }
    
    open subscript(obj: NSObject, property: String) -> Any {
        get {
            return self[obj]?[property]
        }
        
        set {
            var data = self[obj] ?? [String: Any]()
            data[property] = newValue
            self[obj] = data
        }
    }
    
    open func get<T>(_ obj: NSObject, _ property: String) -> T? {
        return self[obj, property] as? T
    }
    
    open func remove(_ obj: NSObject, _ property: String) -> Any {
        return self[obj]?.removeValue(forKey: property)
    }
    
    open func remove<T>(_ obj: NSObject, _ property: String) -> T? {
        return remove(obj, property) as? T
    }
    
    open func remove(_ obj: NSObject) -> [String: Any]? {
        return self.items.removeValue(forKey: obj)
    }
}
