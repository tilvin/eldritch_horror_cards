import RealmSwift

class ROConfig: Object {
	@objc dynamic var uid: String = "1"
    @objc dynamic var tokenKey: String = ""
    @objc dynamic var loginKey: String = ""
	
	override class func primaryKey() -> String? {
		return "uid"
	}
}
