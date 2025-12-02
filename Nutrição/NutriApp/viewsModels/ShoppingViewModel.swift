import Foundation

final class ShoppingViewModel: ObservableObject {
    @Published var items: [ShoppingItem] = []
    
    func generate(from week: [DayMenu]) {
        var dict: [String: (Double, String)] = [:] // name: (qty, unit)
        for day in week {
            let meals = [day.breakfast, day.lunch, day.snack, day.dinner]
            for meal in meals {
                for entry in meal.foods {
                    // normalize units to grams if 'g', ml for liquid, un stays unit
                    let key = entry.food.name
                    let unit = entry.unit == .g ? "g" : (entry.unit == .ml ? "ml" : "un")
                    dict[key, default: (0.0, unit)].0 += entry.qty
                    dict[key] = (dict[key]!.0, unit)
                }
            }
        }
        items = dict.map { ShoppingItem(name: $0.key, quantity: $0.value.0, unit: $0.value.1) }
        // sort for predictability
        items.sort { $0.name < $1.name }
    }
}
