import SwiftUI

struct HoleSelectionModal: View {
    @Binding var isPresented: Bool
    let selectedCourse: Course
    let selectedHole: Hole
    let selectedGolfCourse: GolfCourse
    
    @State private var selectedHoleIndex: Int
    
    init(isPresented: Binding<Bool>, selectedCourse: Course, selectedHole: Hole, selectedGolfCourse: GolfCourse) {
        self._isPresented = isPresented
        self.selectedCourse = selectedCourse
        self.selectedHole = selectedHole
        self.selectedGolfCourse = selectedGolfCourse
        
        // 현재 선택된 홀의 인덱스 찾기
        if let index = selectedCourse.holes.firstIndex(where: { $0.id == selectedHole.id }) {
            self._selectedHoleIndex = State(initialValue: index)
        } else {
            self._selectedHoleIndex = State(initialValue: 0)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 제목
                VStack(spacing: 8) {
                    Image(systemName: "flag.filled")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    
                    Text("홀 선택")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(selectedGolfCourse.name) - \(selectedCourse.name)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 홀 선택 그리드
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                    ForEach(Array(selectedCourse.holes.enumerated()), id: \.element.id) { index, hole in
                        holeButton(index: index, hole: hole)
                    }
                }
                
                Spacer()
                
                // 확인 버튼
                Button(action: confirmSelection) {
                    Text("확인")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding(20)
            .navigationTitle("홀 선택")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        Button("취소") {
                            isPresented = false
                        }
                        .padding()
                    }
                    Spacer()
                }
            )
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 100 {
                        isPresented = false
                    }
                }
        )
    }
    
    // MARK: - 홀 버튼
    private func holeButton(index: Int, hole: Hole) -> some View {
        Button(action: {
            selectedHoleIndex = index
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(selectedHoleIndex == index ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                    
                    Text("\(hole.num)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(selectedHoleIndex == index ? .white : .primary)
                }
                
                Text("\(hole.distance)m")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("파 \(hole.par)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helper Methods
    private func confirmSelection() {
        // 선택된 홀로 이동하는 로직은 MainHoleView에서 처리
        isPresented = false
    }
}

#Preview {
    HoleSelectionModal(
        isPresented: .constant(true),
        selectedCourse: GolfCourse.sampleData.courses[0],
        selectedHole: GolfCourse.sampleData.courses[0].holes[0],
        selectedGolfCourse: GolfCourse.sampleData
    )
}
