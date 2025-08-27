import SwiftUI

struct InitialSetupModal: View {
    @Binding var isPresented: Bool
    @Binding var selectedCourse: GolfCourse?
    @Binding var selectedHole: Int
    
    @State private var selectedCC = ""
    @State private var selectedCourseName = ""
    @State private var selectedHoleNumber = 1
    
    private let availableCCs = Array(Set(GolfCourse.sampleCourses.map { $0.cc })).sorted()
    private let availableHoles = Array(1...18)
    
    var body: some View {
        VStack(spacing: 20) {
            // 제목
            VStack(spacing: 8) {
                Image(systemName: "flag.filled")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                
                Text("골프 인디케이터")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("골프장 정보를 선택해주세요")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // CC 선택 드롭다운
            VStack(alignment: .leading, spacing: 8) {
                Text("CC 선택")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Menu {
                    ForEach(availableCCs, id: \.self) { cc in
                        Button(cc) {
                            selectedCC = cc
                            selectedCourseName = ""
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCC.isEmpty ? "CC를 선택하세요" : selectedCC)
                            .foregroundColor(selectedCC.isEmpty ? .secondary : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            
            // 코스 이름 선택 드롭다운
            VStack(alignment: .leading, spacing: 8) {
                Text("코스 이름")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Menu {
                    ForEach(GolfCourse.sampleCourses.filter { $0.cc == selectedCC }, id: \.id) { course in
                        Button(course.name) {
                            selectedCourseName = course.name
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCourseName.isEmpty ? "코스를 선택하세요" : selectedCourseName)
                            .foregroundColor(selectedCourseName.isEmpty ? .secondary : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .disabled(selectedCC.isEmpty)
            }
            
            // 홀 넘버 선택 드롭다운
            VStack(alignment: .leading, spacing: 8) {
                Text("홀 넘버")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Menu {
                    ForEach(availableHoles, id: \.self) { hole in
                        Button("\(hole)번 홀") {
                            selectedHoleNumber = hole
                        }
                    }
                } label: {
                    HStack {
                        Text("\(selectedHoleNumber)번 홀")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            
            Spacer()
            
            // 확인 버튼
            Button(action: {
                confirmSelection()
            }) {
                Text("확인")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canConfirm ? Color.green : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!canConfirm)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    private var canConfirm: Bool {
        !selectedCC.isEmpty && !selectedCourseName.isEmpty
    }
    
    private func confirmSelection() {
        guard let course = GolfCourse.sampleCourses.first(where: { 
            $0.cc == selectedCC && $0.name == selectedCourseName 
        }) else { return }
        
        selectedCourse = course
        selectedHole = selectedHoleNumber
        
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
        selectedHole: .constant(1)
    )
}
