struct Style {
    static var `default`: StyleDef!
    
    static func setup() {
        guard let style = JSONParser<StyleDef>.parse(jsonType: .style) else {
            fatalError("Style file with Error!!!")
        }
        Style.default = style
    }
}

struct StyleDef: Codable {
    struct MainGreen: Codable {
        let solid: String
        let gradientStart: String
        let gradientEnd: String
    }
    var mainGreen: MainGreen
    let error: String
}

