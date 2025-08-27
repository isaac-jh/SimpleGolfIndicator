import SwiftUI
import CoreLocation

struct CompassView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var heading: CLHeading?
    
    var body: some View {
        VStack(spacing: 20) {
            // 나침반 원형 디스플레이
            ZStack {
                // 외부 원
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 120, height: 120)
                
                // 방향 표시
                ForEach(0..<8) { index in
                    let angle = Double(index) * 45.0
                    let direction = getDirectionName(angle)
                    
                    Text(direction)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .offset(y: -65)
                        .rotationEffect(.degrees(angle))
                }
                
                // 중앙 바늘
                VStack(spacing: 0) {
                    Image(systemName: "location.north.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(-(heading?.trueHeading ?? 0)))
                    
                    Text("N")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
            }
            
            // 현재 방향 정보
            if let heading = heading {
                VStack(spacing: 10) {
                    Text("현재 방향")
                        .font(.headline)
                    
                    Text("\(Int(heading.trueHeading))°")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text(getDirectionName(heading.trueHeading))
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "location.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("방향 정보를 불러올 수 없습니다")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text("위치 권한을 확인해주세요")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            // 골프 관련 팁
            golfTipView
        }
        .padding()
        .navigationTitle("나침반")
        .onAppear {
            locationManager.startUpdatingHeading()
        }
        .onReceive(locationManager.$heading) { newHeading in
            heading = newHeading
        }
    }
    
    private var golfTipView: some View {
        VStack(spacing: 10) {
            Text("골프 팁")
                .font(.headline)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("북쪽을 향해 샷할 때는 바람의 영향을 고려하세요")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("동쪽 바람은 공을 오른쪽으로 밀어냅니다")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("서쪽 바람은 공을 왼쪽으로 밀어냅니다")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    private func getDirectionName(_ degrees: Double) -> String {
        let normalizedDegrees = degrees.truncatingRemainder(dividingBy: 360)
        let positiveDegrees = normalizedDegrees < 0 ? normalizedDegrees + 360 : normalizedDegrees
        
        switch positiveDegrees {
        case 0..<22.5, 337.5..<360:
            return "N"
        case 22.5..<67.5:
            return "NE"
        case 67.5..<112.5:
            return "E"
        case 112.5..<157.5:
            return "SE"
        case 157.5..<202.5:
            return "S"
        case 202.5..<247.5:
            return "SW"
        case 247.5..<292.5:
            return "W"
        case 292.5..<337.5:
            return "NW"
        default:
            return "N"
        }
    }
}

#Preview {
    CompassView()
}
