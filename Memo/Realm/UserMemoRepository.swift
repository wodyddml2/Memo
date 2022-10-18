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
    
    
    
    lazy var localRealm = try! Realm()
    
    func fetch() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self)
    }
    
    func fetchMemoFilter() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).filter("memoFix == %@", false)
    }
    
    func fetchFixedMemoFilter() -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).filter("memoFix == %@", true)
    }
    
    func fetchSearchFilter(text: String) -> Results<UserMemo> {
        return localRealm.objects(UserMemo.self).where {
            $0.memoTitle.contains(text, options: .caseInsensitive) || $0.memoSubTitle.contains(text, options: .caseInsensitive)
        }
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
    
    func addMemo(item: UserMemo) throws {
        try localRealm.write {
            localRealm.add(item)
        }
    }
    
    func updateWriteMemo(completionHandler: @escaping () -> Void) throws {
        try localRealm.write {
            completionHandler()
        }
    }
}

class FolderRepository {
    
    let localRealm = try! Realm()
    
    func fetch() -> Results<Folder> {
        return localRealm.objects(Folder.self)
    }
    
    func fetchMemo(folder: Folder) -> List<UserMemo> {
        return folder.memo
    }
    
    func addFolder(item: Folder) throws {
        try localRealm.write({
            localRealm.add(item)
        })
    }
    
    func appendMemo(folder: Folder, item: UserMemo) throws {
        try localRealm.write({
            folder.memo.append(item)
        })
    }

}
