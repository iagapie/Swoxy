//
//  View.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public protocol View: class {
    var presenters: [Presenter] { get }
}

extension View {
    public var presenters: [Presenter] {
        return []
    }
}
