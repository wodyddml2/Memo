//
//  FolderViewModel.swift
//  Memo
//
//  Created by J on 2022/10/18.
//

import Foundation

import RealmSwift

class FolderViewModel {
    
    let repository = FolderRepository()
    
    var tasks = Observable([Folder]())
   
}

extension FolderViewModel {
    func fetch() {
        tasks.value.removeAll()
        let folder = repository.fetch()
        
        folder.forEach {
            tasks.value.append($0)
        }
    }
}
