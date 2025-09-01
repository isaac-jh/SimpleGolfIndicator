import Foundation
import CoreLocation

// MARK: - 골프 코스 데이터 모델
struct GolfCourse: Codable {
    let name: String
    let courses: [Course]
    let location: Location
}

struct Course: Codable {
    let name: String
    let holes: [Hole]
}

struct Hole: Identifiable, Codable {
    let id = UUID()
    let num: Int
    let par: Int
    let distance: Int
    let elevation: Int
    let holeImage: String
    let greenImage: String
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - JSON 파일에서 GolfCourse 로드
extension GolfCourse {
    /// Config 디렉토리의 course.json 파일에서 골프 코스 데이터를 로드합니다
    static func loadFromBundle() -> GolfCourse? {
        guard let url = Bundle.main.url(forResource: "course", withExtension: "json", subdirectory: "Config") else {
            print("❌ course.json 파일을 찾을 수 없습니다")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let golfCourse = try JSONDecoder().decode(GolfCourse.self, from: data)
            print("✅ course.json 파일을 성공적으로 로드했습니다: \(golfCourse.name)")
            return golfCourse
        } catch {
            print("❌ course.json 파싱 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 현재 선택된 홀을 반환합니다
    func getCurrentHole(from selectedHole: Hole) -> Hole? {
        for course in courses {
            if let hole = course.holes.first(where: { $0.num == selectedHole.num }) {
                return hole
            }
        }
        return nil
    }
}

// MARK: - Preview용 최소 샘플 데이터 (JSON 로드 실패 시 폴백)
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
