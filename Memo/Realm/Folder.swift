//
//  Folder.swift
//  Memo
//
//  Created by J on 2022/10/17.
//

import Foundation

import RealmSwift

class Folder: Object {
    @Persisted var folderName: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(folderName: String) {
        self.init()
        self.folderName = folderName
    }
}
