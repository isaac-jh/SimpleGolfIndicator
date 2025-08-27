# 🏌️‍♂️ SimpleGolfIndicator

Apple Watch용 골프 인디케이터 앱입니다. 날씨 정보, 나침반, 골프 코스 정보를 제공하여 골프 플레이에 도움을 줍니다.

## 🚀 프로젝트 설정

- **타겟 기기**: Apple Watch SE 44인치
- **개발 언어**: SwiftUI
- **최소 버전**: watchOS 10.0+
- **개발 도구**: Xcode 15.0+

## 📋 요구사항

- Apple Watch SE 44인치 지원
- 골프장 정보 JSON 데이터 파싱
- OpenWeather API를 통한 실시간 날씨 정보
- 나침반 기능 (CoreLocation 기반)
- 직관적인 제스처 기반 사용자 인터페이스

## 🛠️ 설치 및 빌드

1. 프로젝트 클론
```bash
git clone [repository-url]
cd SimpleGolfIndicator
```

2. Xcode에서 프로젝트 열기
3. `AppConfig.swift`에서 API 키 설정
4. Apple Watch 시뮬레이터 또는 실제 기기에서 빌드

## ✨ 주요 기능

### 🎯 초기 설정
- CC, 코스 이름, 홀 번호 선택 모달
- 3단계 드롭다운 선택 인터페이스
- 설정 완료 후 메인 화면 자동 전환

### 🌤️ 날씨 정보
- 실시간 풍향 및 풍속 표시
- 부드러운 풍향 화살표 회전
- OpenWeather API 연동
- 30분 캐시 시스템

### 🧭 나침반
- 실시간 방향 표시
- 부드러운 바늘 회전 애니메이션
- 4방향 메인 표시 (N, E, S, W)
- 8방향 상세 표시 (한국어)

### 🏌️ 골프 코스 정보
- 홀별 거리, 파, 고도차 표시
- 홀 이미지 및 그린 이미지 전환
- 좌우 스와이프로 홀 간 이동
- 위로 스와이프로 홀 선택 모달

### 🎨 사용자 인터페이스
- 잔디 배경 애니메이션
- 커스텀 화살표 및 눈금 디자인
- 직관적인 제스처 제어
- 반응형 레이아웃

## 📁 파일 구조

```
SimpleGolfIndicator/
├── SimpleGolfIndicatorApp.swift      # 앱 진입점
├── MainHoleView.swift                # 메인 홀 화면
├── InitialSetupModal.swift           # 초기 설정 모달
├── HoleSelectionModal.swift          # 홀 선택 모달
├── LocationManager.swift             # 위치 서비스 관리
├── Models/
│   ├── GolfCourse.swift             # 골프장 데이터 모델
│   └── WeatherAPI.swift             # 날씨 API 모델
├── Services/
│   ├── GolfCourseService.swift      # 골프장 데이터 서비스
│   └── WeatherService.swift         # 날씨 데이터 서비스
├── Views/
│   ├── CommonComponents.swift       # 공통 UI 컴포넌트
│   ├── CustomArrows.swift           # 커스텀 화살표 뷰
│   └── GrassBackground.swift        # 잔디 배경 애니메이션
├── Utils/
│   └── DirectionUtils.swift         # 방향 관련 유틸리티
└── Config/
    └── AppConfig.swift              # 앱 설정
```

## 🔧 모듈화된 컴포넌트

### 🎨 CommonComponents
- `InfoCard`: 정보 표시용 카드 스타일
- `InfoDisplayView`: 제목과 값이 있는 정보 표시
- `ImagePlaceholderView`: 이미지 플레이스홀더
- `LoadingView`: 로딩 상태 표시
- `ErrorView`: 에러 상태 표시
- `RefreshButton`: 새로고침 버튼

### 🧭 DirectionUtils
- 방향 이름 변환 (8방향 한국어)
- 각도 정규화 및 보간
- 골프 관련 방향 팁

### 🎯 CustomArrows
- `WindArrow`: 풍향 화살표
- `CompassNeedle`: 나침반 바늘
- `EnhancedTickMarks`: 향상된 눈금
- `AnimatedCircleBackground`: 애니메이션 원형 배경

## 🔐 권한 설정

### Info.plist
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>골프 코스 방향 정보를 위해 위치 권한이 필요합니다.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>골프 코스 방향 정보를 위해 위치 권한이 필요합니다.</string>
```

## 🚀 개발 노트

### 🔄 데이터 플로우
1. `InitialSetupModal`에서 골프장 정보 선택
2. `GolfCourseService`에서 JSON 데이터 로드
3. `MainHoleView`에서 선택된 정보 표시
4. `WeatherService`에서 실시간 날씨 데이터 로드
5. `LocationManager`에서 나침반 방향 정보 제공

### 🎨 UI/UX 특징
- **제스처 기반**: 스와이프, 탭으로 직관적 조작
- **애니메이션**: 부드러운 전환과 회전 효과
- **반응형**: 다양한 화면 크기 지원
- **접근성**: 명확한 시각적 피드백

### 📱 성능 최적화
- **캐싱**: 데이터 및 이미지 캐싱 시스템
- **비동기**: Combine 프레임워크 활용
- **메모리 관리**: NSCache를 통한 효율적 메모리 사용

## 🔮 향후 개선 사항

### 🎯 기능 확장
- [ ] 다중 골프장 지원
- [ ] 골프 클럽 추천 시스템
- [ ] 샷 거리 측정 기능
- [ ] 골프 스코어 카드

### 🎨 UI/UX 개선
- [ ] 다크 모드 지원
- [ ] 커스텀 테마 시스템
- [ ] 애니메이션 효과 강화
- [ ] 접근성 개선

### 🔧 기술적 개선
- [ ] Core Data 통합
- [ ] 오프라인 모드 지원
- [ ] 푸시 알림 시스템
- [ ] 데이터 동기화

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 🤝 기여

버그 리포트, 기능 제안, 풀 리퀘스트를 환영합니다!

---

**SimpleGolfIndicator** - 골프를 더 스마트하게! 🏌️‍♂️✨
