#if os(iOS) || os(visionOS) || os(tvOS)
import SwiftUI

extension View {
    public func disableIdleTimer(_ timeout: TimeInterval = 3600.0) -> some View {
        modifier(DisableIdleTimer(timeout))
    }
}

struct DisableIdleTimer: ViewModifier {
    let timeout: TimeInterval
    
    init(_ timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    // MARK: ViewModifier
    func body(content: Content) -> some View {
        content
            .task {
                UIApplication.shared.isIdleTimerDisabled = true
                try? await Task.sleep(until: .now + .seconds(timeout), clock: .continuous)
                UIApplication.shared.isIdleTimerDisabled = false
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
    }
}

#Preview("Disable Idle Timer") {
    EmptyView()
        .disableIdleTimer()
}
#endif
