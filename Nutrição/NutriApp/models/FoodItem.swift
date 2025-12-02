import Foundation

struct FoodItem: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let unit: UnitType
    let kcalPer100g: Double // kcal per 100 g or per 100 ml (if liquid)
    
    enum UnitType: String, Codable {
        case g, ml, un
    }
}

