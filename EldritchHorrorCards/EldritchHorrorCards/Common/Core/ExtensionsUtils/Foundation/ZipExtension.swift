//
// Created by Andrey Torlopov on 8/4/18.
// Copyright (c) 2018 Andrey Torlopov. All rights reserved.
//

import Foundation
import Zip

extension Data {

	enum EHDataType: String {
		case monsters
		case cardsShirts
	}

	func unzip(dataType: EHDataType) throws -> Data? {
		guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first else { return nil }
		let zipPath = documentsUrl.appendingPathComponent("\(dataType.rawValue).zip")
		try? self.write(to: zipPath, options: .atomic)
		guard let unzipPath = try? Zip.quickUnzipFile(zipPath) else { return nil }
		let unzipFilePath = unzipPath.appendingPathComponent("\(dataType.rawValue).json")
		guard let data = try? Data(contentsOf: unzipFilePath) else { return nil }
		try? FileManager.default.removeItem(at: zipPath)
		try? FileManager.default.removeItem(at: unzipPath)
		return data
	}
}