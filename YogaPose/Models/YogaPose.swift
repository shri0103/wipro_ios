
import Foundation

struct YogaPose: Identifiable {

    var id = UUID()

    var name: String
    var sanskritName: String
    var category: String
    var difficulty: String

    var holdTime: Int
    var benefits: String
    var precautions: String

    var practiceCount: Int = 0
    var lastPracticedDate: Date? = nil
    var dateAdded: Date = Date()
}

