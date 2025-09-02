import SwiftUI

// MARK: - 코스 선택 모달 뷰
struct CourseSelectionModal: View {
    @ObservedObject var courseDataService: CourseDataService
    @Binding var isPresented: Bool
    @Binding var selectedCountryClub: CountryClub?
    @Binding var selectedCourse: Course?
    @Binding var selectedHole: Hole?
    
    // 시트 표시 상태
    @State private var showCCSheet = false
    @State private var showCourseSheet = false
    @State private var showHoleSheet = false
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading) {
                // CC 선택
                Text("CC 선택")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Button(action: { showCCSheet = true }) {
                    HStack {
                        Text(selectedCountryClub?.name ?? "CC를 선택하세요")
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showCCSheet) {
                    List {
                        ForEach(courseDataService.countryClubs) { countryClub in
                            Button(countryClub.name) {
                                selectedCountryClub = countryClub
                                selectedCourse = nil
                                selectedHole = nil
                                showCCSheet = false
                            }
                            .foregroundColor(.primary)
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }

                
                // 코스 선택
                Text("코스 선택")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Button(action: { if selectedCountryClub != nil { showCourseSheet = true } }) {
                    HStack {
                        Text(selectedCourse?.name ?? "코스를 선택하세요")
                            .foregroundColor(selectedCountryClub == nil ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor((selectedCountryClub == nil) ? .gray : .black.opacity(0.6))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .disabled(selectedCountryClub == nil)
                .sheet(isPresented: $showCourseSheet) {
                    List {
                        ForEach(courseDataService.getCourses(for: selectedCountryClub)) { course in
                            Button(course.name) {
                                selectedCourse = course
                                selectedHole = nil
                                showCourseSheet = false
                            }
                            .foregroundColor(.primary)
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                // 홀 선택
                Text("홀 선택")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Button(action: { if selectedCourse != nil { showHoleSheet = true } }) {
                    HStack {
                        if let hole = selectedHole {
                            Text("\(hole.num)번 홀 (파\(hole.par))")
                                .foregroundColor(.black)
                        } else {
                            Text("홀을 선택하세요")
                                .foregroundColor(selectedCourse == nil ? .gray : .black)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor((selectedCourse == nil) ? .gray : .black.opacity(0.6))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .disabled(selectedCourse == nil)
                .sheet(isPresented: $showHoleSheet) {
                    List {
                        ForEach(courseDataService.getHoles(for: selectedCourse)) { hole in
                            Button("\(hole.num)번 홀 (파\(hole.par))") {
                                selectedHole = hole
                                showHoleSheet = false
                            }
                            .foregroundColor(.primary)
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                        }
                    }
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
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .disabled(selectedHole == nil)
                
                Spacer(minLength: 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .focusable(false)
        .background(Color.black)
        .ignoresSafeArea(edges: .horizontal)
    }
}
