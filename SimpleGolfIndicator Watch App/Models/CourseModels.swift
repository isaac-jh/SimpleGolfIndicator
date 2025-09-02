import Foundation

// MARK: - 코스 데이터 모델
struct CountryClub: Codable, Identifiable {
    let id = UUID()
    let name: String
    let courses: [Course]
    let location: Location
    
    enum CodingKeys: String, CodingKey {
        case name, courses, location
    }
}

struct Course: Codable, Identifiable {
    let id = UUID()
    let name: String
    let holes: [Hole]
    
    enum CodingKeys: String, CodingKey {
        case name, holes
    }
}

struct Hole: Codable, Identifiable {
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
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}
