//
//  Utils.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public let propertyStorage = PropertyStorage()

infix operator >!<

internal func >!< (obj1: Any, obj2: Any) -> Bool {
    return object_getClassName(obj1) == object_getClassName(obj2)
}
