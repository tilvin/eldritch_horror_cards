import Foundation
import UIKit

public protocol ConfigurableCell {
    associatedtype T
    func configure(with _: T)
}

public protocol RowBuilder {
    var reusableID: String { get }
    var count: Int { get }
    func configure(cell: UITableViewCell, itemIndex: Int)
    func item(itemIndex: Int) -> Any
}

public class TableRowBuilder<DataType, CellType: ConfigurableCell>: RowBuilder where CellType.T == DataType, CellType: UITableViewCell {
    
    private var items = [DataType]()
    
    public init(items: [DataType]) {
        self.items = items
    }
    
    public var reusableID: String {
        return String(describing: CellType.self)
    }
    
    public var count: Int {
        return self.items.count
    }
    
    public func configure(cell: UITableViewCell, itemIndex: Int) {
        (cell as? CellType)?.configure(with: items[itemIndex])
    }
    
    public func item(itemIndex: Int) -> Any {
        return self.items[itemIndex]
    }
}
