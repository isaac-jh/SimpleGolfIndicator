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
    
    // 캐러셀을 위한 현재 홀 인덱스
    @State private var currentHoleIndex: Int = 0
    // 그린 이미지 모달 표시 여부
    @State private var showingGreenModal = false
    
    private let badgeDiameter: CGFloat = 54
    private let badgeCorner: CGFloat = 12
    private var badgeWidth: CGFloat { badgeDiameter * 1.3 }
    
    var body: some View {
        ZStack {
            backgroundView
            
            // 중앙 콘텐츠
            HStack(spacing: 0) {
                leftPaneView
                rightPaneView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: selectedHole) { _, newHole in
            // 홀 선택 시 캐러셀 인덱스 초기화
            if let course = selectedCourse, let hole = newHole {
                currentHoleIndex = course.holes.firstIndex(where: { $0.num == hole.num }) ?? 0
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height < -50 && !showingModal {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingModal = true
                        }
                    }
                }
        )
        .onChange(of: selectedCountryClub) { _, newCountryClub in
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
    
    // 현재 캐러셀에 표시되는 홀 정보를 반환
    private func getCurrentHole() -> Hole? {
        guard let course = selectedCourse, currentHoleIndex < course.holes.count else { return nil }
        return course.holes[currentHoleIndex]
    }
    
    // 분리된 서브뷰들
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.4, green: 0.8, blue: 0.4),
                Color(red: 0.2, green: 0.4, blue: 0.2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private func roundedBadge<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: badgeCorner, style: .continuous)
                .fill(Color.black)
                .frame(width: badgeDiameter * 1.3, height: badgeDiameter * 0.4)
            content()
        }
    }
    
    private var leftPaneView: some View {
        VStack {
            VStack(spacing: 4) {
                // 코스명
                roundedBadge {
                    Text(selectedCourse?.name ?? "-")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                
                // 홀 넘버
                roundedBadge {
                    Text("Hole \(getCurrentHole()?.num ?? 1)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                
                // 파
                roundedBadge {
                    Text("Par \(getCurrentHole()?.par ?? 4)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                
                // 홀 전장
                roundedBadge {
                    Text("\(getCurrentHole()?.distance ?? 375)m")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                
                // 고도차
                roundedBadge {
                    let elevation = getCurrentHole()?.elevation ?? 0
                    let isUphill = elevation > 0
                    let color: Color = isUphill ? .red : .blue
                    HStack(spacing: 2) {
                        Image(systemName: isUphill ? "arrow.up" : "arrow.down")
                        Text(String(format: "%.1f", abs(elevation)))
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                }
            }
            .frame(maxWidth: .infinity)
            
            // 나침반/풍향풍속 뷰
            CompassWindView(
                compassService: compassService,
                weatherService: weatherService
            )
            .frame(width: 50, height: 50)
            .padding(.horizontal, 6)
            .padding(.bottom, 4)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var rightPaneView: some View {
        VStack {
            if let course = selectedCourse, currentHoleIndex < course.holes.count {
                // 홀 이미지
                Button(action: { showingGreenModal = true }) {
                    Image(course.holes[currentHoleIndex].holeImage)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showingGreenModal) {
                    Image(course.holes[currentHoleIndex].greenImage)
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(-compassService.heading), anchor: .center)
                        .padding(16)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if let course = selectedCourse {
                        if value.translation.width < -50 && currentHoleIndex < course.holes.count - 1 {
                            // 왼쪽 스와이프 - 다음 홀
                            withAnimation(.easeInOut(duration: 0.3)) { currentHoleIndex += 1 }
                        } else if value.translation.width > 50 && currentHoleIndex > 0 {
                            // 오른쪽 스와이프 - 이전 홀
                            withAnimation(.easeInOut(duration: 0.3)) { currentHoleIndex -= 1 }
                        }
                    }
                }
        )
    }
}
