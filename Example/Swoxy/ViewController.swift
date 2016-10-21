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
    override init() {
        super.init()
        self.viewState = TextViewState()
    }
    
    func echo(_ text: String) {
        let state: TextViewState? = getViewState()
        state?.displayText(text)
    }
}

class DisplayTextCommand: ViewCommand {
    fileprivate(set) var text: String!
    
    init(text: String) {
        super.init(stateStrategyType: AddToEndStrategy.self)
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
    
    var mvpDelegate: MvpDelegate?
    
    var presenter: TextPresenter {
        return (UIApplication.shared.delegate as! AppDelegate).presenter
    }
    
    var presenters: [Presenter] {
        return [presenter]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mvpDelegate = MvpDelegate()
        mvpDelegate?.onCreate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mvpDelegate?.attachView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mvpDelegate?.detachView()
    }
    
    @IBAction func setTitleAction(_ sender: UIButton) {
        presenter.echo(textField.text!)
    }
    
    func displayText(_ text: String) {
        title = text
        navigationItem.title = text
    }
    
    deinit {
        mvpDelegate?.onDestroy()
        mvpDelegate = nil
    }
}

