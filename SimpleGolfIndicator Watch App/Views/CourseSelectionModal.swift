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
                
                Picker("CC 선택", selection: $selectedCountryClub) {
                    Text("CC를 선택하세요").tag(nil as CountryClub?)
                    ForEach(courseDataService.countryClubs) { countryClub in
                        Text(countryClub.name).tag(countryClub as CountryClub?)
                    }
                }
                .onChange(of: selectedCountryClub) { _, _ in
                    selectedCourse = nil
                    selectedHole = nil
                }
            }
            
            // 코스 선택 드롭다운
            VStack(alignment: .leading, spacing: 8) {
                Text("코스 선택")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Picker("코스 선택", selection: $selectedCourse) {
                    Text("코스를 선택하세요").tag(nil as Course?)
                    ForEach(courseDataService.getCourses(for: selectedCountryClub)) { course in
                        Text(course.name).tag(course as Course?)
                    }
                }
                .disabled(selectedCountryClub == nil)
                .onChange(of: selectedCourse) { _, _ in
                    selectedHole = nil
                }
            }
            
            // 홀 선택 드롭다운
            VStack(alignment: .leading, spacing: 8) {
                Text("홀 선택")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Picker("홀 선택", selection: $selectedHole) {
                    Text("홀을 선택하세요").tag(nil as Hole?)
                    ForEach(courseDataService.getHoles(for: selectedCourse)) { hole in
                        Text("\(hole.num)번 홀 (파\(hole.par))").tag(hole as Hole?)
                    }
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
        .background(Color.primary)
    }
}
