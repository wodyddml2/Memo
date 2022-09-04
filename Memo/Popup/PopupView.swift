//
//  PopupView.swift
//  Memo
//
//  Created by J on 2022/09/01.
//

import UIKit

class PopupView: BaseView {
    
    let popUpbackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    let okButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    let okButtonLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.textColor = .white
        view.text = "확인"
        return view
    }()
    let okButton: UIButton = {
        let view = UIButton()
        view.setTitle("", for: .normal)
        return view
    }()
    
    let firstOnboardingLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .white
        view.text =
        """
        처음 오셨군요!
        환영합니다 :)
        """
        view.numberOfLines = 0
        return view
    }()
    let secondOnboardingLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .white
        view.text =
        """
        당신만의 메모를 작성하고
        관리해보세요!
        """
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(popUpbackgroundView)
        [okButtonView, okButtonLabel, okButton, firstOnboardingLabel, secondOnboardingLabel].forEach {
            popUpbackgroundView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        popUpbackgroundView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(UIScreen.main.bounds.width / 1.4)
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        firstOnboardingLabel.snp.makeConstraints { make in
            make.leading.equalTo(okButtonView.snp.leading)
            make.top.equalTo(30)
        }
        
        secondOnboardingLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstOnboardingLabel.snp.leading)
            make.top.equalTo(firstOnboardingLabel.snp.bottom).offset(30)
        }
        
        okButtonView.snp.makeConstraints { make in
            make.width.equalTo(popUpbackgroundView.snp.width).multipliedBy(0.8)
            make.height.equalTo(popUpbackgroundView.snp.height).multipliedBy(0.2)
            make.centerX.equalTo(popUpbackgroundView)
            make.bottom.equalTo(popUpbackgroundView.snp.bottom).offset(-20)
        }
        
        okButtonLabel.snp.makeConstraints { make in
            make.center.equalTo(okButtonView)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(okButtonView)
        }
    }
}
