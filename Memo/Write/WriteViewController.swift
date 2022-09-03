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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if mainView.memoTextView.text != "" {
                   if memoTasks != nil {
                   let task = UserMemo(memoTitle: mainView.memoTextView.text ?? "s", memoDate: Date(), memoSubTitle: mainView.memoTextView.text ?? "", memoFix: false)
                   
                   try! repository.localRealm.write {
                       self.repository.localRealm.add(task)
                   }
                   }
               } else {
                   if memoTasks != nil {
                       
                       repository.deleteMemo(item: memoTasks!)
                       
                   }
               }
        
    }
    override func configureUI() {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let okButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(okButtonClicked))
        
        navigationController?.navigationBar.tintColor = .orange
        
        mainView.memoTextView.delegate = self
        
        if memoTasks != nil {
            mainView.memoTextView.becomeFirstResponder()
           
            navigationItem.rightBarButtonItems = [okButton, shareButton]
   
        }
    }
    @objc func shareButtonClicked() {
      
        
    }
    
    @objc func okButtonClicked() {
       
        navigationController?.popViewController(animated: true)
    }
}

extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if memoTasks == nil {
            let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
            let okButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(okButtonClicked))
            navigationItem.rightBarButtonItems = [okButton, shareButton]
        }
    }
    
}
