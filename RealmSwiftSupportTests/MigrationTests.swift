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
      @objc dynamic var email: String = ""
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
      @objc dynamic var email: String = ""
    }
  }

//  typealias Current = V1
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

//  let path = makeTempPath(identifier: "\(UUID().uuidString).realm")
  let path = makeTempPath(identifier: "migrationTests.realm")

  override func setUp() {
    super.setUp()
    print(path)
  }
  
  private func makeConfig(
    schemaVersion: UInt64, 
    objectTypes: [Object.Type], 
    migrationBlock: @escaping MigrationBlock
  ) -> Realm.Configuration {
    
    .init(
      fileURL: path, 
      inMemoryIdentifier: nil, 
      syncConfiguration: nil, 
      encryptionKey: nil, 
      readOnly: false, 
      schemaVersion: schemaVersion, 
      migrationBlock: migrationBlock, 
      deleteRealmIfMigrationNeeded: false, 
      shouldCompactOnLaunch: nil, 
      objectTypes: objectTypes
    )
  }
  
  func testDeleteRealmFile() {
    
    do {
      try FileManager.default.removeItem(at: path)
    } catch {
      fatalError("Failed to remove realm file: \(path)")
    }
  }
  
  // MARK: Migration Tests

  func testV1() {

    let config = makeConfig(
      schemaVersion: 1, 
      objectTypes: [Schema.V1.User.self], 
      migrationBlock: { migration, oldSchemaVersion in 
    })

    do {

      let realm = try Realm(configuration: config)

      try realm.throwableWrite { realm in
        let user = Schema.V1.User()
        user.firstName = "John"
        user.lastName = "Appleseed"
        user.email = "john@example.com"
        realm.add(user)
      }

      XCTAssertEqual(realm.objects(Schema.V1.User.self).count, 1)

    } catch {

      XCTFail("\(error)")
    }
  }
  
  func testV2() {

    let config = makeConfig(
      schemaVersion: 2, 
      objectTypes: [Schema.V2.User.self], 
      migrationBlock: { migration, oldSchemaVersion in 
    })

    do {

      let realm = try Realm(configuration: config)

      XCTAssertEqual(realm.objects(Schema.V2.User.self).count, 1)

    } catch {

      XCTFail("\(error)")
    }
  }

}
