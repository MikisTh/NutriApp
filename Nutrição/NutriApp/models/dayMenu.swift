import Foundation

struct DayMenu: Identifiable, Codable {
    let id = UUID()
    let dayName: String
    let breakfast: Meal
    let lunch: Meal
    let snack: Meal
    let dinner: Meal
    
    var totalKcal: Int {
        breakfast.totalKcal + lunch.totalKcal + snack.totalKcal + dinner.totalKcal
    }
}
