//
//  Utils.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public let propertyStorage = PropertyStorage()

infix operator >!< {}

internal func >!< (object1: AnyObject!, object2: AnyObject!) -> Bool {
    return (object_getClassName(object1) == object_getClassName(object2))
}
