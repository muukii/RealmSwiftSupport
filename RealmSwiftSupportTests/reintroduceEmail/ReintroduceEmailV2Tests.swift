import XCTest
import RealmSwift

class User: RealmSwift.Object {
  @objc dynamic var name: String = ""
}


/// How to use
/// 1. Remove Target Membership of other XxxVxTests.swift
/// 2. Run each test individually, not whole test class.
class ReintroduceEmailV2Tests: XCTestCase {

  /// Just updating scheme. Empty migration block and no other logic.
  /// Run after ReintroduceEmailV1Tests#test
  func test() {
    
    let config = makeConfig(
      schemaVersion: 2, 
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
    })
    
    do {
      let realm = try Realm(configuration: config)
      XCTAssertEqual(realm.objects(User.self).count, 1)
    } catch {
      XCTFail("\(error)")
    }
  }
  
  
  /// Failing test. Cannot access deleted property in old schema's object.
  /// Run after ReintroduceEmailV1Tests#test
  func testFailEmptyingEmailInOld() {

    let config = makeConfig(
      schemaVersion: 2, 
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
        
        migration.enumerateObjects(ofType: User.className()) { (old, new) in
          // caught "RLMException", "Cannot modify managed objects outside of a write transaction."
          old?["email"] = ""
        }
    })

    do {
      _ = try Realm(configuration: config)
    } catch {
      XCTFail("\(error)")
    }
  }
  
  /// Failing test. Cannot access deleted property in new schema's object.
  /// Run after ReintroduceEmailV1Tests#test
  func testFailEmptyingEmailInNew() {

    let config = makeConfig(
      schemaVersion: 2, 
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
        
        migration.enumerateObjects(ofType: User.className()) { (old, new) in
          // caught "RLMException", "Invalid property name 'email' for class 'User'."
          new?["email"] = ""
        }
    })

    do {
      _ = try Realm(configuration: config)
    } catch {
      XCTFail("\(error)")
    }
  }
  
}
