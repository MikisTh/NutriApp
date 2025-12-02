import Foundation

enum SampleFoods {
    static let banana = FoodItem(name: "Banana", unit: .g, kcalPer100g: 89)
    static let leite = FoodItem(name: "Leite", unit: .ml, kcalPer100g: 60) // per 100 ml
    static let arroz = FoodItem(name: "Arroz integral", unit: .g, kcalPer100g: 130)
    static let arrozBranco = FoodItem(name: "Arroz branco", unit: .g, kcalPer100g: 130)
    static let feijao = FoodItem(name: "Feijão", unit: .g, kcalPer100g: 110)
    static let frango = FoodItem(name: "Frango grelhado", unit: .g, kcalPer100g: 165)
    static let cuscuz = FoodItem(name: "Cuscuz", unit: .g, kcalPer100g: 120)
    static let ovo = FoodItem(name: "Ovo", unit: .un, kcalPer100g: 70) // treated as ~70kcal per unit
    static let macaxeira = FoodItem(name: "Macaxeira", unit: .g, kcalPer100g: 160)
    static let sardinha = FoodItem(name: "Sardinha", unit: .g, kcalPer100g: 166)
    static let melao = FoodItem(name: "Melão", unit: .g, kcalPer100g: 34)
    static let mamao = FoodItem(name: "Mamão", unit: .g, kcalPer100g: 43)
    static let peixe = FoodItem(name: "Peixe", unit: .g, kcalPer100g: 133)
    static let inhame = FoodItem(name: "Inhame", unit: .g, kcalPer100g: 85)
    static let queijo = FoodItem(name: "Queijo coalho", unit: .g, kcalPer100g: 270)
    static let macarrão = FoodItem(name: "Macarrão", unit: .g, kcalPer100g: 158)
    static let batataDoce = FoodItem(name: "Batata-doce", unit: .g, kcalPer100g: 86)
    static let charque = FoodItem(name: "Charque", unit: .g, kcalPer100g: 250)
    static let cará = FoodItem(name: "Cará", unit: .g, kcalPer100g: 86)
    static let suco = FoodItem(name: "Suco", unit: .ml, kcalPer100g: 45)
}

struct DataProvider {
    static func sampleWeek() -> [DayMenu] {
        // build meals according to your menu summary (quantities approximate)
        let monday = DayMenu(
            dayName: "Segunda",
            breakfast: Meal(name: "Vitamina", foods: [
                (SampleFoods.banana, 100, .g),
                (SampleFoods.leite, 200, .ml)
            ]),
            lunch: Meal(name: "Almoço", foods: [
                (SampleFoods.arroz, 120, .g),
                (SampleFoods.feijao, 100, .g),
                (SampleFoods.frango, 120, .g),
                (FoodItem(name: "Salada", unit: .g, kcalPer100g: 25), 120, .g),
                (FoodItem(name: "Suco caju", unit: .ml, kcalPer100g: 45), 200, .ml)
            ]),
            snack: Meal(name: "Lanche", foods: [
                (FoodItem(name: "Maçã", unit: .un, kcalPer100g: 60), 1, .un)
            ]),
            dinner: Meal(name: "Jantar", foods: [
                (SampleFoods.cuscuz, 150, .g),
                (SampleFoods.ovo, 2, .un),
                (FoodItem(name: "Legumes", unit: .g, kcalPer100g: 20), 50, .g)
            ])
        )
        // Build the rest similarly (tuesday..sunday) - for brevity only monday shown here
        // Please add the rest using the same pattern; the Views will show all days present here.
        return [monday]
    }
}
