import Foundation

struct ShoppingItem: Identifiable {
    let id = UUID()
    let name: String
    var quantity: Double
    var unit: String
}

