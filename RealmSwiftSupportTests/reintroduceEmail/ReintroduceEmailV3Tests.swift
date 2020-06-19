import XCTest
import RealmSwift

class User: RealmSwift.Object {
  @objc dynamic var name: String = ""
  @objc dynamic var email: String = ""
}

class ReintroduceEmailV3Tests: XCTestCase {

  /// Confirm re-introduced email property is empty.
  /// Run after ReintroduceEmailV1Tests#test, ReintroduceEmailV2Tests#test
  func testForRunningAllVersions() {

    let config = makeConfig(
      schemaVersion: 3,
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
    })
    
    do {
      
      let realm = try Realm(configuration: config)
      
      XCTAssertEqual(realm.objects(User.self).count, 1)
      XCTAssertEqual(realm.objects(User.self).first?.email, "")
      
    } catch {
      
      XCTFail("\(error)")
    }
  }

  /// Confirm re-introduced email property is empty if V2 is skipped.
  /// Run after ReintroduceEmailV1Tests#test
  func testForV2Skipped() {
    
    let config = makeConfig(
      schemaVersion: 3,
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
    })
    
    do {
      
      let realm = try Realm(configuration: config)
      
      XCTAssertEqual(realm.objects(User.self).count, 1)
      XCTAssertEqual(realm.objects(User.self).first?.email, "john@example.com")
      
    } catch {
      
      XCTFail("\(error)")
    }
  }
  
  /// Failing test. Cannot set nil to a non-optional property in migration block.
  /// Run after ReintroduceEmailV1Tests#test
  func testFailSettingNilForNonOptionalInMigrationBlock() {
    
    let config = makeConfig(
      schemaVersion: 3,
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
        
        migration.enumerateObjects(ofType: User.className()) { (old, new) in
          // => caught "RLMException", "Invalid value '(null)' of type '(null)' for 'string' property 'User.email'."
          new?["email"] = nil
        }
    })
    
    do {
      _ = try Realm(configuration: config)
    } catch {
      XCTFail("\(error)")
    }
  }
  
  /// Correct way to re-introduce email property having it empty.
  /// Run after ReintroduceEmailV1Tests#test
  func testForV2SkippedAndDeleteInMigrationBlock() {
    
    let config = makeConfig(
      schemaVersion: 3,
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
        
        migration.enumerateObjects(ofType: User.className()) { (old, new) in
          new?["email"] = ""
        }
    })
    
    do {
      
      let realm = try Realm(configuration: config)
      
      XCTAssertEqual(realm.objects(User.self).count, 1)
      XCTAssertEqual(realm.objects(User.self).first?.email, "")
      
    } catch {
      
      XCTFail("\(error)")
    }
  }

}
