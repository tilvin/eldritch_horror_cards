import Foundation

typealias CommandAction<T> = (T) -> Void

struct CommandWith<T> {
    
    let action: CommandAction<T>
    
    func perform(with value: T) {
        self.action(value)
    }
}

extension CommandWith where T == Void {
    func perform() { perform(with: ()) }
}

typealias Command = CommandWith<Void>
