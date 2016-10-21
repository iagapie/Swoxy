//
//  PropertyStorage.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

open class PropertyStorage {
    fileprivate var items: [AnyHashable: [AnyHashable: Any]] = [:]
    
    internal subscript(obj: AnyHashable) -> [AnyHashable: Any]? {
        get {
            return items[obj]
        }
        
        set {
            items[obj] = newValue
        }
    }
    
    open subscript(obj: AnyHashable, property: AnyHashable) -> Any {
        get {
            return self[obj]?[property]
        }
        
        set {
            var data = self[obj] ?? [AnyHashable: Any]()
            data[property] = newValue
            self[obj] = data
        }
    }
    
    open func get<T>(_ obj: AnyHashable, _ property: String) -> T? {
        return self[obj, property] as? T
    }
    
    open func remove(_ obj: AnyHashable, _ property: AnyHashable) -> Any {
        return self[obj]?.removeValue(forKey: property)
    }
    
    open func remove<T>(_ obj: AnyHashable, _ property: String) -> T? {
        return remove(obj, property) as? T
    }
    
    open func remove(_ obj: AnyHashable) -> [AnyHashable: Any]? {
        return self.items.removeValue(forKey: obj)
    }
}
