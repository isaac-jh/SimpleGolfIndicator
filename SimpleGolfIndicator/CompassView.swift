import SwiftUI
import CoreLocation

struct CompassView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var heading: CLHeading?
    
    var body: some View {
        VStack(spacing: 20) {
            // 나침반 원형 디스플레이 (부드러운 회전)
            ZStack {
                // 외부 원
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 120, height: 120)
                
                // 4방향 메인 표시
                ForEach(0..<4) { index in
                    let angle = Double(index) * 90.0
                    let direction = getMainDirectionName(angle)
                    
                    Text(direction)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .offset(y: -65)
                        .rotationEffect(.degrees(angle))
                }
                
                // 중앙 바늘 (부드러운 회전)
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
                    
                    Text("\(String(format: "%.1f", heading.trueHeading))°")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text(getDetailedDirectionName(heading.trueHeading))
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
            withAnimation(.easeInOut(duration: 0.3)) {
                heading = newHeading
            }
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
    
    private func getMainDirectionName(_ degrees: Double) -> String {
        let normalizedDegrees = degrees.truncatingRemainder(dividingBy: 360)
        let positiveDegrees = normalizedDegrees < 0 ? normalizedDegrees + 360 : normalizedDegrees
        
        switch positiveDegrees {
        case 0:
            return "N"
        case 90:
            return "E"
        case 180:
            return "S"
        case 270:
            return "W"
        default:
            return "N"
        }
    }
    
    private func getDetailedDirectionName(_ degrees: Double) -> String {
        let normalizedDegrees = degrees.truncatingRemainder(dividingBy: 360)
        let positiveDegrees = normalizedDegrees < 0 ? normalizedDegrees + 360 : normalizedDegrees
        
        switch positiveDegrees {
        case 0..<22.5, 337.5..<360:
            return "북"
        case 22.5..<67.5:
            return "북동"
        case 67.5..<112.5:
            return "동"
        case 112.5..<157.5:
            return "남동"
        case 157.5..<202.5:
            return "남"
        case 202.5..<247.5:
            return "남서"
        case 247.5..<292.5:
            return "서"
        case 292.5..<337.5:
            return "북서"
        default:
            return "북"
        }
    }
}

#Preview {
    CompassView()
}
