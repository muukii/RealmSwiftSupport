//
//  MigrationReintroduceEmailTests.swift
//  RealmSwiftSupportTests
//
//  Created by Kenji Tayama on 2020/06/19.
//  Copyright © 2020 muukii. All rights reserved.
//

import XCTest
import RealmSwift

class User: RealmSwift.Object {
  @objc dynamic var name: String = ""
  @objc dynamic var email: String = ""
}

class ReintroduceEmailV1Tests: XCTestCase {

  override func setUp() {
    super.setUp()
    print(realmPath)
  }
  
  // MARK: Migration Tests
  
  func test() {
    
    let config = makeConfig(
      schemaVersion: 1, 
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in 
    })
    
    do {
      
      let realm = try Realm(configuration: config)
      
      try realm.throwableWrite { realm in
        let user = User()
        user.name = "John Appleseed"
        user.email = "john@example.com"
        realm.add(user)
      }
      
      XCTAssertEqual(realm.objects(User.self).count, 1)
      
    } catch {
      
      XCTFail("\(error)")
    }
  }
  
}
