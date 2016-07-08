//
//  MvpProcessor.swift
//  Pods
//
//  Created by Igor Agapie on 06/07/2016.
//
//

import Foundation

public protocol MvpProcessor {
    func getMvpPresenters<T: View>(delegated: T) -> [Presenter]
}