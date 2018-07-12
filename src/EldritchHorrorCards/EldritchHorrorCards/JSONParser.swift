public class JSONParser<T: Codable> {
  
  public static func parse(jsonType: JSONParserType) -> T? {
    var jsonString = ""
    
    switch jsonType {
    case .style:
      if let file = Bundle.main.url(forResource: "Style", withExtension: "json"),
        let string = try? String(contentsOf: file) {
        jsonString = string
      }
    case .string(let string):
      jsonString = string
    }
    
    guard let data = jsonString.data(using: .utf8) else { return nil }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return try? decoder.decode(T.self, from: data)
  }
}

public enum JSONParserType {
  case style
  case string(string: String)
}
