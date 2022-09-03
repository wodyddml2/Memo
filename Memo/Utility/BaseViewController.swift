//
//  BaseViewController.swift
//  Memo
//
//  Created by J on 2022/09/01.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        
    }
    
    func setConstraints() {
        
    }
    func showAlertMessage(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    func showAlertHandlingMessage(title: String, button: String = "확인", completionHandelr: @escaping (UIAlertAction) -> ()) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .cancel, handler: completionHandelr)
        let cancle = UIAlertAction(title: "취소", style: .default)
        [ok, cancle].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
}
