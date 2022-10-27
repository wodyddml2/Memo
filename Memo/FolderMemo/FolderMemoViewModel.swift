//
//  FolderMemoViewModel.swift
//  Memo
//
//  Created by J on 2022/10/18.
//

import Foundation

import RealmSwift

class FolderMemoViewModel {
    
    var folder: Folder?
    
    var tasks: Observable<[UserMemo]> = Observable([UserMemo]())

}

extension FolderMemoViewModel {
    func fetch() {
        if let folder = folder {
            tasks.value.removeAll()
            let memo = folder.memo
            memo.forEach {
                tasks.value.append($0)
            }
        }
    }
}
