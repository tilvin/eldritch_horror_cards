import Fakery

struct NetworkManager {
    static func getToken(connector: APIRequest, completion: (String) -> Void) {
        Log.writeLog(logLevel: .info, message: "need load data from net!")
        let token = Faker().lorem.words(amount: 3)
        completion(token)
    }
}
