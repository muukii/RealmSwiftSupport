//
//  MigrationTests.swift
//  RealmSwiftSupportTests
//
//  Created by muukii on 2020/06/13.
//  Copyright © 2020 muukii. All rights reserved.
//

import XCTest
import RealmSwift


private var rootDirectoryPath: String {
  let root = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
  return (root as NSString).appendingPathComponent(Bundle.main.bundleIdentifier!)
}

func makeRealmPath(identifier: String) -> URL {

  let path = rootDirectoryPath + "/\(identifier)"

  makeDirectory: do {
    try FileManager.default.createDirectory(atPath: rootDirectoryPath, withIntermediateDirectories: true, attributes: [:])
  } catch {
    fatalError("Failed to create directory Path: \(path)")
  }

  return URL(fileURLWithPath: path)
}

func makeConfig(
  schemaVersion: UInt64, 
  objectTypes: [Object.Type], 
  migrationBlock: @escaping MigrationBlock
) -> Realm.Configuration {
  
  .init(
    fileURL: realmPath, 
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

let realmPath = makeRealmPath(identifier: "migrationTests.realm")



class MigrationTests: XCTestCase {

  override func setUp() {
    super.setUp()
    print(realmPath)
  }
  
  
  func testDeleteRealmFile() {
    
    do {
      try FileManager.default.removeItem(at: realmPath)
    } catch {
      fatalError("Failed to remove realm file: \(realmPath)")
    }
  }
}
