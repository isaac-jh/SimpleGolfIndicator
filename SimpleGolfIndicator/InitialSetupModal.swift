import SwiftUI

struct InitialSetupModal: View {
    @Binding var isPresented: Bool
    @Binding var selectedCourse: Course?
    @Binding var selectedHole: Hole?
    
    @StateObject private var golfCourseService = GolfCourseService()
    
    @State private var selectedCC = ""
    @State private var selectedCourseName = ""
    
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
            
            if golfCourseService.isLoading {
                // 로딩 상태
                VStack(spacing: 15) {
                    ProgressView()
                        .scaleEffect(1.2)
                    
                    Text("골프장 정보를 불러오는 중...")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = golfCourseService.error {
                // 에러 상태
                VStack(spacing: 15) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text("데이터 로딩 실패")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("다시 시도") {
                        golfCourseService.refreshData()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // 정상 상태 - 드롭다운들
                // CC 선택 드롭다운
                VStack(alignment: .leading, spacing: 8) {
                    Text("CC 선택")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Menu {
                        ForEach(golfCourseService.getAvailableCCs(), id: \.self) { cc in
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
                        ForEach(golfCourseService.getAvailableCourses(for: selectedCC), id: \.id) { course in
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
                    
                    if let selectedCourse = getSelectedCourse() {
                        Menu {
                            ForEach(golfCourseService.getAvailableHoles(for: selectedCourse), id: \.id) { hole in
                                Button("\(hole.num)번 홀") {
                                    // 홀 선택은 확인 버튼에서 처리
                                }
                            }
                        } label: {
                            HStack {
                                Text("홀을 선택하세요")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .disabled(selectedCourseName.isEmpty)
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
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    private func getSelectedCourse() -> Course? {
        guard !selectedCC.isEmpty, !selectedCourseName.isEmpty else { return nil }
        return golfCourseService.getAvailableCourses(for: selectedCC).first { $0.name == selectedCourseName }
    }
    
    private var canConfirm: Bool {
        !selectedCC.isEmpty && !selectedCourseName.isEmpty
    }
    
    private func confirmSelection() {
        guard let course = getSelectedCourse() else { return }
        
        // 첫 번째 홀을 기본값으로 설정 (사용자가 홀을 선택하지 않은 경우)
        let hole = golfCourseService.getAvailableHoles(for: course).first ?? course.holes[0]
        
        selectedCourse = course
        selectedHole = hole
        
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
        selectedHole: .constant(nil)
    )
}
