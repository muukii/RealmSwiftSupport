//
//  MigrationV1Tests.swift
//  RealmSwiftSupportTests
//
//  Created by Kenji Tayama on 2020/06/18.
//  Copyright © 2020 muukii. All rights reserved.
//

import XCTest
import RealmSwift

fileprivate class User: RealmSwift.Object {
  @objc dynamic var firstName: String = ""
  @objc dynamic var lastName: String = ""
  @objc dynamic var email: String = ""
}

class MigrationV1Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

//    func testV1() {
//
//      let config = makeRealmConfig(
//        fileURL: migrationTestsRealmPath,
//        schemaVersion: 1, 
//        objectTypes: [User.self], 
//        migrationBlock: { migration, oldSchemaVersion in 
//      })
//
//      do {
//
//        let realm = try Realm(configuration: config)
//
//        try realm.throwableWrite { realm in
//          let user = User()
//          user.firstName = "John"
//          user.lastName = "Appleseed"
//          user.email = "john@example.com"
//          realm.add(user)
//        }
//
//        XCTAssertEqual(realm.objects(User.self).count, 1)
//
//      } catch {
//
//        XCTFail("\(error)")
//      }
//    }

}
