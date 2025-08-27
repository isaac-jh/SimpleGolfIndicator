import SwiftUI
import CoreLocation

struct MainHoleView: View {
    let selectedCourse: Course
    let selectedHole: Hole
    let selectedGolfCourse: GolfCourse
    
    @StateObject private var weatherService = WeatherService()
    @StateObject private var locationManager = LocationManager()
    
    // 상태 변수들
    @State private var showModal = false
    @State private var currentHoleIndex: Int
    @State private var showingGreenImage = false
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
                
                VStack(spacing: 0) {
                    // 상단 정보 바
                    HStack {
                        // 왼쪽 위 - 고도차
                        InfoCard {
                            InfoDisplayView(
                                title: "고도차",
                                value: "\(abs(getCurrentHole().elevation))m",
                                icon: getCurrentHole().elevation >= 0 ? "arrow.up" : "arrow.down",
                                iconColor: getCurrentHole().elevation >= 0 ? .green : .red
                            )
                        }
                        
                        Spacer()
                        
                        // 중앙 - 코스 이름
                        courseNameView
                        
                        Spacer()
                        
                        // 오른쪽 위 - 거리
                        InfoCard {
                            InfoDisplayView(
                                title: "거리",
                                value: "\(getCurrentHole().distance)m",
                                icon: "ruler",
                                iconColor: .green
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // 중앙 홀 이미지 (제스처 적용)
                    ZStack {
                        // 홀 넘버 배경 (이미지 뒷쪽)
                        Text("\(getCurrentHole().num)")
                            .font(.system(size: 120, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                        
                        // 홀 이미지
                        holeImageView
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                            .gesture(
                                TapGesture()
                                    .onEnded {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showingGreenImage.toggle()
                                        }
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
                    
                    Spacer()
                    
                    // 하단 정보 바
                    HStack {
                        // 왼쪽 아래 - 풍향 풍속
                        windInfoView
                        
                        Spacer()
                        
                        // 오른쪽 아래 - 나침반
                        compassView
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                
                // 위로 스와이프 제스처 감지 영역
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 100)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.y < -50 && abs(value.translation.x) < 100 {
                                    showModal = true
                                }
                            }
                    )
            }
        }
        .navigationTitle("\(getCurrentHole().num)번 홀")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadWeatherData()
            locationManager.startUpdatingHeading()
        }
        .onDisappear {
            locationManager.stopUpdatingHeading()
        }
        .sheet(isPresented: $showModal) {
            HoleSelectionModal(
                isPresented: $showModal,
                selectedCourse: selectedCourse,
                selectedHole: Binding(
                    get: { getCurrentHole() },
                    set: { _ in }
                ),
                selectedGolfCourse: selectedGolfCourse
            )
        }
    }
    
    // MARK: - 코스 이름 뷰
    private var courseNameView: some View {
        VStack(spacing: 4) {
            Text("코스")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(selectedCourse.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground).opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - 현재 홀 정보 가져오기
    private func getCurrentHole() -> Hole {
        guard currentHoleIndex >= 0 && currentHoleIndex < selectedCourse.holes.count else {
            return selectedHole
        }
        return selectedCourse.holes[currentHoleIndex]
    }
    
    // MARK: - 스와이프 제스처 처리
    private func handleSwipeGesture(_ value: DragGesture.Value) {
        let horizontalThreshold: CGFloat = 100
        let verticalThreshold: CGFloat = 50
        
        if abs(value.translation.x) > horizontalThreshold && abs(value.translation.y) < verticalThreshold {
            // 좌우 스와이프
            if value.translation.x > 0 {
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
            showingGreenImage = false
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
            showingGreenImage = false
        }
    }
    
    // MARK: - 홀 이미지 뷰
    private var holeImageView: some View {
        Group {
            if showingGreenImage, let greenImageUrl = getCurrentHole().greenImage, !greenImageUrl.isEmpty {
                // 그린 이미지 표시
                AsyncImage(url: URL(string: greenImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                } placeholder: {
                    placeholderGreenView
                }
            } else if let holeImageUrl = getCurrentHole().holeImage, !holeImageUrl.isEmpty {
                // 홀 이미지 표시
                AsyncImage(url: URL(string: holeImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                } placeholder: {
                    placeholderHoleView
                }
            } else {
                // 플레이스홀더
                showingGreenImage ? placeholderGreenView : placeholderHoleView
            }
        }
        .shadow(radius: 15, x: 0, y: 8)
        .overlay(
            // 이미지 전환 힌트
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: showingGreenImage ? "flag.filled" : "circle.grid.3x3")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                        
                        Text(showingGreenImage ? "홀 이미지" : "그린 이미지")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                }
                Spacer()
            }
        )
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
    
    private var placeholderGreenView: some View {
        ImagePlaceholderView(
            icon: "circle.grid.3x3",
            title: "그린",
            subtitle: "\(getCurrentHole().num)번 홀",
            backgroundColor: .blue,
            iconColor: .blue
        )
    }
    
    // MARK: - 풍향 풍속 뷰
    private var windInfoView: some View {
        VStack(spacing: 8) {
            Text("풍향")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack {
                // 애니메이션된 원형 배경
                AnimatedCircleBackground(color: .blue, size: 80)
                
                // 향상된 눈금
                EnhancedTickMarks(color: .blue, size: 80)
                
                // 커스텀 풍향 화살표 (부드러운 회전)
                WindArrow(direction: getWindArrowRotation(), size: 50)
            }
            
            if let weather = weatherService.weatherData {
                Text("\(String(format: "%.1f", weather.windSpeed)) m/s")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground).opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - 나침반 뷰
    private var compassView: some View {
        VStack(spacing: 8) {
            Text("방향")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack {
                // 애니메이션된 원형 배경
                AnimatedCircleBackground(color: .orange, size: 80)
                
                // 향상된 눈금
                EnhancedTickMarks(color: .orange, size: 80)
                
                // 커스텀 나침반 바늘
                CompassNeedle(heading: locationManager.heading?.trueHeading ?? 0, size: 50)
            }
            
            if let heading = locationManager.heading {
                Text("\(String(format: "%.0f", heading.trueHeading))°")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground).opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
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
        weatherService.fetchWeatherData(for: selectedGolfCourse.coordinate)
    }
}

#Preview {
    MainHoleView(
        selectedCourse: GolfCourse.sampleData.courses[0],
        selectedHole: GolfCourse.sampleData.courses[0].holes[0],
        selectedGolfCourse: GolfCourse.sampleData
    )
}
