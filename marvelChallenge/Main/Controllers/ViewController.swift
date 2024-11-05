//
//  ViewController.swift
//  marvelChallenge
//
//  Created by MacBook Pro on 04/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var mainScreen: MainView = {
        let view = MainView()
        view.delegate = self
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Marvel Challenge"
        initView()
    }
    
    func initView() {
        mainScreen.setup(labelText: "Main Screen", buttonTitle: "Button Click")
    }
}

extension ViewController: ViewDelegate {
    func didTapButton() {
        debugPrint("Delegate ok")
    }
}
