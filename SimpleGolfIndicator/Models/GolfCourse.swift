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
    let holeImage: String // 번들 이미지 이름 (예: "hole_1_1")
    let greenImage: String // 번들 이미지 이름 (예: "green_1_1")
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
                    Hole(num: 1, par: 4, distance: 375, elevation: 22, holeImage: "sky_1", greenImage: "sky_g_1"),
                    Hole(num: 2, par: 5, distance: 450, elevation: 15, holeImage: "sky_2", greenImage: "sky_g_2")
                ]
            ),
            Course(
                name: "HILL",
                holes: [
                    Hole(num: 1, par: 4, distance: 380, elevation: 18, holeImage: "hill_1", greenImage: "hill_g_1"),
                    Hole(num: 2, par: 3, distance: 320, elevation: 25, holeImage: "hill_2", greenImage: "hill_g_2")
                ]
            )
        ],
        location: Location(latitude: 36.2754, longitude: 126.9094)
    )
}
