//
//  message.swift
//  pocket-ios-client
//
//  Created by Damien on 01/10/2018.
//  Copyright © 2018 Damien Inc. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    var receiver: Int
    var message: String
    var senderid: Int
    var sender_name: String
}
