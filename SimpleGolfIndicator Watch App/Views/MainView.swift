import SwiftUI

// MARK: - 메인 화면
struct MainView: View {
    @ObservedObject var courseDataService: CourseDataService
    @Binding var selectedCountryClub: CountryClub?
    @Binding var selectedCourse: Course?
    @Binding var selectedHole: Hole?
    @Binding var showingModal: Bool
    
    var body: some View {
        ZStack {
            // 메인 콘텐츠 (현재는 빈 화면)
            VStack {
                if let hole = selectedHole {
                    VStack(spacing: 16) {
                        Text("\(selectedCountryClub?.name ?? "") - \(selectedCourse?.name ?? "")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(hole.num)번 홀")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text("파")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(hole.par)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            
                            VStack {
                                Text("거리")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(hole.distance)m")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            
                            VStack {
                                Text("고도")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(hole.elevation > 0 ? "+" : "")\(String(format: "%.1f", hole.elevation))m")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(hole.elevation > 0 ? .red : .blue)
                            }
                        }
                        
                        Spacer()
                        
                        Text("메인 화면 준비 중...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    VStack {
                        Text("코스를 선택해주세요")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            
            // 모달 오버레이
            if showingModal {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingModal = false
                    }
                
                VStack {
                    Spacer()
                    
                    CourseSelectionModal(
                        courseDataService: courseDataService,
                        isPresented: $showingModal,
                        selectedCountryClub: $selectedCountryClub,
                        selectedCourse: $selectedCourse,
                        selectedHole: $selectedHole
                    )
                    .transition(.move(edge: .bottom))
                }
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
    }
}
