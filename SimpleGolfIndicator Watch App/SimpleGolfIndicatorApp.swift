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
    @State private var showInitialModal = true
    @State private var selectedCourse: Course?
    @State private var selectedHole: Hole?
    @State private var selectedGolfCourse: GolfCourse?

    var body: some View {
        ZStack {
            if let course = selectedCourse, let hole = selectedHole, let golfCourse = selectedGolfCourse {
                MainHoleView(
                    selectedCourse: course,
                    selectedHole: hole,
                    selectedGolfCourse: golfCourse
                )
            } else {
                // 초기 로딩 화면
                VStack {
                    Image(systemName: "flag.filled")
                        .font(.system(size: 60))
                        .foregroundColor(.green)

                    Text("골프 인디케이터")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                }
            }

            // 초기 설정 모달
            if showInitialModal {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { }

                InitialSetupModal(
                    isPresented: $showInitialModal,
                    selectedCourse: $selectedCourse,
                    selectedHole: $selectedHole,
                    selectedGolfCourse: $selectedGolfCourse
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showInitialModal)
    }
}
