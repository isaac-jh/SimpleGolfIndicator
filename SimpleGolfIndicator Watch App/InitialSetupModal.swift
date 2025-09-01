import SwiftUI
import WatchKit

struct InitialSetupModal: View {
    @Binding var isPresented: Bool
    @Binding var selectedCourse: Course?
    @Binding var selectedHole: Hole?
    @Binding var selectedGolfCourse: GolfCourse?
    
    @StateObject private var golfCourseService = GolfCourseService()
    
    @State private var selectedCC = ""
    @State private var selectedCourseName = ""
    
    var body: some View {
        VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 20)) {
            // 제목
            VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 8)) {
                Image(systemName: "flag.filled")
                    .font(.system(size: DeviceSizeHelper.getIconSize(baseSize: 40)))
                    .foregroundColor(.green)
                
                Text("골프 인디케이터")
                    .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 22), weight: .bold))
                
                Text("골프장 정보를 선택해주세요")
                    .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 12), weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if golfCourseService.isLoading {
                LoadingView(message: "골프장 정보를 불러오는 중...")
            } else if let error = golfCourseService.error {
                VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 15)) {
                    ErrorView(
                        title: "데이터 로딩 실패",
                        message: error,
                        icon: "exclamationmark.triangle"
                    )
                    
                    RefreshButton(action: {
                        golfCourseService.refreshData()
                    })
                }
            } else {
                // 정상 상태 - 드롭다운들
                VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 20)) {
                    // CC 선택 드롭다운
                    dropdownSection(
                        title: "CC 선택",
                        selectedValue: selectedCC,
                        placeholder: "CC를 선택하세요",
                        options: golfCourseService.getAvailableCCs(),
                        onSelect: { cc in
                            selectedCC = cc
                            selectedCourseName = ""
                        }
                    )
                    
                    // 코스 이름 선택 드롭다운
                    dropdownSection(
                        title: "코스 이름",
                        selectedValue: selectedCourseName,
                        placeholder: "코스를 선택하세요",
                        options: golfCourseService.getAvailableCourses(for: selectedCC).map { $0.name },
                        onSelect: { courseName in
                            selectedCourseName = courseName
                        },
                        disabled: selectedCC.isEmpty
                    )
                    
                    // 홀 넘버 선택 드롭다운
                    if let selectedCourse = getSelectedCourse() {
                        dropdownSection(
                            title: "홀 넘버",
                            selectedValue: "",
                            placeholder: "홀을 선택하세요",
                            options: golfCourseService.getAvailableHoles(for: selectedCourse).map { "\($0.num)번 홀" },
                            onSelect: { _ in },
                            disabled: selectedCourseName.isEmpty
                        )
                    }
                }
                
                Spacer()
                
                // 확인 버튼
                Button(action: confirmSelection) {
                    Text("확인")
                        .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 18), weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(DeviceSizeHelper.getPadding(basePadding: 16))
                        .background(canConfirm ? Color.green : Color.gray)
                        .cornerRadius(DeviceSizeHelper.isUltra() ? 15 : 10)
                }
                .disabled(!canConfirm)
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    // MARK: - 드롭다운 섹션
    private func dropdownSection(
        title: String,
        selectedValue: String,
        placeholder: String,
        options: [String],
        onSelect: @escaping (String) -> Void,
        disabled: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Picker(selectedValue.isEmpty ? placeholder : selectedValue, selection: Binding(
                get: { selectedValue },
                set: { onSelect($0) }
            )) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.wheel)
            .disabled(disabled)
        }
    }
    
    // MARK: - Helper Methods
    private func getSelectedCourse() -> Course? {
        guard !selectedCC.isEmpty, !selectedCourseName.isEmpty else { return nil }
        return golfCourseService.getAvailableCourses(for: selectedCC).first { $0.name == selectedCourseName }
    }
    
    private var canConfirm: Bool {
        !selectedCC.isEmpty && !selectedCourseName.isEmpty
    }
    
    private func confirmSelection() {
        guard let course = getSelectedCourse() else { return }
        
        // 첫 번째 홀을 기본값으로 설정
        let hole = golfCourseService.getAvailableHoles(for: course).first ?? course.holes[0]
        
        selectedCourse = course
        selectedHole = hole
        selectedGolfCourse = golfCourseService.golfCourse
        
        // 모달을 아래로 내리는 애니메이션
        withAnimation(.easeInOut(duration: 0.5)) {
            isPresented = false
        }
    }
}

#Preview {
    InitialSetupModal(
        isPresented: .constant(true),
        selectedCourse: .constant(nil),
        selectedHole: .constant(nil),
        selectedGolfCourse: .constant(nil)
    )
}
