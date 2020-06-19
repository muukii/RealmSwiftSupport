import XCTest
import RealmSwift

class User: RealmSwift.Object {
  @objc dynamic var name: String = ""
  @objc dynamic var email: String = ""
}

class ReintroduceEmailV3Tests: XCTestCase {

  func test() {
    
    let config = makeConfig(
      schemaVersion: 3,
      objectTypes: [User.self], 
      migrationBlock: { migration, oldSchemaVersion in
    })
    
    do {
      
      let realm = try Realm(configuration: config)
      
      XCTAssertEqual(realm.objects(User.self).count, 1)

      // for running V1 -> V2 -> V3
//      XCTAssertEqual(realm.objects(User.self).first?.email, "")
      
      // for running V1 -> V3
      XCTAssertEqual(realm.objects(User.self).first?.email, "john@example.com")
      
    } catch {
      
      XCTFail("\(error)")
    }
  }
}
