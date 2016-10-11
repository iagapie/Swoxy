//
//  ViewController.swift
//  Swoxy
//
//  Created by Igor Agapie on 10/11/2016.
//  Copyright (c) 2016 Igor Agapie. All rights reserved.
//

import UIKit
import Swoxy

protocol TextView: View {
    func displayText(_ text: String)
}

class TextPresenter: MvpPresenter {
    init(viewState: TextViewState) {
        super.init()
        self.viewState = viewState
    }
    
    func echo(_ text: String) {
        let state: TextViewState? = getViewState()
        state?.displayText(text)
    }
}

class DisplayTextCommand: ViewCommand {
    fileprivate(set) var text: String!
    
    init(text: String) {
        super.init(tag: "displayText", stateStrategyType: AddToEndStrategy.self)
        self.text = text
    }
    
    override func apply(_ view: View) {
        super.apply(view)
        
        (view as? TextView)?.displayText(text)
    }
}

class TextViewState: MvpViewState, TextView {
    func displayText(_ text: String) {
        let command = DisplayTextCommand(text: text)
        commands.beforeApply(command)
        
        if views.isEmpty {
            return
        }
        
        views.forEach { ($0 as? TextView)?.displayText(text) }
        
        commands.afterApply(command)
    }
}

class ViewController: UIViewController, TextView, MvpView {
    @IBOutlet weak var textField: UITextField!
    
    var mvpDelegate: MvpDelegate! = MvpDelegate()
    var presenter: TextPresenter! = TextPresenter(viewState: TextViewState())
    
    var presenters: [Presenter] {
        return [presenter]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mvpDelegate.onCreate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mvpDelegate != nil {
            mvpDelegate.attachView()
        }
    }
    
    @IBAction func setTitleAction(_ sender: UIButton) {
        presenter.echo(textField.text!)
    }
    
    func displayText(_ text: String) {
        title = text
        navigationItem.title = text
    }
    
    deinit {
        mvpDelegate.detachView()
        mvpDelegate.onDestroy()
        mvpDelegate = nil
        presenter = nil
    }
}

