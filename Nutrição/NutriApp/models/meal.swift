import Foundation

struct Meal: Identifiable, Codable {
    let id = UUID()
    let name: String
    // foods: (FoodItem, quantity, unit) - quantity uses same unit as FoodItem.unit
    var foods: [(food: FoodItem, qty: Double, unit: FoodItem.UnitType)]
    
    var totalKcal: Int {
        foods.reduce(0) { acc, entry in
            let kcalPerUnit100 = entry.food.kcalPer100g
            switch entry.unit {
            case .g:
                return acc + Int((kcalPerUnit100 * entry.qty) / 100.0)
            case .ml:
                return acc + Int((kcalPerUnit100 * entry.qty) / 100.0)
            case .un:
                // assume kcalPer100g as kcal per unit*100g mapping - fallback: treat qty as units with avg weight 100g
                return acc + Int((kcalPerUnit100 * entry.qty))
            }
        }
    }
}
