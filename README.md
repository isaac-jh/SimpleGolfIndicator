# SimpleGolfIndicator

단순한 골프 인디케이터입니다.
다음과 같은 정보를 제공해주는 watchOS 앱 프로젝트입니다.

1. 일기 예보를 통해 풍향 정보를 제공.
2. 나침반
3. 골프장 홀 정보
  - 홀 전장 (Red, Yellow, White, Blue, Black)
  - 홀 높낮이
  - 그린 높낮이 맵

_해당 프로젝트의 대부분의 내용은 AI를 통한 바이브 코딩_

## 🚀 프로젝트 설정

### 요구사항
- Xcode 15.0 이상
- watchOS 10.0 이상
- iOS 17.0 이상
- Apple Watch SE 44인치 (타겟 기기)

### 설치 및 빌드

1. **프로젝트 열기**
   ```bash
   open SimpleGolfIndicator.xcodeproj
   ```

2. **개발팀 설정**
   - Xcode에서 프로젝트를 열고
   - Signing & Capabilities 탭에서 개발팀을 선택

3. **빌드 및 실행**
   - Apple Watch 시뮬레이터 또는 실제 기기에서 실행
   - Product > Run (⌘+R)

### 주요 기능

#### 날씨 정보
- 현재 위치 기반 날씨 정보
- 풍향, 풍속, 온도, 습도 표시
- 골프에 미치는 영향도 분석

#### 나침반
- 실시간 방향 표시
- 8방향 방향 표시
- 골프 샷 관련 팁 제공

#### 코스 정보
- 18홀 정보 관리
- 5가지 티 색상 지원 (Red, Yellow, White, Blue, Black)
- 홀별 거리, 고도차, 파, 위험 요소 표시
- 그린 정보 (크기, 고도, 속도)

### 파일 구조

```
SimpleGolfIndicator/
├── SimpleGolfIndicatorApp.swift      # 메인 앱 파일
├── ContentView.swift                 # 메인 콘텐츠 뷰
├── WeatherView.swift                 # 날씨 정보 뷰
├── CompassView.swift                 # 나침반 뷰
├── CourseInfoView.swift              # 코스 정보 뷰
├── LocationManager.swift             # 위치 관리자
├── Info.plist                       # 앱 설정 파일
├── Assets.xcassets/                 # 앱 에셋
└── Preview Assets.xcassets/         # 프리뷰 에셋
```

### 권한 설정

앱에서 다음 권한이 필요합니다:
- **위치 권한**: 현재 위치 및 방향 정보 제공
- **백그라운드 위치**: 골프장에서 지속적인 위치 추적

### 개발 노트

- SwiftUI 기반으로 작성
- CoreLocation 프레임워크 사용
- Apple Watch SE 44인치 화면 크기 최적화
- 한국어 지원
- 골프 관련 전문 정보 제공

### 향후 개선 사항

- [ ] 실제 날씨 API 연동
- [ ] 골프장 데이터베이스 연동
- [ ] GPS 거리 측정 기능
