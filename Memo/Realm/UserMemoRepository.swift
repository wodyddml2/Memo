//
//  UserMemoRepository.swift
//  Memo
//
//  Created by J on 2022/09/01.
//

import Foundation

import RealmSwift

protocol UserMemoRepositoryType {
    func fetchMemoFilter() -> Results<UserMemo>
    func fetchFixedMemoFilter() -> Results<UserMemo>
}

class UserMemoRepository: UserMemoRepositoryType {
    
    let localRealm = try! Realm()
    
    func fetchMemoFilter() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).filter("memoFix == %@", false)
    }
    
    func fetchFixedMemoFilter() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).filter("memoFix == %@", true)
    }
    
    func updateFix(item: UserMemo) {
        try! localRealm.write {
            item.memoFix.toggle()
        }
    }
}
