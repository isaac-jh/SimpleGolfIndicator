import SwiftUI

struct ContentView: View {
    let selectedCourse: Course
    let selectedHole: Hole
    let selectedGolfCourse: GolfCourse
    
    var body: some View {
        NavigationView {
            MainHoleView(
                selectedCourse: selectedCourse,
                selectedHole: selectedHole,
                selectedGolfCourse: selectedGolfCourse
            )
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
