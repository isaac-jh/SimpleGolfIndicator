import Foundation
import CoreLocation

struct GolfCourse: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let cc: String
    let location: CLLocationCoordinate2D
    
    static let sampleCourses = [
        GolfCourse(name: "부여 CC", cc: "부여 CC", location: CLLocationCoordinate2D(latitude: 36.2754, longitude: 126.9094)),
        GolfCourse(name: "SKY", cc: "SKY", location: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)),
        GolfCourse(name: "서울 CC", cc: "서울 CC", location: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)),
        GolfCourse(name: "부산 CC", cc: "부산 CC", location: CLLocationCoordinate2D(latitude: 35.1796, longitude: 129.0756))
    ]
}

struct Hole: Identifiable {
    let id = UUID()
    let number: Int
    let par: Int
    let distance: [String: Int] // 티 색상별 거리
    let elevation: Int
    let hazards: [String]
    
    static let sampleHoles = Array(1...18).map { holeNumber in
        Hole(
            number: holeNumber,
            par: 3 + (holeNumber % 3),
            distance: [
                "Red": 120 + (holeNumber % 4) * 20,
                "Yellow": 140 + (holeNumber % 4) * 25,
                "White": 160 + (holeNumber % 4) * 30,
                "Blue": 180 + (holeNumber % 4) * 35,
                "Black": 200 + (holeNumber % 4) * 40
            ],
            elevation: 5 + (holeNumber % 4) * 2,
            hazards: ["벙커", "워터해저드", "나무"].shuffled().prefix(2).map { $0 }
        )
    }
}
