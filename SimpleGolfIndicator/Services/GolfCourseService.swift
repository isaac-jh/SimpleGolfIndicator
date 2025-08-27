import Foundation
import Combine

class GolfCourseService: ObservableObject {
    @Published var golfCourse: GolfCourse?
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let cache = NSCache<NSString, CachedData>()
    
    init() {
        loadGolfCourseData()
    }
    
    func loadGolfCourseData() {
        isLoading = true
        error = nil
        
        // 캐시된 데이터 확인
        if let cachedData = getCachedData() {
            self.golfCourse = cachedData.golfCourse
            self.isLoading = false
            return
        }
        
        // 원격에서 데이터 가져오기
        fetchGolfCourseData()
    }
    
    private func fetchGolfCourseData() {
        guard let url = URL(string: AppConfig.golfCourseDataURL) else {
            handleError("잘못된 URL입니다")
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = AppConfig.requestTimeout
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: GolfCourse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] golfCourse in
                    self?.golfCourse = golfCourse
                    self?.cacheData(golfCourse)
                }
            )
            .store(in: &cancellables)
    }
    
    private func handleError(_ message: String) {
        error = message
        isLoading = false
        
        // 에러 로깅
        if AppConfig.enableLogging {
            print("GolfCourseService Error: \(message)")
        }
        
        // 샘플 데이터로 폴백
        fallbackToSampleData()
    }
    
    private func fallbackToSampleData() {
        golfCourse = GolfCourse.sampleData
        if AppConfig.enableLogging {
            print("Using fallback sample data")
        }
    }
    
    // MARK: - Caching
    private func cacheData(_ golfCourse: GolfCourse) {
        let cachedData = CachedData(
            golfCourse: golfCourse,
            timestamp: Date()
        )
        cache.setObject(cachedData, forKey: "golfCourseData")
    }
    
    private func getCachedData() -> CachedData? {
        guard let cachedData = cache.object(forKey: "golfCourseData") else {
            return nil
        }
        
        // 캐시 만료 확인
        let timeSinceCache = Date().timeIntervalSince(cachedData.timestamp)
        if timeSinceCache > AppConfig.cacheExpirationTime {
            cache.removeObject(forKey: "golfCourseData")
            return nil
        }
        
        return cachedData
    }
    
    // MARK: - Public Methods
    func refreshData() {
        cache.removeObject(forKey: "golfCourseData")
        loadGolfCourseData()
    }
    
    func getAvailableCCs() -> [String] {
        guard let golfCourse = golfCourse else { return [] }
        return [golfCourse.name]
    }
    
    func getAvailableCourses(for cc: String) -> [Course] {
        guard let golfCourse = golfCourse, golfCourse.name == cc else { return [] }
        return golfCourse.courses
    }
    
    func getAvailableHoles(for course: Course) -> [Hole] {
        return course.holes
    }
}

// MARK: - Cache Data Structure
private class CachedData {
    let golfCourse: GolfCourse
    let timestamp: Date
    
    init(golfCourse: GolfCourse, timestamp: Date) {
        self.golfCourse = golfCourse
        self.timestamp = timestamp
    }
}
