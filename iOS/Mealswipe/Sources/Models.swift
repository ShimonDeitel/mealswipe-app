import Foundation

struct Log: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var note: String
    var swipesUsed: Int
    var dollarsSpent: Double

    init(id: UUID = UUID(), createdAt: Date = Date(), note: String, swipesUsed: Int, dollarsSpent: Double) {
        self.id = id
        self.createdAt = createdAt
        self.note = note
        self.swipesUsed = swipesUsed
        self.dollarsSpent = dollarsSpent
    }
}
