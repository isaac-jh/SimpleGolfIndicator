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
    
    var number: Int { num }
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

// MARK: - Sample Data for Preview
extension GolfCourse {
    static let sampleData = GolfCourse(
        name: "부여CC",
        courses: [
            Course(
                name: "SKY",
                holes: Array(1...9).map { holeNum in
                    Hole(
                        num: holeNum,
                        par: 3 + (holeNum % 3),
                        distance: 300 + (holeNum % 4) * 50,
                        elevation: 5 + (holeNum % 4) * 2,
                        holeImage: nil,
                        greenImage: nil
                    )
                }
            ),
            Course(
                name: "OCEAN",
                holes: Array(1...9).map { holeNum in
                    Hole(
                        num: holeNum,
                        par: 3 + (holeNum % 3),
                        distance: 320 + (holeNum % 4) * 55,
                        elevation: 3 + (holeNum % 4) * 3,
                        holeImage: nil,
                        greenImage: nil
                    )
                }
            )
        ],
        location: Location(latitude: 36.2754, longitude: 126.9094)
    )
}
