import SwiftUI

@main
struct BembosApp: App {
    @StateObject private var session = SessionStore()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .tint(Brand.blue)
                .preferredColorScheme(.light)
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var splashCompleted = false

    var body: some View {
        Group {
            if !splashCompleted {
                SplashView(completed: $splashCompleted)
            } else if session.currentUser != nil {
                NavigationStack { HomeView() }
            } else {
                NavigationStack { LoginView() }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: splashCompleted)
        .animation(.easeInOut(duration: 0.25), value: session.currentUser?.id)
    }
}
