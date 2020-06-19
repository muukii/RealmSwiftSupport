import XCTest
import RealmSwift

class User: RealmSwift.Object {
  @objc dynamic var name: String = ""
  @objc dynamic var email: String = ""
  @objc dynamic var address: String = ""
}

class MigrationBlockTriggerV2Tests: XCTestCase {

  override func setUp() {
    super.setUp()
    print(realmPath)
  }
  
  // MARK: Migration Tests
  
  /// Failing test. Changed schema without incrementing schema version
  /// Run after MigrationBlockTriggerV1Tests#test
  func testFailSchemaChangedWithSameSchemaVersion() {
    
    let config = makeConfig(
      schemaVersion: 1, 
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
        
        XCTFail("migration block should not run if schemaVersion is same")
    })
    
    do {

      // failed - Error Domain=io.realm Code=10 "Migration is required due to the following errors:
      // - Property 'User.address' has been added." UserInfo={NSLocalizedDescription=Migration is required due to the following errors:
      // - Property 'User.address' has been added., Error Code=10}
      _  = try Realm(configuration: config)
    } catch {
      XCTFail("\(error)")
    }
  }

  /// Just updating scheme. Empty migration block and no other logic.
  /// Run after MigrationBlockTriggerV1Tests#test
  func test() {
    
    var didRunMigrationBlock = false

    let config = makeConfig(
      schemaVersion: 2, 
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
        
        didRunMigrationBlock = true
    })

    
    do {
      _  = try Realm(configuration: config)
      XCTAssertTrue(didRunMigrationBlock)
    } catch {
      XCTFail("\(error)")
    }
  }
  
}
