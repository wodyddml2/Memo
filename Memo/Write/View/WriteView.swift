//
//  WriteView.swift
//  Memo
//
//  Created by J on 2022/09/01.
//

import UIKit

import SnapKit

class WriteView: BaseView {
    let memoTextView: UITextView = {
        let view = UITextView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(memoTextView)
    }
    
    override func setConstraints() {
        memoTextView.snp.makeConstraints { make in
            make.bottom.top.trailing.leading.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

