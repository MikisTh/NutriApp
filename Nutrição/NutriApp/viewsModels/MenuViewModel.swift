import Foundation
import SwiftUI

final class MenuViewModel: ObservableObject {
    @Published var week: [DayMenu] = []
    init() {
        week = DataProvider.sampleWeek()
    }
}
