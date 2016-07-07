//
//  PropertyStorage.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public class PropertyStorage {
    private var items: [NSObject: [String: Any]] = [:]
    
    internal subscript(obj: NSObject) -> [String: Any]? {
        get {
            return items[obj]
        }
        
        set {
            items[obj] = newValue
        }
    }
    
    public subscript(obj: NSObject, property: String) -> Any {
        get {
            return self[obj]?[property]
        }
        
        set {
            var data = self[obj] ?? [String: Any]()
            data[property] = newValue
            self[obj] = data
        }
    }
    
    public func get<T>(obj: NSObject, _ property: String) -> T? {
        return self[obj, property] as? T
    }
    
    public func remove(obj: NSObject, _ property: String) -> Any {
        return self[obj]?.removeValueForKey(property)
    }
    
    public func remove<T>(obj: NSObject, _ property: String) -> T? {
        return remove(obj, property) as? T
    }
    
    public func remove(obj: NSObject) -> [String: Any]? {
        return self.items.removeValueForKey(obj)
    }
}
