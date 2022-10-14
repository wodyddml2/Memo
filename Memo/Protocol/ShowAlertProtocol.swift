//
//  ShowAlertProtocol.swift
//  Memo
//
//  Created by J on 2022/10/14.
//

import UIKit

protocol ShowAlertProtocol { }

extension ShowAlertProtocol {
    func showAlertMessage(title: String, button: String = "확인") -> UIAlertController{
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
    return alert
    }
}
