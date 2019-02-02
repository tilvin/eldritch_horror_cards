//
//  NetworkClientProvider.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkClientEnviroment: String {
	case test = "https://test.cubux.net/"
	case app = "https://app.cubux.net/"
	case none = ""
}

protocol NetworkClientProviderProtocol {
	/// Initialize new object that
	/// conforms CachableNetworkProtocol with database connection that was opened in app starts
	/// and with NetworkClientSettings that needed for this Environment
	/// - Parameter type: Client Environment type enum
	/// - Returns: Object of CachableNetworkProtocol (Cachable Network)
	func client(with type: NetworkClientEnviroment) -> NetworkProtocol
}

class NetworkClientProvider: NetworkClientProviderProtocol {
	
	//MARK: - variables
	private var settingsProvider: NetworkSettingsProviderProtocol!
	private var networkClients: [NetworkClientEnviroment: Network] = [:]
	
	//MARK: - Init
	
	/// Initialize Provider object
	///
	/// - Parameters:
	///   - settingsProvider: Object who will provides app info.
	init(settings: NetworkSettingsProviderProtocol) {
		self.settingsProvider = settings
	}
	
	//MARK: - Public

	/// Initialize new object that
	/// conforms CachableNetworkProtocol with database connection that was opened in app starts
	/// and with NetworkClientSettings that needed for this Environment
	/// - Parameter type: Client Environment type enum
	/// - Returns: Object of CachableNetworkProtocol (Cachable Network)
	public func client(with type: NetworkClientEnviroment = .app) -> NetworkProtocol {
		if let existingNetworkClient = self.networkClients[type] {
			return existingNetworkClient
		}

		let settings = self.settingsProvider.settings(for: type.rawValue)
		let cachableNetwork = getNetwork(settings: settings)
		self.networkClients[type] = cachableNetwork
		return cachableNetwork
	}
	
	//MARK: - Private
	
	private func getNetwork(settings: NetworkClientSettings) -> Network {
		let host = URL(string: settings.baseURL)?.host ?? ""
		let sessionManager = self.getSessionManager(host: host)
		return Network(settings: settings, sessionManager: sessionManager)
	}
	
	private func getSessionManager(configuration: URLSessionConfiguration = .default, host: String, enableSSLPinning: Bool = false) -> SessionManager {
		var manager: SessionManager
		configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
		var testServerTrustPolicies: [String: ServerTrustPolicy] = [:]
		if enableSSLPinning {
			testServerTrustPolicies[host] = .pinCertificates(
				certificates: ServerTrustPolicy.certificates(in: Bundle.main),
				validateCertificateChain: true,
				validateHost: true
			)
		}
		else {
			testServerTrustPolicies[host] = .disableEvaluation
		}
		let serverTrustPolicyManager = ServerTrustPolicyManager(policies: testServerTrustPolicies)
		manager = SessionManager(configuration: configuration, serverTrustPolicyManager: serverTrustPolicyManager)

		return manager
	}
}
