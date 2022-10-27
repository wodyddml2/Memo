//
//  MemoTableViewCell.swift
//  Memo
//
//  Created by J on 2022/09/01.
//

import UIKit

class MemoTableViewCell: BaseTableViewCell {
    
    let memoTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()
    let memoDateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    let memoSubTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureUI() {
        [memoTitleLabel, memoDateLabel, memoSubTitleLabel].forEach {
            self.addSubview($0)
        }
    }
    override func prepareForReuse() {
        print("prepareForReuse")
    }
    
    override func setConstraints() {
        memoTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self).offset(-15)
            make.leading.equalTo(self).offset(20)
            make.trailing.lessThanOrEqualTo(self).offset(-10)
        }
        
        memoDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(20)
        }
        
        memoSubTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(memoDateLabel)
            make.leading.equalTo(memoDateLabel.snp.trailing).offset(15)
            make.trailing.lessThanOrEqualTo(self).offset(-10)
        }
    }
    
    
}
