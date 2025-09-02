import Foundation

// MARK: - 코스 데이터 로딩 서비스
class CourseDataService: ObservableObject {
    @Published var countryClubs: [CountryClub] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    /// 코스 데이터를 로드하고 파싱합니다
    func loadCourseData() {
        isLoading = true
        errorMessage = nil
        
        guard let url = Bundle.main.url(forResource: "course", withExtension: "json") else {
            errorMessage = "코스 데이터 파일을 찾을 수 없습니다"
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            countryClubs = try decoder.decode([CountryClub].self, from: data)
            isLoading = false
        } catch {
            errorMessage = "코스 데이터 파싱에 실패했습니다: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// 선택된 CC의 코스 목록을 반환합니다
    func getCourses(for countryClub: CountryClub?) -> [Course] {
        return countryClub?.courses ?? []
    }
    
    /// 선택된 코스의 홀 목록을 반환합니다
    func getHoles(for course: Course?) -> [Hole] {
        return course?.holes ?? []
    }
}
