//
//  AppGroupRealmConfigurationFactory.swift
//  JustStudio
//
//  Created by Виктория on 12.04.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public class AppGroupRealmConfiguration {
    let appGroupIdentifier: String
    let fileManager: FileManager
    
    public init(appGroupIdentifier: String, fileManager: FileManager) {
        self.appGroupIdentifier = appGroupIdentifier
        self.fileManager = fileManager
    }
    
    public func createRealmConfiguration() -> Realm.Configuration {
        let databaseDirectoryPath = self.fileManager.containerURL(forSecurityApplicationGroupIdentifier: self.appGroupIdentifier)!
        let databasePath = databaseDirectoryPath.appendingPathComponent("databaseForJustFacts.realm")
        return Realm.Configuration(fileURL: databasePath)
    }
    
    public func updateDefaultRealmConfiguration() {
        Realm.Configuration.defaultConfiguration =
            self.createRealmConfiguration()
    }
}
