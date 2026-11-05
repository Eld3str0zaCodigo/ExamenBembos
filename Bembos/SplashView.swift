import SwiftUI

struct SplashView: View {
    @Binding var completed: Bool
    @State private var isVisible = false

    var body: some View {
        ZStack {
            Brand.blue.ignoresSafeArea()
            VStack(spacing: 24) {
                BrandLogo(white: true).frame(width: 250, height: 90)
                Text("BEMBOS").font(Brand.heading(25)).tracking(5).foregroundStyle(.white)
            }
            .scaleEffect(isVisible ? 1 : 0.78)
            .opacity(isVisible ? 1 : 0)
        }
        .task {
            withAnimation(.easeOut(duration: 0.8)) { isVisible = true }
            do { try await Task.sleep(nanoseconds: 2_000_000_000) }
            catch { return }
            guard !Task.isCancelled else { return }
            completed = true
        }
    }
}
