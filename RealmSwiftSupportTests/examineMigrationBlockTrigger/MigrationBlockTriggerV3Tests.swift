import XCTest
import RealmSwift

class User: RealmSwift.Object {
  @objc dynamic var name: String = ""
  @objc dynamic var email: String = ""
  @objc dynamic var address: String = ""
}

class MigrationBlockTriggerV3Tests: XCTestCase {

  override func setUp() {
    super.setUp()
    print(realmPath)
  }
  
  // MARK: Migration Tests

  /// New Schema version but no change in schema. There are no problems about this.
  /// Run after MigrationBlockTriggerV2Tests#test
  func testNewSchemaVersionNoSchemaChanges() {
    
    var didRunMigrationBlock = false
    let config = makeConfig(
      schemaVersion: 3,
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
        
        didRunMigrationBlock = true
    })
    
    
    do {

      let realm = try Realm(configuration: config)
      
      XCTAssertTrue(didRunMigrationBlock)
      XCTAssertEqual(realm.objects(User.self).count, 1)
      XCTAssertEqual(realm.objects(User.self).first?.name, "John Appleseed")
      XCTAssertEqual(realm.objects(User.self).first?.email, "john@example.com")
    } catch {
      
      XCTFail("\(error)")
    }
  }
  
}
