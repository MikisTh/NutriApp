import Foundation

// MARK: - Models

struct MealItem {
    let name: String
    let quantity: Double   // quantity in unit described by `unit` (e.g., grams, ml, units)
    let unit: String       // "g", "ml", "un" (unit), "kg" (if quantity given in kg)
    let kcal: Int
}

struct Meal {
    let name: String
    let items: [MealItem]
    var totalKcal: Int {
        items.reduce(0) { $0 + $1.kcal }
    }
}

struct DayPlan {
    let name: String
    let meals: [Meal]
    var totalKcal: Int { meals.reduce(0) { $0 + $1.totalKcal } }
}

// Shopping item aggregated
struct ShoppingItem {
    let name: String
    var quantityInG: Double   // normalized to grams where applicable (units converted to grams if possible)
    var unit: String          // "g" or "ml" or "un"
}

// Price table (editable). Prices in BRL per unit: per kg for weight items, per liter for liquids, per unit for eggs/pão etc.
var pricePerKg: [String: Double] = [
    "Arroz": 5.80,         // R$/kg
    "Feijão": 7.00,        // R$/kg
    "Macarrão": 5.00,      // R$/kg
    "Cuscuz": 6.00,        // R$/kg (fubá)
    "Batata-doce": 4.50,   // R$/kg
    "Inhame": 8.00,        // R$/kg
    "Macaxeira": 4.00,     // R$/kg
    "Cará": 7.00,          // R$/kg
    "Batata-inglesa": 3.50,// R$/kg
    "Charque": 25.00,      // R$/kg
    "Frango": 15.00,       // R$/kg
    "Peixe": 18.00,        // R$/kg
    "Queijo coalho": 25.00 // R$/kg
]

var pricePerUnit: [String: Double] = [
    "Pão": 0.80,           // R$ per unit
    "Ovo": 1.25,           // R$ per unit (12 ~ R$15 -> 1.25)
    "Leite": 5.00,         // R$ per liter
    "Banana": 0.40,        // R$ per unit
    "Maçã": 1.50,          // R$ per unit
    "Mamão": 6.00,         // R$ per unit
    "Melão": 10.00,        // R$ per unit
    "Melancia": 12.00,     // R$ for whole (we'll use fraction)
    "Laranja": 0.90,       // R$ per unit
    "Limão": 0.80          // R$ per unit
]

// Helper converts quantities (g/ml/un) to cost using price tables.
// If item not found in pricePerKg or pricePerUnit, cost is 0 (user should fill).
func costFor(itemName: String, quantity: Double, unit: String) -> Double {
    // normalize names to check keys
    let key = itemName
    switch unit {
    case "g":
        if let priceKg = pricePerKg[key] {
            return (quantity / 1000.0) * priceKg
        }
    case "kg":
        if let priceKg = pricePerKg[key] {
            return quantity * priceKg
        }
    case "ml":
        if let priceL = pricePerUnit[key] { // if stored per liter in pricePerUnit (Leite)
            return (quantity / 1000.0) * priceL
        } else if let priceKg = pricePerKg[key] { // fallback assume 1kg ~= 1L for some items
            return (quantity / 1000.0) * priceKg
        }
    case "un":
        if let perUnit = pricePerUnit[key] {
            return quantity * perUnit
        } else if let priceKg = pricePerKg[key] {
            // no unit price, attempt to estimate: assume one unit ~ 0.15 kg
            return (0.15 * priceKg) * quantity
        }
    default:
        break
    }
    return 0.0
}

// MARK: - Weekly Plan (data taken from summary; quantities are approximate)

// For brevity, each meal includes main items with approximate qty and kcal.
// Units: g (grams), ml (milliliters), un (units)

// MONDAY
let monday = DayPlan(
    name: "Segunda",
    meals: [
        Meal(name: "Café", items: [
            MealItem(name: "Banana", quantity: 100, unit: "g", kcal: 100),
            MealItem(name: "Leite", quantity: 200, unit: "ml", kcal: 120)
        ]),
        Meal(name: "Almoço", items: [
            MealItem(name: "Arroz", quantity: 120, unit: "g", kcal: 150),
            MealItem(name: "Feijão", quantity: 100, unit: "g", kcal: 110),
            MealItem(name: "Frango", quantity: 120, unit: "g", kcal: 200),
            MealItem(name: "Salada", quantity: 120, unit: "g", kcal: 30),
            MealItem(name: "Suco caju", quantity: 200, unit: "ml", kcal: 90)
        ]),
        Meal(name: "Lanche", items: [
            MealItem(name: "Maçã", quantity: 1, unit: "un", kcal: 70)
        ]),
        Meal(name: "Jantar", items: [
            MealItem(name: "Cuscuz", quantity: 150, unit: "g", kcal: 180),
            MealItem(name: "Ovo", quantity: 2, unit: "un", kcal: 140),
            MealItem(name: "Legumes (omelete)", quantity: 50, unit: "g", kcal: 10)
        ])
    ]
)

// TUESDAY
let tuesday = DayPlan(
    name: "Terça",
    meals: [
        Meal(name: "Café", items: [
            MealItem(name: "Pão", quantity: 1, unit: "un", kcal: 140),
            MealItem(name: "Ovo", quantity: 2, unit: "un", kcal: 150)
        ]),
        Meal(name: "Almoço", items: [
            MealItem(name: "Macaxeira", quantity: 250, unit: "g", kcal: 300),
            MealItem(name: "Sardinha", quantity: 120, unit: "g", kcal: 200),
            MealItem(name: "Salada", quantity: 150, unit: "g", kcal: 70),
            MealItem(name: "Suco laranja", quantity: 250, unit: "ml", kcal: 100)
        ]),
        Meal(name: "Lanche", items: [
            MealItem(name: "Melão", quantity: 200, unit: "g", kcal: 60)
        ]),
        Meal(name: "Jantar", items: [
            MealItem(name: "Cuscuz", quantity: 150, unit: "g", kcal: 180),
            MealItem(name: "Leite", quantity: 200, unit: "ml", kcal: 120)
        ])
    ]
)

// WEDNESDAY
let wednesday = DayPlan(
    name: "Quarta",
    meals: [
        Meal(name: "Café", items: [
            MealItem(name: "Mamão", quantity: 150, unit: "g", kcal: 60),
            MealItem(name: "Leite", quantity: 200, unit: "ml", kcal: 120)
        ]),
        Meal(name: "Almoço", items: [
            MealItem(name: "Arroz", quantity: 120, unit: "g", kcal: 150),
            MealItem(name: "Feijão", quantity: 100, unit: "g", kcal: 110),
            MealItem(name: "Peixe", quantity: 150, unit: "g", kcal: 200),
            MealItem(name: "Salada", quantity: 150, unit: "g", kcal: 40),
            MealItem(name: "Suco manga", quantity: 250, unit: "ml", kcal: 120)
        ]),
        Meal(name: "Lanche", items: [
            MealItem(name: "Banana", quantity: 1, unit: "un", kcal: 80)
        ]),
        Meal(name: "Jantar", items: [
            MealItem(name: "Inhame", quantity: 200, unit: "g", kcal: 160),
            MealItem(name: "Frango", quantity: 120, unit: "g", kcal: 200),
            MealItem(name: "Tomate/limão", quantity: 80, unit: "g", kcal: 20)
        ])
    ]
)

// THURSDAY
let thursday = DayPlan(
    name: "Quinta",
    meals: [
        Meal(name: "Café", items: [
            MealItem(name: "Pão", quantity: 1, unit: "un", kcal: 140),
            MealItem(name: "Queijo coalho", quantity: 40, unit: "g", kcal: 120),
            MealItem(name: "Mamão", quantity: 150, unit: "g", kcal: 60)
        ]),
        Meal(name: "Almoço", items: [
            MealItem(name: "Purê batata-inglesa", quantity: 150, unit: "g", kcal: 150),
            MealItem(name: "Macarrão", quantity: 150, unit: "g", kcal: 210),
            MealItem(name: "Strogonoff frango", quantity: 150, unit: "g", kcal: 250),
            MealItem(name: "Legumes", quantity: 100, unit: "g", kcal: 40),
            MealItem(name: "Suco", quantity: 250, unit: "ml", kcal: 120)
        ]),
        Meal(name: "Lanche", items: [
            MealItem(name: "Melancia", quantity: 300, unit: "g", kcal: 90)
        ]),
        Meal(name: "Jantar", items: [
            MealItem(name: "Cará", quantity: 200, unit: "g", kcal: 160),
            MealItem(name: "Ovo", quantity: 2, unit: "un", kcal: 140),
            MealItem(name: "Salada", quantity: 100, unit: "g", kcal: 30)
        ])
    ]
)

// FRIDAY
let friday = DayPlan(
    name: "Sexta",
    meals: [
        Meal(name: "Café", items: [
            MealItem(name: "Banana", quantity: 100, unit: "g", kcal: 100),
            MealItem(name: "Leite", quantity: 200, unit: "ml", kcal: 120)
        ]),
        Meal(name: "Almoço", items: [
            MealItem(name: "Macaxeira frita", quantity: 150, unit: "g", kcal: 350),
            MealItem(name: "Arroz", quantity: 120, unit: "g", kcal: 150),
            MealItem(name: "Feijão", quantity: 100, unit: "g", kcal: 110),
            MealItem(name: "Frango guisado", quantity: 150, unit: "g", kcal: 250),
            MealItem(name: "Salada", quantity: 100, unit: "g", kcal: 35),
            MealItem(name: "Suco limão", quantity: 200, unit: "ml", kcal: 80)
        ]),
        Meal(name: "Lanche", items: [
            MealItem(name: "Laranja", quantity: 1, unit: "un", kcal: 60)
        ]),
        Meal(name: "Jantar", items: [
            MealItem(name: "Inhame", quantity: 150, unit: "g", kcal: 120),
            MealItem(name: "Peixe", quantity: 150, unit: "g", kcal: 200),
            MealItem(name: "Salada", quantity: 100, unit: "g", kcal: 35)
        ])
    ]
)

// SATURDAY
let saturday = DayPlan(
    name: "Sábado",
    meals: [
        Meal(name: "Café", items: [
            MealItem(name: "Cuscuz", quantity: 150, unit: "g", kcal: 180),
            MealItem(name: "Ovo frito", quantity: 1, unit: "un", kcal: 110)
        ]),
        Meal(name: "Almoço", items: [
            MealItem(name: "Arroz", quantity: 120, unit: "g", kcal: 150),
            MealItem(name: "Feijão macassar", quantity: 120, unit: "g", kcal: 130),
            MealItem(name: "Charque frita", quantity: 100, unit: "g", kcal: 250),
            MealItem(name: "Vinagrete", quantity: 80, unit: "g", kcal: 50),
            MealItem(name: "Suco goiaba", quantity: 250, unit: "ml", kcal: 120)
        ]),
        Meal(name: "Lanche", items: [
            MealItem(name: "Mamão", quantity: 150, unit: "g", kcal: 60)
        ]),
        Meal(name: "Jantar", items: [
            MealItem(name: "Batata-doce", quantity: 200, unit: "g", kcal: 160),
            MealItem(name: "Ovo", quantity: 2, unit: "un", kcal: 140)
        ])
    ]
)

// SUNDAY
let sunday = DayPlan(
    name: "Domingo",
    meals: [
        Meal(name: "Café", items: [
            MealItem(name: "Pão", quantity: 1, unit: "un", kcal: 140),
            MealItem(name: "Ovo", quantity: 1, unit: "un", kcal: 110),
            MealItem(name: "Leite", quantity: 200, unit: "ml", kcal: 120)
        ]),
        Meal(name: "Almoço", items: [
            MealItem(name: "Arroz branco", quantity: 120, unit: "g", kcal: 150),
            MealItem(name: "Feijão preto", quantity: 100, unit: "g", kcal: 110),
            MealItem(name: "Peixe", quantity: 150, unit: "g", kcal: 200),
            MealItem(name: "Salada", quantity: 120, unit: "g", kcal: 40),
            MealItem(name: "Suco acerola", quantity: 250, unit: "ml", kcal: 150)
        ]),
        Meal(name: "Lanche", items: [
            MealItem(name: "Banana", quantity: 1, unit: "un", kcal: 80),
            MealItem(name: "Mel", quantity: 10, unit: "g", kcal: 30)
        ]),
        Meal(name: "Jantar", items: [
            MealItem(name: "Macaxeira", quantity: 200, unit: "g", kcal: 250),
            MealItem(name: "Charque", quantity: 150, unit: "g", kcal: 250),
            MealItem(name: "Vinagrete", quantity: 80, unit: "g", kcal: 50)
        ])
    ]
)

// Weekly array
let week = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]

// MARK: - Aggregation into shopping list

// Helper to convert MealItem -> normalized key and grams
func normalizeQuantity(_ item: MealItem) -> (key: String, grams: Double, unit: String) {
    let name = item.name
    switch item.unit {
    case "g":
        return (name, item.quantity, "g")
    case "kg":
        return (name, item.quantity * 1000.0, "g")
    case "ml":
        // leave ml separate; we will aggregate as ml
        return (name, item.quantity, "ml")
    case "un":
        // try convert some known things to grams average, else keep as units
        let lower = name.lowercased()
        if lower.contains("banana") { return (name, item.quantity * 120.0, "g") } // avg 120g each
        if lower.contains("maçã") || lower.contains("maca") { return (name, item.quantity * 150.0, "g") }
        if lower.contains("ovo") { return (name, item.quantity, "un") }
        if lower.contains("pão") { return (name, item.quantity, "un") }
        if lower.contains("melancia") { return (name, item.quantity * (12000.0/1.0), "g") } // not used like this
        // fallback assume unit is 1 unit = 120 g
        return (name, item.quantity * 120.0, "g")
    default:
        return (name, item.quantity, item.unit)
    }
}

var aggregated: [String: (gramsOrMl: Double, unit: String)] = [:]

for day in week {
    for meal in day.meals {
        for it in meal.items {
            let normalized = normalizeQuantity(it)
            if normalized.unit == "ml" {
                aggregated[normalized.key, default: (0.0, "ml")].gramsOrMl += normalized.grams
            } else if normalized.unit == "un" {
                aggregated[normalized.key, default: (0.0, "un")].gramsOrMl += normalized.grams
            } else { // grams
                aggregated[normalized.key, default: (0.0, "g")].gramsOrMl += normalized.grams
            }
        }
    }
}

// MARK: - Compute cost per item using price tables
// We'll map aggregated keys to prices. For keys not found, we attempt simple matches.

func computeCostForAggregated() -> [(String, Double, String, Double)] {
    // returns (name, qty, unit, cost)
    var result: [(String, Double, String, Double)] = []
    for (key, value) in aggregated {
        let unit = value.unit
        let qty = value.gramsOrMl
        var cost: Double = 0.0
        // match various keys to price dictionaries
        if unit == "g" {
            // try pricePerKg keys
            let mappingCandidates = pricePerKg.keys.filter { key.lowercased().contains($0.lowercased()) || $0.lowercased().contains(key.lowercased()) }
            if let match = mappingCandidates.first {
                cost = (qty / 1000.0) * pricePerKg[match]!
            } else {
                // some named items are 'Arroz', 'Arroz branco' etc.
                if key.lowercased().contains("arroz") {
                    cost = (qty / 1000.0) * pricePerKg["Arroz"]!
                } else if key.lowercased().contains("feijão") || key.lowercased().contains("feijao") {
                    cost = (qty / 1000.0) * pricePerKg["Feijão"]!
                } else if key.lowercased().contains("macaxeira") || key.lowercased().contains("aipim") {
                    cost = (qty / 1000.0) * pricePerKg["Macaxeira"]!
                } else if key.lowercased().contains("batata") {
                    cost = (qty / 1000.0) * pricePerKg["Batata-doce"]! // approximate
                } else if key.lowercased().contains("cará") {
                    cost = (qty / 1000.0) * pricePerKg["Cará"]!
                } else if key.lowercased().contains("inhame") {
                    cost = (qty / 1000.0) * pricePerKg["Inhame"]!
                } else if key.lowercased().contains("charque") {
                    cost = (qty / 1000.0) * pricePerKg["Charque"]!
                } else if key.lowercased().contains("frango") {
                    cost = (qty / 1000.0) * pricePerKg["Frango"]!
                } else if key.lowercased().contains("peixe") {
                    cost = (qty / 1000.0) * pricePerKg["Peixe"]!
                } else {
                    cost = 0.0
                }
            }
        } else if unit == "ml" {
            // liquids: try Leite or generic juice (no price -> 0)
            if key.lowercased().contains("leite") {
                cost = (qty / 1000.0) * pricePerUnit["Leite"]!
            } else {
                // unknown juices -> assume R$6/L
                cost = (qty / 1000.0) * 6.0
            }
        } else if unit == "un" {
            // eggs, pão, fruit units
            if key.lowercased().contains("ovo") {
                cost = qty * pricePerUnit["Ovo", default: 1.25]
            } else if key.lowercased().contains("pão") {
                cost = qty * pricePerUnit["Pão", default: 0.8]
            } else if key.lowercased().contains("banana") {
                cost = qty * pricePerUnit["Banana", default: 0.4]
            } else if key.lowercased().contains("maçã") || key.lowercased().contains("maca") {
                cost = qty * pricePerUnit["Maçã", default: 1.5]
            } else if key.lowercased().contains("laranja") {
                cost = qty * pricePerUnit["Laranja", default: 0.9]
            } else {
                cost = 0.0
            }
        }
        result.append((key, qty, unit, round(cost * 100) / 100.0))
    }
    return result.sorted { $0.0 < $1.0 }
}

// MARK: - Print summary

func printWeeklySummary() {
    print("=== Resumo do cardápio semanal ===")
    for day in week {
        print("\n-- \(day.name) (kcal total: \(day.totalKcal))")
        for meal in day.meals {
            print("  • \(meal.name) (kcal: \(meal.totalKcal))")
            for it in meal.items {
                let qtyStr: String
                if it.unit == "g" { qtyStr = "\(Int(it.quantity)) g" }
                else if it.unit == "ml" { qtyStr = "\(Int(it.quantity)) ml" }
                else { qtyStr = "\(Int(it.quantity)) \(it.unit)" }
                print("     - \(it.name): \(qtyStr) → \(it.kcal) kcal")
            }
        }
    }
    // aggregated shopping items
    print("\n=== Lista de compras agregada (quantidades aproximadas) ===")
    let computed = computeCostForAggregated()
    var totalCost: Double = 0.0
    for (name, qty, unit, cost) in computed {
        totalCost += cost
        let displayQty: String
        if unit == "g" {
            if qty >= 1000 {
                displayQty = String(format: "%.2f kg", qty / 1000.0)
            } else {
                displayQty = "\(Int(qty)) g"
            }
        } else if unit == "ml" {
            displayQty = String(format: "%.0f ml", qty)
        } else { displayQty = "\(Int(qty)) \(unit)" }
        print(String(format: " • %-25s %10s   R$ %.2f", name, displayQty, cost) as NSString)
    }
    print(String(format: "\nCusto total estimado da semana: R$ %.2f", totalCost))
}

// Run
printWeeklySummary()
