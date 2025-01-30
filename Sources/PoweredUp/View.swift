import SwiftUI

extension View {
    public func openSettings() {
#if os(macOS)
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security")!)
#elseif os(iOS) || os(visionOS) || os(tvOS)
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
#else
        fatalError("openSettings() has not been implemented")
#endif
    }
}
