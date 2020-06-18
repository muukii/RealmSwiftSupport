//
//  MigrationTests.swift
//  RealmSwiftSupportTests
//
//  Created by muukii on 2020/06/13.
//  Copyright © 2020 muukii. All rights reserved.
//

import XCTest
import RealmSwift

enum Schema {

  enum V1 {

    @objc(User)
    class User: RealmSwift.Object {
      @objc dynamic var firstName: String = ""
      @objc dynamic var lastName: String = ""
    }
  }

  enum V2 {
    @objc(User)
    class User: RealmSwift.Object {
      @objc dynamic var firstName: String = ""
      @objc dynamic var lastName: String = ""
      let age: RealmOptional<Int> = .init(nil)
    }
  }

  enum V3 {
    @objc(User)
    class User: RealmSwift.Object {
      @objc dynamic var name: String = ""
      let age: RealmOptional<Int> = .init(nil)
    }
  }

  typealias Current = V1
}

private var rootDirectoryPath: String {
  let root = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
  return (root as NSString).appendingPathComponent(Bundle.main.bundleIdentifier!)
}

func makeTempPath(identifier: String) -> URL {

  let path = rootDirectoryPath + "/\(identifier)"

  makeDirectory: do {
    try FileManager.default.createDirectory(atPath: rootDirectoryPath, withIntermediateDirectories: true, attributes: [:])
  } catch {
    fatalError("Failed to create directory Path: \(path)")
  }

  return URL(fileURLWithPath: path)
}

class MigrationTests: XCTestCase {

  let path = makeTempPath(identifier: "\(UUID().uuidString).realm")

  override func setUp() {
    super.setUp()
    print(path)
  }

  func testInit() {

    let v1 = Realm.Configuration(
      fileURL: path,
      inMemoryIdentifier: nil,
      syncConfiguration: nil,
      encryptionKey: nil,
      readOnly: false,
      schemaVersion: 1,
      migrationBlock: { migration, _ in
        migration
    }, deleteRealmIfMigrationNeeded: false,
       shouldCompactOnLaunch: nil,
       objectTypes: [
        Schema.V1.User.self
    ])

    do {

      let realm = try Realm(configuration: v1)

      try realm.throwableWrite { realm in
        let user = Schema.V1.User()
        user.firstName = "Hiroshi"
        user.lastName = "Kimura"
        realm.add(user)
      }

      XCTAssertEqual(realm.objects(Schema.V1.User.self).count, 1)

    } catch {

      XCTFail("\(error)")
    }

  }

}
