import SwiftUI

// MARK: - 공통 카드 스타일
struct InfoCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground).opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(.systemGray4), lineWidth: 1)
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
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.caption)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
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
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [backgroundColor.opacity(0.4), backgroundColor.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(backgroundColor.opacity(0.6), lineWidth: 2)
                )
            
            VStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(iconColor)
                    .shadow(radius: 3)
                
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .shadow(radius: 2)
                
                Text(subtitle)
                    .font(.headline)
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
        VStack(spacing: 15) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
