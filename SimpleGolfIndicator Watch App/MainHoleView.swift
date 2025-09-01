import SwiftUI
import CoreLocation
import WatchKit

struct MainHoleView: View {
    let selectedCourse: Course
    let selectedHole: Hole
    let selectedGolfCourse: GolfCourse
    
    @StateObject private var weatherService = WeatherService()
    @StateObject private var locationManager = LocationManager()
    
    // 상태 변수들
    @State private var showModal = false
    @State private var showGreenModal = false
    @State private var currentHoleIndex: Int
    @State private var dragOffset = CGSize.zero
    
    init(selectedCourse: Course, selectedHole: Hole, selectedGolfCourse: GolfCourse) {
        self.selectedCourse = selectedCourse
        self.selectedHole = selectedHole
        self.selectedGolfCourse = selectedGolfCourse
        
        // 초기 홀 인덱스 설정
        if let index = selectedCourse.holes.firstIndex(where: { $0.id == selectedHole.id }) {
            self._currentHoleIndex = State(initialValue: index)
        } else {
            self._currentHoleIndex = State(initialValue: 0)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 잔디 배경
                GrassBackground()
                
                HStack(alignment: .center) {
                    // 왼쪽 영역 - 정보 카드들
                    VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 6)) {
                        // 코스 정보
                        VStack {
                            InfoCard {
                                VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 2)) {
                                    Text(selectedCourse.name)
                                        .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 11), weight: .bold))
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    
                                    Text("\(getCurrentHole().num)홀")
                                        .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 9), weight: .medium))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                }
                            }
                            
                            // 파 정보
                            InfoCard {
                                VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 2)) {
                                    Text("Par \(getCurrentHole().par)")
                                        .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 13), weight: .bold))
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            // 거리 정보
                            InfoCard {
                                VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 2)) {
                                    Text("\(getCurrentHole().distance)m")
                                        .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 14), weight: .bold))
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            // 고도차 정보
                            InfoCard {
                                VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 2)) {
                                    HStack(spacing: 2) {
                                        Image(systemName: getCurrentHole().elevation >= 0 ? "arrow.up" : "arrow.down")
                                            .foregroundColor(getCurrentHole().elevation >= 0 ? Color(red: 0.8, green: 0.2, blue: 0.2) : Color(red: 0.4, green: 0.6, blue: 0.9))
                                            .font(.system(size: DeviceSizeHelper.getIconSize(baseSize: 9)))
                                        
                                        Text("\(abs(getCurrentHole().elevation))m")
                                            .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 14), weight: .bold))
                                            .foregroundColor(getCurrentHole().elevation >= 0 ? Color(red: 0.8, green: 0.2, blue: 0.2) : Color(red: 0.4, green: 0.6, blue: 0.9))
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // 통합 나침반/풍향 뷰
                        IntegratedCompassWindView(
                            heading: locationManager.heading?.trueHeading ?? 0,
                            windDirection: getWindArrowRotation(),
                            windSpeed: weatherService.weatherData?.windSpeed ?? 0.0,
                            size: geometry.size.width * 0.25
                        )
                    }
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height)
                    
                    // 오른쪽 영역 - 홀 이미지
                    ZStack {
                        // 홀 이미지
                        holeImageView
                            .frame(width: geometry.size.width * 0.60, height: geometry.size.height)
                            .gesture(
                                TapGesture()
                                    .onEnded {
                                        showGreenModal = true
                                    }
                            )
                            .offset(dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        handleSwipeGesture(value)
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            dragOffset = .zero
                                        }
                                    }
                            )
                    }
                    .frame(width: geometry.size.width * 0.60, height: geometry.size.height)
                }
            }
        }
        .sheet(isPresented: $showModal) {
            HoleSelectionModal(
                isPresented: $showModal,
                selectedCourse: selectedCourse,
                selectedHole: selectedHole,
                selectedGolfCourse: selectedGolfCourse
            )
        }
        .sheet(isPresented: $showGreenModal) {
            GreenImageModal(
                isPresented: $showGreenModal,
                selectedHole: getCurrentHole(),
                heading: locationManager.heading?.trueHeading ?? 0
            )
        }

        .onAppear {
            loadWeatherData()
            locationManager.startUpdatingHeading()
        }
        .onDisappear {
            locationManager.stopUpdatingHeading()
        }
    }
    
    // MARK: - 홀 이미지 뷰 (회전 효과 제거)
    private var holeImageView: some View {
        Group {
            if !getCurrentHole().holeImage.isEmpty {
                // 홀 이미지 표시 (번들 이미지)
                Image(getCurrentHole().holeImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
            } else {
                // 플레이스홀더
                placeholderHoleView
            }
        }
        .shadow(radius: 15, x: 0, y: 8)
    }
    
    private var placeholderHoleView: some View {
        ImagePlaceholderView(
            icon: "flag.filled",
            title: "\(getCurrentHole().num)번 홀",
            subtitle: "파 \(getCurrentHole().par)",
            backgroundColor: .green,
            iconColor: .red
        )
    }
    
    // MARK: - 현재 홀 정보 가져오기
    private func getCurrentHole() -> Hole {
        guard currentHoleIndex >= 0 && currentHoleIndex < selectedCourse.holes.count else {
            return selectedHole
        }
        return selectedCourse.holes[currentHoleIndex]
    }
    
    // MARK: - Helper Methods
    private func getWindArrowRotation() -> Double {
        guard let weather = weatherService.weatherData else { return 0 }
        let wind = weather.rawWindDegrees
        let heading = locationManager.heading?.trueHeading ?? 0
        let relative = fmod((wind - heading) + 360, 360)
        return relative
    }
    
    private func loadWeatherData() {
        weatherService.fetchWeatherData(for: CLLocationCoordinate2D(latitude: selectedGolfCourse.location.latitude, longitude: selectedGolfCourse.location.longitude))
    }
    
    // MARK: - 스와이프 제스처 처리
    private func handleSwipeGesture(_ value: DragGesture.Value) {
        let horizontalThreshold: CGFloat = 100
        let verticalThreshold: CGFloat = 50
        
        if abs(value.translation.width) > horizontalThreshold && abs(value.translation.height) < verticalThreshold {
            // 좌우 스와이프
            if value.translation.width > 0 {
                // 오른쪽으로 스와이프 - 이전 홀
                goToPreviousHole()
            } else {
                // 왼쪽으로 스와이프 - 다음 홀
                goToNextHole()
            }
        }
    }
    
    // MARK: - 홀 이동 함수들
    private func goToNextHole() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentHoleIndex < selectedCourse.holes.count - 1 {
                currentHoleIndex += 1
            } else {
                // 마지막 홀이면 첫 번째 홀로
                currentHoleIndex = 0
            }
        }
    }
    
    private func goToPreviousHole() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentHoleIndex > 0 {
                currentHoleIndex -= 1
            } else {
                // 첫 번째 홀이면 마지막 홀로
                currentHoleIndex = selectedCourse.holes.count - 1
            }
        }
    }
}

#Preview {
    MainHoleView(
        selectedCourse: GolfCourse.sampleData.courses[0],
        selectedHole: GolfCourse.sampleData.courses[0].holes[0],
        selectedGolfCourse: GolfCourse.sampleData
    )
}


