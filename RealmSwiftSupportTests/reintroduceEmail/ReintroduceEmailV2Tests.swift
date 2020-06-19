import XCTest
import RealmSwift

class User: RealmSwift.Object {
  @objc dynamic var name: String = ""
}


class ReintroduceEmailV2Tests: XCTestCase {

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
}
