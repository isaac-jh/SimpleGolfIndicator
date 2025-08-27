import SwiftUI

struct ContentView: View {
    let selectedCourse: Course
    let selectedHole: Hole
    let selectedGolfCourse: GolfCourse
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // 선택된 골프장 정보 표시
                VStack(spacing: 5) {
                    Text(selectedGolfCourse.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(selectedCourse.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(selectedHole.num)번 홀")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                Spacer()
                
                // 메인 기능 버튼들
                NavigationLink(destination: WeatherView(
                    selectedCourse: selectedCourse,
                    golfCourse: selectedGolfCourse
                )) {
                    HStack {
                        Image(systemName: "cloud.sun.fill")
                        Text("날씨 정보")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                NavigationLink(destination: CompassView()) {
                    HStack {
                        Image(systemName: "location.north.fill")
                        Text("나침반")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                NavigationLink(destination: CourseInfoView(
                    selectedCourse: selectedCourse,
                    selectedHole: selectedHole
                )) {
                    HStack {
                        Image(systemName: "flag.checkered")
                        Text("코스 정보")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("골프 인디케이터")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView(
        selectedCourse: GolfCourse.sampleData.courses[0],
        selectedHole: GolfCourse.sampleData.courses[0].holes[0],
        selectedGolfCourse: GolfCourse.sampleData
    )
}
