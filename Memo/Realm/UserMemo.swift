//
//  RealmModel.swift
//  Memo
//
//  Created by J on 2022/09/01.
//

import Foundation

import RealmSwift

class UserMemo: Object {
    @Persisted var memoTitle: String
    @Persisted var memoDate = Date()
    @Persisted var memoSubTitle: String?
    @Persisted var memoFix: Bool
    
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(memoTitle: String, memoDate: Date, memoSubTitle: String?, memoFix: Bool) {
        self.init()
        self.memoTitle = memoTitle
        self.memoDate = memoDate
        self.memoSubTitle = memoSubTitle
        self.memoFix = false
    }
}
