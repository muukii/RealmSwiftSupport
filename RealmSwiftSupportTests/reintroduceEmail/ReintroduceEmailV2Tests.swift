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
}
