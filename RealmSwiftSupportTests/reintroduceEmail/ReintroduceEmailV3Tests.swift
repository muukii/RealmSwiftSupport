import XCTest
import RealmSwift

class User: RealmSwift.Object {
  @objc dynamic var name: String = ""
  @objc dynamic var email: String = ""
}

class ReintroduceEmailV3Tests: XCTestCase {

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

  func testForV2SkippedAndDeleteInMigrationBlock() {
    
    let config = makeConfig(
      schemaVersion: 3,
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
        
        migration.enumerateObjects(ofType: User.className()) { (old, new) in
          
          // new?["email"] = nil
          // => caught "RLMException", "Invalid value '(null)' of type '(null)' for 'string' property 'User.email'."
          // do not set nil for an optional property
          
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
  
  func testForRunningAllVersionsEmptyingOldEmailInV2() {

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
  

}
