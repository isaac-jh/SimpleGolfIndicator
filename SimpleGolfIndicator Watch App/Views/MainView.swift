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
    
    var body: some View {
        ZStack {
            // 잔디색 배경
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.6, blue: 0.2), // 진한 잔디색
                    Color(red: 0.4, green: 0.8, blue: 0.4)  // 밝은 잔디색
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 중앙 콘텐츠
            HStack(spacing: 0) {
                // 좌측 50% 영역
                VStack {
                    VStack(spacing: 12) {
                        // 코스명
                        Text(selectedCourse?.name ?? "SKY")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                        
                        // 홀 넘버
                        Text("Hole \(getCurrentHole()?.num ?? 1)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                        
                        // 파
                        Text("Par \(getCurrentHole()?.par ?? 4)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                        
                        // 홀 전장
                        Text("\(getCurrentHole()?.distance ?? 375)m")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                        
                        // 고도차
                        HStack(spacing: 4) {
                            if let elevation = getCurrentHole()?.elevation {
                                if elevation > 0 {
                                    // 오르막
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.red)
                                        .font(.system(size: 16, weight: .bold))
                                    Text("\(String(format: "%.1f", elevation))m")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.red)
                                } else {
                                    // 내리막
                                    Image(systemName: "arrow.down")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 16, weight: .bold))
                                    Text("\(String(format: "%.1f", abs(elevation)))m")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Text("0.0m")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 80, height: 40)
                        .background(Color.black)
                        .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // 나침반/풍향풍속 뷰
                    CompassWindView(
                        compassService: compassService,
                        weatherService: weatherService
                    )
                }
                .frame(maxWidth: .infinity)
                
                // 우측 50% 영역 - 홀 이미지 캐러셀
                VStack {
                    if let course = selectedCourse {
                        // 홀 이미지
                        Image(course.holes[currentHoleIndex].holeImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .onTapGesture {
                                showingGreenModal = true
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if let course = selectedCourse {
                                if value.translation.x < -50 && currentHoleIndex < course.holes.count - 1 {
                                    // 왼쪽 스와이프 - 다음 홀
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentHoleIndex += 1
                                    }
                                } else if value.translation.x > 50 && currentHoleIndex > 0 {
                                    // 오른쪽 스와이프 - 이전 홀
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentHoleIndex -= 1
                                    }
                                }
                            }
                        }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 그린 이미지 모달
            if showingGreenModal {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingGreenModal = false
                        }
                    }
                
                HStack {
                    Spacer()
                    
                    VStack {
                        if let course = selectedCourse {
                            // 그린 이미지 (나침반과 함께 회전)
                            Image(course.holes[currentHoleIndex].greenImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 160, height: 160)
                                .rotationEffect(.degrees(compassService.heading), anchor: .center)
                                .clipped()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding()
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.x > 50 {
                                    // 우측 스와이프로 모달 닫기
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingGreenModal = false
                                    }
                                }
                            }
                    )
                    .transition(.move(edge: .trailing))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: selectedHole) { newHole in
            // 홀 선택 시 캐러셀 인덱스 초기화
            if let course = selectedCourse, let hole = newHole {
                currentHoleIndex = course.holes.firstIndex(where: { $0.num == hole.num }) ?? 0
            }
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
    
    // 현재 캐러셀에 표시되는 홀 정보를 반환
    private func getCurrentHole() -> Hole? {
        guard let course = selectedCourse, currentHoleIndex < course.holes.count else { return nil }
        return course.holes[currentHoleIndex]
    }
}
