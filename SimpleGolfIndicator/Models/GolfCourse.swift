import Foundation
import CoreLocation

struct GolfCourse: Identifiable, Codable {
    let id = UUID()
    let name: String
    let courses: [Course]
    let location: Location
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}

struct Course: Identifiable, Codable {
    let id = UUID()
    let name: String
    let holes: [Hole]
}

struct Hole: Identifiable, Codable {
    let id = UUID()
    let num: Int
    let par: Int
    let distance: Int
    let elevation: Int
    let holeImage: String?
    let greenImage: String?
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

// MARK: - Preview용 최소 샘플 데이터
extension GolfCourse {
    static let sampleData = GolfCourse(
        name: "부여CC",
        courses: [
            Course(
                name: "SKY",
                holes: [
                    Hole(num: 1, par: 4, distance: 375, elevation: 22, holeImage: nil, greenImage: nil),
                    Hole(num: 2, par: 5, distance: 450, elevation: 15, holeImage: nil, greenImage: nil)
                ]
            )
        ],
        location: Location(latitude: 36.2754, longitude: 126.9094)
    )
}
