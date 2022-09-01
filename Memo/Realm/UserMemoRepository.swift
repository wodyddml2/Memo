//
//  UserMemoRepository.swift
//  Memo
//
//  Created by J on 2022/09/01.
//

import Foundation

import RealmSwift

protocol UserMemoRepositoryType {
    func fetch() -> Results<UserMemo>
}

class UserMemoRepository: UserMemoRepositoryType {
    let localRealm = try! Realm()
    
    func fetch() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self)
    }
    
    func updateFix(item: UserMemo) {
        try! localRealm.write {
            item.memoFix.toggle()
        }
    }
}
