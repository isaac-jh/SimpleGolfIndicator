import Foundation

// MARK: - 골프 코스 서비스
class GolfCourseService: ObservableObject {
    @Published var golfCourse: GolfCourse?
    @Published var isLoading = false
    @Published var error: String?
    
    init() {
        loadGolfCourseData()
    }
    
    // MARK: - 골프 코스 데이터 로드
    private func loadGolfCourseData() {
        isLoading = true
        error = nil
        
        // course.json 파일에서 데이터 로드
        if let loadedCourse = GolfCourse.loadFromBundle() {
            self.golfCourse = loadedCourse
            self.isLoading = false
        } else {
            // JSON 로드 실패 시 샘플 데이터 사용
            self.golfCourse = GolfCourse.sampleData
            self.error = "course.json 파일을 로드할 수 없어 샘플 데이터를 사용합니다."
            self.isLoading = false
        }
    }
    
    // MARK: - 데이터 새로고침
    func refreshData() {
        loadGolfCourseData()
    }
    
    // MARK: - 사용 가능한 CC 목록 반환
    func getAvailableCCs() -> [String] {
        guard let golfCourse = golfCourse else { return [] }
        return [golfCourse.name]
    }
    
    // MARK: - 선택된 CC의 사용 가능한 코스 목록 반환
    func getAvailableCourses(for cc: String) -> [Course] {
        guard let golfCourse = golfCourse, golfCourse.name == cc else { return [] }
        return golfCourse.courses
    }
    
    // MARK: - 선택된 코스의 사용 가능한 홀 목록 반환
    func getAvailableHoles(for course: Course) -> [Hole] {
        return course.holes
    }
    
    // MARK: - 특정 홀 정보 반환
    func getHole(courseName: String, holeNumber: Int) -> Hole? {
        guard let golfCourse = golfCourse else { return nil }
        
        for course in golfCourse.courses {
            if course.name == courseName {
                return course.holes.first { $0.num == holeNumber }
            }
        }
        return nil
    }
}
