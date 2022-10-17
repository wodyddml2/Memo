//
//  WriteViewController.swift
//  Memo
//
//  Created by J on 2022/08/31.
//

import UIKit

import RealmSwift

class WriteViewController: BaseViewController {
    
    private let mainView = WriteView()
    
    let viewModel = WriteViewModel()
    
    private let repository = UserMemoRepository()
    
    var memoTasks: UserMemo?
    
    private var memoTitle: String?
    private var memoSubTitle: String?
    
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
                do {
                    try repository.localRealm.write {
                        memoTasks?.memoDate = Date()
                        memoTasks?.memoTitle = memoTitle ?? ""
                        memoTasks?.memoSubTitle = memoSubTitle ?? ""
                    }
                } catch {
                    showAlertMessage(title: "메모 수정에 실패했습니다.")
                }
            } else {
                let task = UserMemo(memoTitle: memoTitle ?? "", memoDate: Date(), memoSubTitle: memoSubTitle ?? "", memoFix: false)
                
                do {
                    try repository.localRealm.write {
                        self.repository.localRealm.add(task)
                    }
                } catch {
                    showAlertMessage(title: "메모 저장에 실패했습니다.")
                }
            }
        } else {
            if memoTasks != nil {
                repository.deleteMemo(item: memoTasks!)
            }
        }
    }
    override func configureUI() {
        
        memoTitle = memoTasks?.memoTitle
        memoSubTitle = memoTasks?.memoSubTitle
        
        mainView.memoTextView.delegate = self
        mainView.memoTextView.text = "\(memoTasks?.memoTitle ?? "")\(memoTasks?.memoSubTitle ?? "")"
        
        navigationController?.navigationBar.tintColor = .orange
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let okButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(okButtonClicked))
        
        if memoTasks != nil {
            mainView.memoTextView.becomeFirstResponder()
            navigationItem.rightBarButtonItems = [okButton, shareButton]
        }
        
    }
    @objc func shareButtonClicked() {
        
        guard let memo = mainView.memoTextView.text else { return }
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
