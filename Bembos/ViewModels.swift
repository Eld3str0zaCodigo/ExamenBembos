import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = "" { didSet { errorMessage = nil } }
    @Published var password = "" { didSet { errorMessage = nil } }
    @Published private(set) var errorMessage: String?
    // Valid form values live only during this ViewModel's lifetime.
    private(set) var validatedEmail: String?
    private(set) var validatedPassword: String?
    var isDisabled: Bool { Validation.normalizedEmail(email).isEmpty || password.isEmpty }

    @discardableResult
    func login(session: SessionStore) -> Bool {
        validatedEmail = nil
        validatedPassword = nil
        guard !isDisabled else { errorMessage = "Completa tu correo y contraseña."; return false }
        guard Validation.isValidEmail(email) else { errorMessage = "Ingresa un correo electrónico válido."; return false }
        if let error = Validation.passwordError(password) { errorMessage = error; return false }
        guard session.authenticate(email: email, password: password) else {
            errorMessage = "El correo o la contraseña no coinciden. Puedes crear una cuenta."
            return false
        }
        validatedEmail = Validation.normalizedEmail(email)
        validatedPassword = password
        errorMessage = nil
        return true
    }
}

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var name = "" { didSet { errorMessage = nil } }
    @Published var email = "" { didSet { errorMessage = nil } }
    @Published var password = "" { didSet { errorMessage = nil } }
    @Published var confirmation = "" { didSet { errorMessage = nil } }
    @Published private(set) var errorMessage: String?
    @Published private(set) var successMessage: String?
    @Published private(set) var registeredUser: User?

    var isDisabled: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        Validation.normalizedEmail(email).isEmpty || password.isEmpty || confirmation.isEmpty || registeredUser != nil
    }

    @discardableResult
    func register(session: SessionStore) -> Bool {
        guard registeredUser == nil else { return false }
        guard !isDisabled else { errorMessage = "Completa todos los campos."; return false }
        guard Validation.isValidEmail(email) else { errorMessage = "Ingresa un correo electrónico válido."; return false }
        if let error = Validation.passwordError(password) { errorMessage = error; return false }
        guard password == confirmation else { errorMessage = "Las contraseñas no coinciden."; return false }
        guard !session.emailExists(email) else { errorMessage = "Este correo ya está registrado. Inicia sesión o usa otro."; return false }
        guard let user = session.createUser(name: name, email: email, password: password) else {
            errorMessage = "Este correo ya está registrado."; return false
        }
        errorMessage = nil
        registeredUser = user
        successMessage = "Cuenta creada. ¡Bienvenido a Bembos!"
        return true
    }
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var items: [ItemModel] = ItemModel.catalog { didSet { applyFilter() } }
    @Published var searchText = "" { didSet { applyFilter() } }
    @Published private(set) var filteredItems: [ItemModel] = ItemModel.catalog

    // Recomputed only when query or source data changes, never on unrelated body updates.
    private func applyFilter() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "es_PE"))
        guard !query.isEmpty else { filteredItems = items; return }
        filteredItems = items.filter { item in
            ([item.name, item.subtitle, item.category] + item.ingredients).joined(separator: " ")
                .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "es_PE"))
                .contains(query)
        }
    }
}
