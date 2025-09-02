import SwiftUI

// MARK: - 메인 화면
struct MainView: View {
    @ObservedObject var courseDataService: CourseDataService
    @StateObject private var weatherService = WeatherService()
    @StateObject private var compassService = CompassService()
    @Binding var selectedCountryClub: CountryClub?
    @Binding var selectedCourse: Course?
    @Binding var selectedHole: Hole?
    @Binding var showingModal: Bool
    
    var body: some View {
        ZStack {
            
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.y < -50 && !showingModal {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingModal = true
                        }
                    }
                }
        )
        .onChange(of: selectedCountryClub) { newCountryClub in
            if let countryClub = newCountryClub {
                // 선택된 CC의 위치로 날씨 데이터 가져오기 시작
                weatherService.startAutoRefresh(
                    latitude: countryClub.location.latitude,
                    longitude: countryClub.location.longitude
                )
            } else {
                weatherService.stopAutoRefresh()
            }
        }
    }
}
