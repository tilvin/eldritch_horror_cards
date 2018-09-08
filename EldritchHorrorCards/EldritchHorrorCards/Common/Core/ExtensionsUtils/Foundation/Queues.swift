import Foundation

public func background(_ closure: @escaping () -> Void) {
  DispatchQueue.global(qos: .default).async(execute: closure)
}

public func customBackground(qos: DispatchQoS.QoSClass, _ closure: @escaping () -> Void) {
  DispatchQueue.global(qos: qos).async(execute: closure)
}

public func main(_ closure: @escaping () -> Void) {
  DispatchQueue.main.async(execute: closure)
}

public func delay(seconds: Double, completion: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
