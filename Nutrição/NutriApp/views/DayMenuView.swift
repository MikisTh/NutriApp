import SwiftUI

struct DayMenuView: View {
    let day: DayMenu
    var body: some View {
        List {
            MealSectionView(title: "Café", meal: day.breakfast)
            MealSectionView(title: "Almoço", meal: day.lunch)
            MealSectionView(title: "Lanche", meal: day.snack)
            MealSectionView(title: "Jantar", meal: day.dinner)
            Section(footer: Text("Total: \(day.totalKcal) kcal")) {}
        }
        .navigationTitle(day.dayName)
    }
}

struct MealSectionView: View {
    let title: String
    let meal: Meal
    var body: some View {
        Section(header: Text("\(title) • \(meal.totalKcal) kcal")) {
            ForEach(meal.foods.indices, id: \.self) { idx in
                let f = meal.foods[idx]
                HStack {
                    Text(f.food.name)
                    Spacer()
                    Text(quantityText(f.qty, unit: f.unit))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    func quantityText(_ qty: Double, unit: FoodItem.UnitType) -> String {
        switch unit {
        case .g: return "\(Int(qty)) g"
        case .ml: return "\(Int(qty)) ml"
        case .un: return "\(Int(qty)) un"
        }
    }
}
