import Foundation
import CoreLocation
import Combine

// MARK: - 나침반 서비스
class CompassService: NSObject, ObservableObject {
    @Published var heading: Double = 0.0
    @Published var isAuthorized = false
    
    private let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var dummyTimer: Timer?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    /// 위치 매니저를 설정합니다
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.headingFilter = 1.0 // 1도 단위로 업데이트
    }
    
    /// 나침반 권한을 요청하고 시작합니다
    func startCompass() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            startHeadingUpdates()
        case .denied, .restricted:
            isAuthorized = false
            // 시뮬레이터나 권한이 없는 경우 더미 데이터 사용
            startDummyCompass()
        @unknown default:
            isAuthorized = false
            startDummyCompass()
        }
    }
    
    /// 나침반 업데이트를 시작합니다
    private func startHeadingUpdates() {
        guard CLLocationManager.headingAvailable() else {
            isAuthorized = false
            startDummyCompass()
            return
        }
        
        locationManager.startUpdatingHeading()
        isAuthorized = true
    }
    
    /// 더미 나침반 데이터를 시작합니다 (시뮬레이터용)
    private func startDummyCompass() {
        isAuthorized = false
        dummyTimer?.invalidate()
        dummyTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            // 2초마다 1도씩 회전 (테스트용)
            self?.heading = (self?.heading ?? 0) + 1.0
            if self?.heading ?? 0 >= 360.0 {
                self?.heading = 0.0
            }
        }
    }
    
    /// 나침반 업데이트를 중지합니다
    func stopCompass() {
        locationManager.stopUpdatingHeading()
        dummyTimer?.invalidate()
        dummyTimer = nil
        isAuthorized = false
    }
    
    /// 현재 방향을 도 단위로 반환합니다
    var currentHeading: Double {
        return heading
    }
    
    deinit {
        stopCompass()
    }
}

// MARK: - CLLocationManagerDelegate
extension CompassService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // 1도 단위로 반올림
        let roundedHeading = round(newHeading.trueHeading)
        if abs(heading - roundedHeading) >= 1.0 {
            heading = roundedHeading
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("나침반 오류: \(error.localizedDescription)")
        isAuthorized = false
        startDummyCompass()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startHeadingUpdates()
        case .denied, .restricted:
            isAuthorized = false
            startDummyCompass()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
