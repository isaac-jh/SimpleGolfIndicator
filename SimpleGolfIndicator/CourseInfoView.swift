import SwiftUI

struct CourseInfoView: View {
    let selectedCourse: Course
    let selectedHole: Hole
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 골프장 정보
                VStack(spacing: 10) {
                    Text(selectedCourse.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(selectedHole.num)번 홀")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                
                // 홀 정보 표시
                holeInfoView
                
                // 그린 정보
                greenInfoView
                
                // 홀 이미지 (있는 경우)
                if let holeImageUrl = selectedHole.holeImage {
                    holeImageView(url: holeImageUrl)
                }
                
                // 그린 이미지 (있는 경우)
                if let greenImageUrl = selectedHole.greenImage {
                    greenImageView(url: greenImageUrl)
                }
            }
            .padding()
        }
        .navigationTitle("코스 정보")
    }
    
    private var holeInfoView: some View {
        VStack(spacing: 15) {
            Text("\(selectedHole.num)번 홀 정보")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "ruler")
                        .foregroundColor(.green)
                    Text("거리: \(selectedHole.distance)m")
                        .font(.body)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "arrow.up.and.down")
                        .foregroundColor(.orange)
                    Text("고도차: \(selectedHole.elevation)m")
                        .font(.body)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "flag")
                        .foregroundColor(.red)
                    Text("파: \(selectedHole.par)")
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
    
    private func holeImageView(url: String) -> some View {
        VStack(spacing: 10) {
            Text("홀 이미지")
                .font(.headline)
            
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
                    .frame(height: 200)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func greenImageView(url: String) -> some View {
        VStack(spacing: 10) {
            Text("그린 이미지")
                .font(.headline)
            
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
                    .frame(height: 200)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func getGreenData(hole: Hole) -> GreenData {
        // 샘플 데이터
        return GreenData(
            size: ["작음", "보통", "큼"].randomElement() ?? "보통",
            elevation: 2 + (hole.num % 3),
            speed: ["느림", "보통", "빠름"].randomElement() ?? "보통"
        )
    }
}

struct GreenData {
    let size: String
    let elevation: Int
    let speed: String
}

#Preview {
    CourseInfoView(
        selectedCourse: GolfCourse.sampleData.courses[0],
        selectedHole: GolfCourse.sampleData.courses[0].holes[0]
    )
}
