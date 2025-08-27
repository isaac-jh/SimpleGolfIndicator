import Foundation

// MARK: - 방향 관련 유틸리티
struct DirectionUtils {
    
    // MARK: - 메인 방향 이름 (N, E, S, W)
    static func getMainDirectionName(_ degrees: Double) -> String {
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
    
    // MARK: - 상세 방향 이름 (8방향 한국어)
    static func getDetailedDirectionName(_ degrees: Double) -> String {
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
    
    // MARK: - 풍향 화살표 회전 각도 (8방향)
    static func getWindArrowRotation(_ windDirection: String) -> Double {
        switch windDirection {
        case "북":
            return 0
        case "북동":
            return 45
        case "동":
            return 90
        case "남동":
            return 135
        case "남":
            return 180
        case "남서":
            return 225
        case "서":
            return 270
        case "북서":
            return 315
        default:
            return 0
        }
    }
    
    // MARK: - 각도 정규화 (0-360도 범위)
    static func normalizeDegrees(_ degrees: Double) -> Double {
        let normalized = degrees.truncatingRemainder(dividingBy: 360)
        return normalized < 0 ? normalized + 360 : normalized
    }
    
    // MARK: - 두 각도 간의 최단 거리
    static func shortestAngleDistance(from: Double, to: Double) -> Double {
        let diff = normalizeDegrees(to - from)
        return diff > 180 ? diff - 360 : diff
    }
    
    // MARK: - 부드러운 각도 보간
    static func interpolateAngle(from: Double, to: Double, progress: Double) -> Double {
        let distance = shortestAngleDistance(from: from, to: to)
        let interpolated = from + (distance * progress)
        return normalizeDegrees(interpolated)
    }
}

// MARK: - 골프 관련 방향 팁
struct GolfDirectionTips {
    static let tips = [
        "북쪽을 향해 샷할 때는 바람의 영향을 고려하세요",
        "동쪽 바람은 공을 오른쪽으로 밀어냅니다",
        "서쪽 바람은 공을 왼쪽으로 밀어냅니다",
        "남쪽 바람은 공을 뒤로 밀어냅니다",
        "바람이 강할 때는 클럽 선택을 한 단계 낮추세요"
    ]
    
    static func getRandomTip() -> String {
        tips.randomElement() ?? tips[0]
    }
    
    static func getTipForDirection(_ direction: String) -> String {
        switch direction {
        case "북":
            return "북쪽 바람은 공을 앞으로 밀어냅니다. 클럽을 한 단계 낮추세요."
        case "동":
            return "동쪽 바람은 공을 오른쪽으로 밀어냅니다. 왼쪽으로 조준하세요."
        case "남":
            return "남쪽 바람은 공을 뒤로 밀어냅니다. 클럽을 한 단계 높이세요."
        case "서":
            return "서쪽 바람은 공을 왼쪽으로 밀어냅니다. 오른쪽으로 조준하세요."
        default:
            return getRandomTip()
        }
    }
}
