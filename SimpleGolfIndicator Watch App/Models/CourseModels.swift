import Foundation

// MARK: - 코스 데이터 모델
struct CountryClub: Codable, Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let courses: [Course]
    let location: Location
    
    enum CodingKeys: String, CodingKey {
        case name, courses, location
    }
    
    // Hashable 구현
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable 구현
    static func == (lhs: CountryClub, rhs: CountryClub) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Course: Codable, Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let holes: [Hole]
    
    enum CodingKeys: String, CodingKey {
        case name, holes
    }
    
    // Hashable 구현
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable 구현
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Hole: Codable, Identifiable, Hashable, Equatable {
    let id = UUID()
    let num: Int
    let par: Int
    let distance: Int
    let elevation: Double
    let holeImage: String
    let greenImage: String
    
    enum CodingKeys: String, CodingKey {
        case num, par, distance, elevation, holeImage, greenImage
    }
    
    // Hashable 구현
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable 구현
    static func == (lhs: Hole, rhs: Hole) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Location: Codable, Hashable, Equatable {
    let latitude: Double
    let longitude: Double
}
