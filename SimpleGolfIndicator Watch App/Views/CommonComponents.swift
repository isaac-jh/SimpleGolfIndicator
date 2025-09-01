import SwiftUI
import WatchKit

// MARK: - 디바이스별 크기 조정 헬퍼
struct DeviceSizeHelper {
    static func isUltra() -> Bool {
        return WKInterfaceDevice.current().screenBounds.width >= 198 // Ultra는 49mm = 198pt
    }
    
    static func getFontSize(baseSize: CGFloat) -> CGFloat {
        return isUltra() ? baseSize * 0.9 : baseSize * 0.8
    }
    
    static func getPadding(basePadding: CGFloat) -> CGFloat {
        return isUltra() ? basePadding * 0.8 : basePadding * 0.6
    }
    
    static func getIconSize(baseSize: CGFloat) -> CGFloat {
        return isUltra() ? baseSize * 0.9 : baseSize * 0.8
    }
}

// MARK: - 공통 카드 스타일
struct InfoCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(DeviceSizeHelper.getPadding(basePadding: 8))
            .background(
                RoundedRectangle(cornerRadius: DeviceSizeHelper.isUltra() ? 20 : 15)
                    .fill(Color.black.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: DeviceSizeHelper.isUltra() ? 20 : 15)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - 공통 정보 표시 뷰
struct InfoDisplayView: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 8)) {
            Text(title)
                .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 12), weight: .medium))
                .foregroundColor(.secondary)
            
            HStack(spacing: DeviceSizeHelper.getPadding(basePadding: 4)) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: DeviceSizeHelper.getIconSize(baseSize: 14)))
                
                Text(value)
                    .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 22), weight: .bold))
                    .foregroundColor(.primary)
            }
        }
    }
}

// MARK: - 공통 이미지 플레이스홀더
struct ImagePlaceholderView: View {
    let icon: String
    let title: String
    let subtitle: String
    let backgroundColor: Color
    let iconColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DeviceSizeHelper.isUltra() ? 25 : 20)
                .fill(
                    LinearGradient(
                        colors: [backgroundColor.opacity(0.4), backgroundColor.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DeviceSizeHelper.isUltra() ? 25 : 20)
                        .stroke(backgroundColor.opacity(0.6), lineWidth: 2)
                )
            
            VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 15)) {
                Image(systemName: icon)
                    .font(.system(size: DeviceSizeHelper.getIconSize(baseSize: 60)))
                    .foregroundColor(iconColor)
                    .shadow(radius: 3)
                
                Text(title)
                    .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 24), weight: .bold))
                    .foregroundColor(.primary)
                    .shadow(radius: 2)
                
                Text(subtitle)
                    .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 18), weight: .medium))
                    .foregroundColor(.secondary)
                    .shadow(radius: 1)
            }
        }
    }
}

// MARK: - 공통 로딩 뷰
struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: DeviceSizeHelper.getPadding(basePadding: 20)) {
            ProgressView()
                .scaleEffect(DeviceSizeHelper.isUltra() ? 1.2 : 1.0)
            
            Text(message)
                .font(.system(size: DeviceSizeHelper.getFontSize(baseSize: 16), weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(DeviceSizeHelper.getPadding(basePadding: 30))
    }
}

// MARK: - 공통 에러 뷰
struct ErrorView: View {
    let title: String
    let message: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - 공통 새로고침 버튼
struct RefreshButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16, weight: .medium))
                
                Text("새로고침")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.blue)
            )
            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        InfoCard {
            InfoDisplayView(
                title: "거리",
                value: "375m",
                icon: "ruler",
                iconColor: .green
            )
        }
        
        ImagePlaceholderView(
            icon: "flag.filled",
            title: "1번 홀",
            subtitle: "파 4",
            backgroundColor: .green,
            iconColor: .red
        )
        
        LoadingView(message: "데이터 로딩 중...")
        
        ErrorView(
            title: "오류 발생",
            message: "데이터를 불러올 수 없습니다",
            icon: "exclamationmark.triangle"
        )
        
        RefreshButton(action: {})
    }
    .padding()
}
