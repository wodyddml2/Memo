//
//  MemoTableViewCell.swift
//  Memo
//
//  Created by J on 2022/09/01.
//

import UIKit

class MemoTableViewCell: BaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
