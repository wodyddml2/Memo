//
//  PopupViewController.swift
//  Memo
//
//  Created by J on 2022/08/31.
//

import UIKit

class PopupViewController: BaseViewController {

    var mainView = PopupView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.layer.backgroundColor = UIColor.black.cgColor.copy(alpha: 0.5)
        mainView.okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
    }
    
    @objc func okButtonClicked() {
        
        UserDefaults.standard.set(true, forKey: "pop")
        self.dismiss(animated: true)
    }


}
