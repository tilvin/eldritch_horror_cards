extension UITextField {
    
    func typeOn(string: String, index: Int = 0, completion: (() -> Void)? = nil) {
        guard string.count > 0 else {
            completion?()
            return
        }
        guard index < string.count - 1 else {
            completion?()
            return
        }
        
        let letter = Array(string)[index]
        let t = self.text ?? ""
        self.text = "\(t)\(letter)"
        delay(seconds: 0.1) { [weak self] in
            self?.typeOn(string: string, index: index + 1, completion: completion)
        }
    }
}
