//
//  FolderMemoViewModel.swift
//  Memo
//
//  Created by J on 2022/10/18.
//

import Foundation

import RealmSwift

class FolderMemoViewModel {
    
    let repository = FolderRepository()
    
    var folder: Folder?
    
    var tasks: Observable<[UserMemo]> = Observable([UserMemo]())

}

extension FolderMemoViewModel {
    func fetch() {
        if let folder = folder {
            tasks.value.removeAll()
            let memo = repository.fetchMemo(folder: folder)
            memo.forEach {
                tasks.value.append($0)
            }
        }
    }
}
