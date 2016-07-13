//
//  ViewController.swift
//  Swoxy
//
//  Created by Igor Agapie on 07/05/2016.
//  Copyright (c) 2016 Igor Agapie. All rights reserved.
//

import UIKit
import Swoxy
import Swinject

extension SwinjectStoryboard {
    static func setup() {
        defaultContainer.registerForStoryboard(ViewController.self, name: "ViewController") { r, c in
            c.mvpDelegate = r.resolve(MvpDelegate.self)!
            c.presenter = r.resolve(MvpPresenter.self) as! TextPresenter
        }
        
        defaultContainer.register(MvpDelegate.self) { _ in MvpDelegate() }
        
        defaultContainer.register(MvpPresenter.self) { TextPresenter(viewState: $0.resolve(TextViewState.self)!) }.inObjectScope(.Container)
        
        defaultContainer.register(TextViewState.self) { _ in TextViewState() }.inObjectScope(.Container)
    }
}

protocol TextView: View {
    func displayText(text: String)
}

class TextPresenter: MvpPresenter {
    init(viewState: TextViewState) {
        super.init()
        self.viewState = viewState
    }
    
    func echo(text: String) {
        let state: TextViewState? = getViewState()
        state?.displayText(text)
    }
}

class DisplayTextCommand: ViewCommand {
    private(set) var text: String!
    
    init(text: String) {
        super.init(tag: "displayText", stateStrategyType: AddToEndStrategy.self)
        self.text = text
    }
    
    override func apply(view: View) {
        super.apply(view)
        
        (view as? TextView)?.displayText(text)
    }
}

class TextViewState: MvpViewState, TextView {
    func displayText(text: String) {
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
    
    var mvpDelegate: MvpDelegate!
    var presenter: TextPresenter!
    
    var presenters: [Presenter] {
        return [presenter]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mvpDelegate.onCreate(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if mvpDelegate != nil {
            mvpDelegate.attachView()
        }
    }
    
    @IBAction func setTitleAction(sender: UIButton) {
        presenter.echo(textField.text!)
    }
    
    func displayText(text: String) {
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

