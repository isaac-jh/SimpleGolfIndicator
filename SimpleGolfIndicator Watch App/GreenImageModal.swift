import SwiftUI

struct GreenImageModal: View {
    @Binding var isPresented: Bool
    let selectedHole: Hole
    let heading: Double
    
    @State private var dragOffset = CGSize.zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 배경
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                // 그린 이미지
                VStack {
                    Spacer()
                    
                    // 그린 이미지 표시
                    greenImageView
                        .frame(
                            width: geometry.size.width * 0.9,
                            height: geometry.size.height * 0.8
                        )
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    handleSwipeGesture(value)
                                }
                        )
                    
                    Spacer()
                }
            }
        }
        .transition(.move(edge: .trailing))
    }
    
    // MARK: - 그린 이미지 뷰 (나침반 방향에 따라 회전)
    private var greenImageView: some View {
        Group {
            if !selectedHole.greenImage.isEmpty {
                // 그린 이미지 표시 (번들 이미지)
                Image(selectedHole.greenImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .rotationEffect(Angle(degrees: -heading))
            } else {
                // 플레이스홀더
                placeholderGreenView
                    .rotationEffect(Angle(degrees: -heading))
            }
        }
        .shadow(radius: 15, x: 0, y: 8)
    }
    
    private var placeholderGreenView: some View {
        ImagePlaceholderView(
            icon: "circle.grid.3x3",
            title: "그린",
            subtitle: "\(selectedHole.num)번 홀",
            backgroundColor: .blue,
            iconColor: .blue
        )
    }
    
    // MARK: - 스와이프 제스처 처리
    private func handleSwipeGesture(_ value: DragGesture.Value) {
        let horizontalThreshold: CGFloat = 100
        
        if value.translation.width > horizontalThreshold {
            // 오른쪽으로 스와이프 - 모달 닫기
            withAnimation(.easeInOut(duration: 0.3)) {
                isPresented = false
            }
        } else {
            // 원래 위치로 복귀
            withAnimation(.easeInOut(duration: 0.3)) {
                dragOffset = .zero
            }
        }
    }
}
