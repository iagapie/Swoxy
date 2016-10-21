//
//  View.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public protocol View: class {
}

public protocol MvpView: View {
    var presenters: [Presenter] { get }
}
