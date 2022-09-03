//
//  WriteViewController.swift
//  Memo
//
//  Created by J on 2022/08/31.
//

import UIKit

import RealmSwift

class WriteViewController: BaseViewController {

    let mainView = WriteView()
    
    let repository = UserMemoRepository()
    
    var memoTasks: UserMemo?

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func configureUI() {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let okButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(okButtonClicked))
        
        navigationItem.rightBarButtonItems = [okButton, shareButton]
        navigationController?.navigationBar.tintColor = .orange
        
        mainView.memoTextView.delegate = self
    }
    @objc func shareButtonClicked() {
      
        
    }
    
    @objc func okButtonClicked() {
        let task = UserMemo(memoTitle: mainView.memoTextView.text ?? "s", memoDate: Date(), memoSubTitle: "Ss", memoFix: false)
        
        do {
            try! repository.localRealm.write {
                self.repository.localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension WriteViewController: UITextViewDelegate {
    
}
