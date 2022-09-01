//
//  ReusableProtocol.swift
//  Memo
//
//  Created by J on 2022/09/01.
//

import UIKit

protocol ReusableIdentifier {
    static var reuseableIdentifier: String { get }
}

extension UIViewController: ReusableIdentifier {
    static var reuseableIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableIdentifier {
    static var reuseableIdentifier: String {
        return String(describing: self)
    }
}
