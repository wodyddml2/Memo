//
//  AppDelegate.swift
//  Memo
//
//  Created by J on 2022/08/31.
//

import UIKit

import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        aboutRealmMigration()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func aboutRealmMigration() {
        let config = Realm.Configuration(schemaVersion: 7) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: UserMemo.className()) { oldObject, newObject in
                    newObject!["memoDate"] = "\(oldObject!["memoDate"] ?? String.self)"
                }
            }
            
            if oldSchemaVersion < 2 { }
            
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: UserMemo.className()) { oldObject, newObject in
                    guard let new = newObject else {return}
                    
                    new["memoCount"] = 25
                }
            }
            
            if oldSchemaVersion < 4 {
                migration.renameProperty(onType: UserMemo.className(), from: "memoCount", to: "memoCurrent")
            }
            
            if oldSchemaVersion < 5 {
                migration.enumerateObjects(ofType: UserMemo.className()) { oldObject, newObject in
                    guard let new = newObject else {return}
                    guard let old = oldObject else {return}
                    
                    new["memoCurrent"] = old["memoCurrent"] ?? 1
                }
            }
            
            if oldSchemaVersion < 6 {
                migration.enumerateObjects(ofType: UserMemo.className()) { oldObject, newObject in
                    guard let new = newObject else {return}
                    guard let old = oldObject else {return}
                    
                    new["memoDescription"] = "\(old["memoTitle"]!), \(old["memoCurrent"]!)"
                }
            }
            
            if oldSchemaVersion < 7 { }
        }
        
        Realm.Configuration.defaultConfiguration = config
    }
}
