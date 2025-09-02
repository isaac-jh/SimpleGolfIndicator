import SwiftUI

@main
struct SimpleGolfIndicatorApp: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
    }
}

struct MainAppView: View {
    @StateObject private var courseDataService = CourseDataService()
    @State private var selectedCountryClub: CountryClub?
    @State private var selectedCourse: Course?
    @State private var selectedHole: Hole?
    @State private var showInitialModal = true
    @State private var showingModal = false
    
    var body: some View {
        ZStack {
            // 메인 화면
            MainView(
                courseDataService: courseDataService,
                selectedCountryClub: $selectedCountryClub,
                selectedCourse: $selectedCourse,
                selectedHole: $selectedHole,
                showingModal: $showingModal
            )
            
            // 초기 모달 (앱 시작 시 표시)
            if showInitialModal {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    CourseSelectionModal(
                        courseDataService: courseDataService,
                        isPresented: $showInitialModal,
                        selectedCountryClub: $selectedCountryClub,
                        selectedCourse: $selectedCourse,
                        selectedHole: $selectedHole
                    )
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .onAppear {
            courseDataService.loadCourseData()
        }
    }
}
