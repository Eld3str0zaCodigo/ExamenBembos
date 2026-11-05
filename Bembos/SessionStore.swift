import Foundation
import Combine

// One shared source of truth. Intentionally in memory: no disk, backend or UserDefaults.
@MainActor
final class SessionStore: ObservableObject {
    private struct Account {
        let user: User
        let password: String
    }
    @Published private(set) var currentUser: User?
    @Published private(set) var users: [User] = []
    private var accounts: [Account] = []

    init(seedDemo: Bool = true) {
        if seedDemo {
            let demo = User(id: UUID(), name: "Invitado Bembos", email: "demo@bembos.pe")
            users = [demo]
            accounts = [Account(user: demo, password: "Bembos!1")]
        }
    }

    func emailExists(_ email: String) -> Bool {
        users.contains { $0.email == Validation.normalizedEmail(email) }
    }

    func createUser(name: String, email: String, password: String) -> User? {
        let normalized = Validation.normalizedEmail(email)
        guard !emailExists(normalized) else { return nil }
        let user = User(id: UUID(), name: name.trimmingCharacters(in: .whitespacesAndNewlines), email: normalized)
        accounts.append(Account(user: user, password: password))
        users.append(user)
        return user
    }

    func authenticate(email: String, password: String) -> Bool {
        guard let account = accounts.first(where: {
            $0.user.email == Validation.normalizedEmail(email) && $0.password == password
        }) else { return false }
        currentUser = account.user
        return true
    }

    func signIn(_ user: User) {
        guard users.contains(user) else { return }
        currentUser = user
    }

    func logout() { currentUser = nil }
}
