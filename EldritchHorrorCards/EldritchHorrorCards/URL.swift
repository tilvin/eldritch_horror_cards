public extension URL {
  
  public typealias Params = [String: AnyObject]
  
  public func paramsDictonary() -> Params {
    var params = Params()
    if let urlParams = query {
      let splitParams = urlParams.split { $0 == "&" }.map { String($0) }
      for param in splitParams {
        let paramKVP = param.split { $0 == "=" }.map { String($0) }
        if paramKVP.count > 1 {
          params[paramKVP[0]] = paramKVP[1] as AnyObject?
        }
      }
    }
    
    return params
  }
  
}
