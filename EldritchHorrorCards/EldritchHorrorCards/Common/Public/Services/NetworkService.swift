import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    var session: URLSession { get }
	var isOnline: Bool { get }
	func startNetworkObserve()
}

final class NetworkService: NetworkServiceProtocol {
	
	//MARK: - Public variables
	
	var isOnline: Bool {
		return NetworkReachabilityManager()!.isReachable
	}
	
    lazy var session: URLSession = {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        return session
    }()
    
	// MARK: - Private variables
	
	private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "ya.ru")
    private let appNavigator: NavigatorProtocol = DI.providers.resolve(NavigatorProtocol.self)!
    
	//MARK: - Public
	
	public func startNetworkObserve() {
		reachabilityManager?.listener = { [weak self] status in
            guard let sSelf = self else { return }
            let notificationCenter = NotificationCenter.default
			switch status {
			case .notReachable:
                sSelf.appNavigator.currentController?.internetState(isConnected: false)
                notificationCenter.post(name: Notification.Name.ehOffline, object: nil)
			case .unknown:
                sSelf.appNavigator.currentController?.internetState(isConnected: true)
                notificationCenter.post(name: Notification.Name.ehOnline, object: nil)
			case .reachable(.ethernetOrWiFi):
                sSelf.appNavigator.currentController?.internetState(isConnected: true)
                notificationCenter.post(name: Notification.Name.ehOnline, object: nil)
			case .reachable(.wwan):
                sSelf.appNavigator.currentController?.internetState(isConnected: true)
                notificationCenter.post(name: Notification.Name.ehOnline, object: nil)
			}
		}
		reachabilityManager?.startListening()
	}
}
