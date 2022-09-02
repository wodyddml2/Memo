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
    func fetchMemoFilter() -> Results<UserMemo>
    func fetchFixedMemoFilter() -> Results<UserMemo>
}

class UserMemoRepository: UserMemoRepositoryType {
    
    let config = Realm.Configuration(schemaVersion: 1) { migration, oldSchemaVersion in
        if oldSchemaVersion < 1 {
            migration.enumerateObjects(ofType: UserMemo.className()) { oldObject, newObject in
                newObject!["memoDate"] = "\(oldObject!["memoDate"] ?? String.self)"
            }
        }
    }
    
    lazy var localRealm = try! Realm(configuration: config)
    
    func fetch() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self)
    }
    
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
    
    func deleteMemo(item: UserMemo) {
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
}
