import SwiftUI

struct HomeView: View {
    @StateObject var vm = MenuViewModel()
    @StateObject var shoppingVM = ShoppingViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Semana")) {
                    ForEach(vm.week) { day in
                        NavigationLink(destination: DayMenuView(day: day)) {
                            HStack {
                                Text(day.dayName)
                                Spacer()
                                Text("\(day.totalKcal) kcal")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink("Lista de Compras", destination: ShoppingListView(week: vm.week))
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Cardápio Semanal")
            .onAppear {
                shoppingVM.generate(from: vm.week)
            }
        }
    }
}
