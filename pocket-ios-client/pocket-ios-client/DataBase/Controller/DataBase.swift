//
//  DataBase.swift
//  pocket-ios-client
//
//  Created by Mak on 05/12/2018.
//  Copyright © 2018 Damien Inc. All rights reserved.
//

import Foundation
import RealmSwift

class DataBase {
    
    func saveSelfUser(json: Data) {
        do {
            let sJSON = try JSONDecoder().decode(SelfAccount.self, from: json)
            let sDB = loadSelfUser()
            let selfInf = SelfAccount.init(
                uid: sJSON.uid,
                accountName: sDB.accountName,
                email: sJSON.email,
                password: sDB.password
            )
            AdaptationDBJSON().saveInDB([selfInf])
        }
        catch let err {
            print("Err", err)
        }       
    }
    
    func loadSelfUser() -> SelfAccount {
        let smInfoFromDB = AdaptationDBJSON().loadFromDB(smTableDB: SelfAccount.self)
        return smInfoFromDB[0]
    }
    
    func observerSelfUser() -> NotificationToken? {
        let smInfoFromDB = AdaptationDBJSON().loadFromDB(smTableDB: SelfAccount.self)
        return AdaptationDBJSON().realmObserver(smTableDB: smInfoFromDB) { (changes) in
            switch changes {
            case .initial, .update:
                print("Load self data")
            case .error(let error):
                print(error)
            }
        }
    }
    
    func saveContacts(json: Data) {
        let selfInfo = loadSelfUser()
        do {
            let data = try JSONDecoder().decode([ContactAccount].self, from: json)
            let contacts = data.filter { $0.email != selfInfo.email }
            AdaptationDBJSON().saveInDB(contacts)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func observerContacts(complition: @escaping (RealmCollectionChange<Results<ContactAccount>>) -> Void) -> NotificationToken? {
        
        let smInfoFromDB = AdaptationDBJSON().loadFromDB(smTableDB: ContactAccount.self)
        return AdaptationDBJSON().realmObserver(smTableDB: smInfoFromDB) { (changes) in
            complition(changes)
        }
    }
    
    func loadContactsList() -> Results<ContactAccount> {
        return AdaptationDBJSON().loadFromDB(smTableDB: ContactAccount.self)
    }
    
    func loadOneContactsList(userId: Int) -> Results<ContactAccount> {
        return AdaptationDBJSON().loadOneRecordFromDB(smTableDB: ContactAccount.self, filter: "uid == \(userId)")
    }
    
    func loadChatList() -> Results<Chat> {
        return AdaptationDBJSON().loadFromDB(smTableDB: Chat.self)
    }
    
    func saveMessages(message: [Chat], filter: String?) {
        if let fltr = filter, fltr != "" {
//           AdaptationDBJSON().editRecord(smTableDB: Chat.self, smRecord: message, filter: fltr)
        } else {
            AdaptationDBJSON().saveInDB(message)
        }
    }
}
