import SwiftUI

struct CourseInfoView: View {
    let selectedCourse: GolfCourse
    let selectedHole: Int
    
    @State private var selectedTee = "White"
    
    private let teeColors = ["Red", "Yellow", "White", "Blue", "Black"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 골프장 정보
                VStack(spacing: 10) {
                    Text(selectedCourse.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(selectedHole)번 홀")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                
                // 티 색상 선택
                teeColorSelector
                
                // 홀 정보 표시
                holeInfoView
                
                // 그린 정보
                greenInfoView
            }
            .padding()
        }
        .navigationTitle("코스 정보")
    }
    
    private var teeColorSelector: some View {
        VStack(spacing: 10) {
            Text("티 색상")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(teeColors, id: \.self) { color in
                    Button(action: {
                        selectedTee = color
                    }) {
                        Text(color)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(width: 50, height: 30)
                            .background(selectedTee == color ? getTeeColor(color) : Color.gray.opacity(0.3))
                            .foregroundColor(selectedTee == color ? .white : .primary)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    private func getTeeColor(_ color: String) -> Color {
        switch color {
        case "Red":
            return .red
        case "Yellow":
            return .yellow
        case "White":
            return .white
        case "Blue":
            return .blue
        case "Black":
            return .black
        default:
            return .gray
        }
    }
    
    private var holeInfoView: some View {
        VStack(spacing: 15) {
            Text("\(selectedHole)번 홀 정보")
                .font(.title2)
                .fontWeight(.bold)
            
            let holeData = getHoleData(hole: selectedHole, tee: selectedTee)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "ruler")
                        .foregroundColor(.green)
                    Text("거리: \(holeData.distance)m")
                        .font(.body)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "arrow.up.and.down")
                        .foregroundColor(.orange)
                    Text("고도차: \(holeData.elevation)m")
                        .font(.body)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "flag")
                        .foregroundColor(.red)
                    Text("파: \(holeData.par)")
                        .font(.body)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.yellow)
                    Text("위험 요소: \(holeData.hazards)")
                        .font(.body)
                    Spacer()
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private var greenInfoView: some View {
        VStack(spacing: 15) {
            Text("그린 정보")
                .font(.title2)
                .fontWeight(.bold)
            
            let greenData = getGreenData(hole: selectedHole)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "circle.grid.3x3")
                        .foregroundColor(.green)
                    Text("그린 크기: \(greenData.size)")
                        .font(.body)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "arrow.up.and.down")
                        .foregroundColor(.blue)
                    Text("그린 고도: \(greenData.elevation)m")
                        .font(.body)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "speedometer")
                        .foregroundColor(.purple)
                    Text("그린 속도: \(greenData.speed)")
                        .font(.body)
                    Spacer()
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private func getHoleData(hole: Int, tee: String) -> HoleData {
        // Hole.sampleHoles에서 해당 홀 데이터 가져오기
        let holeData = Hole.sampleHoles.first { $0.number == hole } ?? Hole.sampleHoles[0]
        
        let distance = holeData.distance[tee] ?? holeData.distance["White"] ?? 160
        
        return HoleData(
            distance: distance,
            elevation: holeData.elevation,
            par: holeData.par,
            hazards: holeData.hazards.joined(separator: ", ")
        )
    }
    
    private func getGreenData(hole: Int) -> GreenData {
        // 샘플 데이터
        return GreenData(
            size: ["작음", "보통", "큼"].randomElement() ?? "보통",
            elevation: 2 + (hole % 3),
            speed: ["느림", "보통", "빠름"].randomElement() ?? "보통"
        )
    }
}

struct HoleData {
    let distance: Int
    let elevation: Int
    let par: Int
    let hazards: String
}

struct GreenData {
    let size: String
    let elevation: Int
    let speed: String
}

#Preview {
    CourseInfoView(
        selectedCourse: GolfCourse.sampleCourses[0],
        selectedHole: 1
    )
}
