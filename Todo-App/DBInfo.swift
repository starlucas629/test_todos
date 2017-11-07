//
//  AppInfo.swift
//  Todo-App
//
//  Created by kerberos-mac on 9/16/17.
//  Copyright © 2017 kerberos-mac. All rights reserved.
//

import UIKit
import RealmSwift

class DBInfo: NSObject {
    static let shared = DBInfo()
    
    var realm: Realm!
    var selecetedObj: todoinfo!
    
//    var todoDatas = [TodoModel]()
    var isCreate = true
}
