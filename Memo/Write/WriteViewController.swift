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

    var memoTitle: String?
    var memoSubTitle: String?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTitle = memoTasks?.memoTitle
        memoSubTitle = memoTasks?.memoSubTitle
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if mainView.memoTextView.text != "" {
            if memoTasks != nil {
                
                do {
                    try repository.localRealm.write {
                        memoTasks?.memoDate = Date()
                        memoTasks?.memoTitle = memoTitle ?? ""
                        memoTasks?.memoSubTitle = memoSubTitle ?? ""
                      
                    }
                } catch let error{
                    print(error)
                }
                
               
            } else {
               
                let task = UserMemo(memoTitle: memoTitle ?? "", memoDate: Date(), memoSubTitle: memoSubTitle ?? "", memoFix: false)
                
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
        mainView.memoTextView.text = "\(memoTasks?.memoTitle ?? "")\(memoTasks?.memoSubTitle ?? "")"
        
        if memoTasks != nil {
            mainView.memoTextView.becomeFirstResponder()
           
            navigationItem.rightBarButtonItems = [okButton, shareButton]
   
        }
        
    }
    @objc func shareButtonClicked() {
      
        guard let memo = mainView.memoTextView.text else {
            return
        }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        vc.excludedActivityTypes = [.mail, .message, .postToTwitter, .airDrop]
           
           self.present(vc, animated: true)

        
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

    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.contains("\n") {
            memoSubTitle = textView.text
            memoSubTitle?.removeFirst(memoTitle?.count ?? 0)
        } else {
            memoTitle = textView.text
            
        }
    }
}
