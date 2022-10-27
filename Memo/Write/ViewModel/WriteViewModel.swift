//
//  WriteViewModel.swift
//  Memo
//
//  Created by J on 2022/10/16.
//

import UIKit

class WriteViewModel {
    let repository = UserMemoRepository()
    
    let memo = Observable(UserMemo())
}

extension WriteViewModel: ShowAlertProtocol {
    func fetchWriteMemo(title: String, subTitle: String, viewController: UIViewController) {
        do {
            try repository.updateWriteMemo {
                self.memo.value.memoDate = Date()
                self.memo.value.memoTitle = title
                self.memo.value.memoSubTitle = subTitle
            }
        } catch {
            viewController.present(showAlertMessage(title: "메모 수정에 실패했습니다."), animated: true)
        }
    }
}
