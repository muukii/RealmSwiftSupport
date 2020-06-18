import RealmSwift

extension Realm {

  public func throwableWrite<Result>(_ block: (Realm) throws -> Result) throws -> Result {
    do {
      beginWrite()
      let result = try block(self)
      try commitWrite()
      return result
    } catch {
      cancelWrite()
      throw error
    }
  }

  public func detached() throws -> Realm {

    return try Realm(configuration: configuration)
  }
}
