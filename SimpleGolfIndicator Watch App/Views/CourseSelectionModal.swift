import SwiftUI

// MARK: - 코스 선택 모달 뷰
struct CourseSelectionModal: View {
    @ObservedObject var courseDataService: CourseDataService
    @Binding var isPresented: Bool
    @Binding var selectedCountryClub: CountryClub?
    @Binding var selectedCourse: Course?
    @Binding var selectedHole: Hole?
    
    var body: some View {
        VStack(spacing: 16) {
            // 제목
            Text("코스 선택")
                .font(.headline)
                .foregroundColor(.primary)
            
            // CC 선택 드롭다운
            VStack(alignment: .leading, spacing: 8) {
                Text("CC 선택")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Menu {
                    ForEach(courseDataService.countryClubs) { countryClub in
                        Button(countryClub.name) {
                            selectedCountryClub = countryClub
                            selectedCourse = nil
                            selectedHole = nil
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCountryClub?.name ?? "CC를 선택하세요")
                            .foregroundColor(selectedCountryClub != nil ? .primary : .secondary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            
            // 코스 선택 드롭다운
            VStack(alignment: .leading, spacing: 8) {
                Text("코스 선택")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Menu {
                    ForEach(courseDataService.getCourses(for: selectedCountryClub)) { course in
                        Button(course.name) {
                            selectedCourse = course
                            selectedHole = nil
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCourse?.name ?? "코스를 선택하세요")
                            .foregroundColor(selectedCourse != nil ? .primary : .secondary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .disabled(selectedCountryClub == nil)
            }
            
            // 홀 선택 드롭다운
            VStack(alignment: .leading, spacing: 8) {
                Text("홀 선택")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Menu {
                    ForEach(courseDataService.getHoles(for: selectedCourse)) { hole in
                        Button("\(hole.num)번 홀 (파\(hole.par))") {
                            selectedHole = hole
                        }
                    }
                } label: {
                    HStack {
                        if let hole = selectedHole {
                            Text("\(hole.num)번 홀 (파\(hole.par))")
                                .foregroundColor(.primary)
                        } else {
                            Text("홀을 선택하세요")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .disabled(selectedCourse == nil)
            }
            
            // 확인 버튼
            Button(action: {
                isPresented = false
            }) {
                Text("확인")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedHole != nil ? Color.green : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(selectedHole == nil)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
