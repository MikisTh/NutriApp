import SwiftUI

struct ShoppingListView: View {
    let week: [DayMenu]
    @StateObject var vm = ShoppingViewModel()
    var body: some View {
        List {
            ForEach(vm.items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("\(String(format: \"%.0f\", item.quantity)) \(item.unit)")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Lista de Compras")
        .onAppear {
            vm.generate(from: week)
        }
    }
}
