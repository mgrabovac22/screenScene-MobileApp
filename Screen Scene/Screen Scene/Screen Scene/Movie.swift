import SwiftData

@Model
class Movie {
    @Attribute(.primaryKey) var id: UUID
    @Attribute(.required) var title: String
    @Attribute(.required) var year: Int
    @Attribute(.optional) var genre: String?
    @Attribute(.optional) var description: String?
    
    init(title: String, year: Int, genre: String? = nil, description: String? = nil) {
        self.id = UUID()
        self.title = title
        self.year = year
        self.genre = genre
        self.description = description
    }
}

