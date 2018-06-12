//import Alamofire
//
//public enum APIRequest {
//    case signin(login: String, password: String)
//}
//
//protocol AuthorizationProtocol {
//    static var isAuthorized: Bool { get }
//    static func logout(error: Error?)
//    static var token: String { get }
//}
//
//extension APIRequest: URLRequestConvertible {
//    static private let version: Int = 2
//  static private let apiURL: URL = URL(string: "https://test.cubux.net")! //prod: www.cubux.net // test: test.cubux.net
//    static private let userAgent: String = {
//        return "Cubux:ios"
//    }()
//    
//    static var authorization: AuthorizationProtocol.Type?
//
//    private struct Components {
//        var version: Int = APIRequest.version
//        var path: String!
//        var parameters: [String: Any] = [:]
//        var headers: [String: String] = [:]
//        var encoding: ParameterEncoding = JSONEncoding.default
//        var emptyBody: Bool = false
//        var needBarierToken: Bool = true
//    }
//    
//    public func asURLRequest() throws -> URLRequest {
//        let components = self.components
//        
//        let url = APIRequest.apiURL.appendingPathComponent(components.path)
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = self.method
//        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
//        request.setValue(APIRequest.userAgent, forHTTPHeaderField: "User-Agent")
//        if components.needBarierToken {
//            request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
//        }
//        for header in components.headers {
//            request.setValue(header.value, forHTTPHeaderField: header.key)
//        }
//
//        return try components.encoding.encode(request, with: components.emptyBody ? nil : components.parameters)
//    }
//    
//    var request: URLRequest {
//        return self.urlRequest!
//    }
// 
//    private var token: String {
//        return APIRequest.authorization?.token ?? ""
//    }
//    
//    private var components: Components {
//        var components = Components()
//        
//        switch self {
//        case .signin(let login, let password):
//            components.path = "oauth2/token"
//            components.parameters["client_id"] = Auth.CLIENT_ID_KEY
//            components.parameters["grant_type"] = Auth.TYPE_PASSWORD_KEY
//            components.parameters["username"] = login
//            components.parameters["password"] = password
//            components.parameters["scope"] = Auth.SCOPE_KEY
//            components.needBarierToken = false
//            return components
//            
//        case .refreshToken(let refreshToken):
//            components.path = "oauth2/token"
//            components.parameters["client_id"] = Auth.CLIENT_ID_KEY
//            components.parameters["grant_type"] = Auth.REFRESH_TOKEN_KEY
//            components.parameters["refresh_token"] = refreshToken
//            components.needBarierToken = false
//            return components
//            
//        case .centrifugeClient:
//            components.path = "centrifugo/client"
//            return components
//            
//        case .centrifugeAuth(let centrifugeClientId, let channel):
//            components.path = "centrifugo/auth"
//            components.parameters["channels"] = [channel]
//            components.parameters["client"] = centrifugeClientId
//            components.needBarierToken = false
//            return components
//            
//        case .userData:
//            components.path = "api/v2/sync/user"
//            components.emptyBody = true
//            return components
//            
//        case .userDataRevision(let revision):
//            components.path = "api/v2/sync/user/since/\(revision)"
//            components.emptyBody = true
//            return components
//            
//        case .globalData:
//            components.path = "api/v2/sync/global"
//            components.emptyBody = true
//            components.needBarierToken = false
//            return components
//            
//        case .globalDataRevision(let revision):
//            components.path = "/api/v2/sync/global/since/\(revision)"
//            components.emptyBody = true
//            components.needBarierToken = false
//            return components
//            
//        case .teamData(let teamUUID):
//            components.path = "/api/v2/sync/team/\(teamUUID)"
//            components.emptyBody = true
//            return components
//            
//        case .teamDataRevision(let teamUUID, let revision):
//            components.path = "/api/v2/sync/team/\(teamUUID)/since/\(revision)"
//            components.emptyBody = true
//            return components
//            
//        case .postUserData(let objects):
//            components.path = "/api/v2/sync/user"
//            components.parameters = objects
//            return components
//            
//        case .postTeamData(let teamUUID, let objects):
//            components.path = "/api/v2/sync/team/\(teamUUID)"
//            components.parameters = objects
//            return components
//            
//        case .checkUserTicket(let ticketUUID):
//            components.path = "/api/v2/sync/user/ticket/\(ticketUUID)"
//            components.emptyBody = true
//            return components
//            
//        case .checkTeamTicket(let teamUUID, let ticketUUID):
//            components.path = "/api/v2/sync/team/\(teamUUID)/ticket/\(ticketUUID)"
//            components.emptyBody = true
//            return components
//        }
//    }
//    
//    private var method: String {
//        switch self {
//        case .signin, .refreshToken, .centrifugeClient, .centrifugeAuth, .postUserData, .postTeamData:
//            return "POST"
//        default:
//            return "GET"
//        }
//    }
//}
//
//extension APIRequest {
//    
//    enum Error: Swift.Error {
//        case api(code: Int, message: String?)
//        case unauthorized
//        case unknown(String?)
//        case map
//        
//        var localizedDescription: String {
//            switch self {
//            case let .api(_, message):
//                return message ?? "Server error".localized
//            case .unknown(let message):
//                return message ?? "Unknown error".localized
//            case .unauthorized:
//                return "Authorization error".localized
//            case .map:
//                return "Wrong response".localized
//            }
//        }
//    }
//}
