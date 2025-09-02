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
            if showInitialModal {
                CourseSelectionModal(
                    courseDataService: courseDataService,
                    isPresented: $showInitialModal,
                    selectedCountryClub: $selectedCountryClub,
                    selectedCourse: $selectedCourse,
                    selectedHole: $selectedHole
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .bottom))
            }

            // 메인 화면
            if !showInitialModal {
                MainView(
                    courseDataService: courseDataService,
                    selectedCountryClub: $selectedCountryClub,
                    selectedCourse: $selectedCourse,
                    selectedHole: $selectedHole,
                    showingModal: $showingModal
                )
                .transition(.move(edge: .bottom))
                .disabled(showInitialModal)
            }
        }
        .onAppear {
            courseDataService.loadCourseData()
        }
    }
}
