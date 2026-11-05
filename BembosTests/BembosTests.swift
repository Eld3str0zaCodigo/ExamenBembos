import XCTest
@testable import Bembos

final class BembosTests: XCTestCase {
    func testPasswordRules() {
        XCTAssertNotNil(Validation.passwordError("Ab!12"))
        XCTAssertNotNil(Validation.passwordError("abcde!"))
        for password in ["Abcdef.", "Abcdef,", "Abcdef;", "Abcdeá", "Abcde´", "Abcdeé"] {
            XCTAssertNotNil(Validation.passwordError(password), password)
        }
        XCTAssertNil(Validation.passwordError("Bembos!1"))
        XCTAssertNil(Validation.passwordError("Abcde@"))
    }

    func testEmailFormat() {
        XCTAssertTrue(Validation.isValidEmail(" jose@example.com "))
        for value in ["", "jose", "a@b", "a b@c.pe", "a@@b.pe", "a..b@c.pe", ".a@c.pe", "a@-c.pe", "a@c-.pe"] {
            XCTAssertFalse(Validation.isValidEmail(value))
        }
    }

    @MainActor
    func testRegistrationUniquenessAndSessionLifecycle() {
        let session = SessionStore(seedDemo: false)
        let vm = RegisterViewModel()
        XCTAssertFalse(vm.register(session: session))
        vm.name = "José"
        vm.email = " JOSE@example.com "
        vm.password = "Bembos!1"
        vm.confirmation = "otra"
        XCTAssertFalse(vm.register(session: session))
        XCTAssertTrue(session.users.isEmpty)
        vm.confirmation = vm.password
        XCTAssertTrue(vm.register(session: session))
        XCTAssertEqual(session.users.count, 1)
        XCTAssertEqual(session.users.first?.email, "jose@example.com")
        XCTAssertNotNil(vm.successMessage)
        XCTAssertNil(session.currentUser) // Success appears before navigation.
        guard let user = vm.registeredUser else { return XCTFail("Missing registered user") }
        session.signIn(user)
        XCTAssertEqual(session.currentUser, user)
        session.logout()
        XCTAssertNil(session.currentUser)
        XCTAssertTrue(session.emailExists(" JOSE@EXAMPLE.COM "))
        XCTAssertNil(session.createUser(name: "Otro", email: "Jose@example.com", password: "Bembos!1"))
        XCTAssertTrue(session.authenticate(email: "jose@example.com", password: "Bembos!1"))
    }

    @MainActor
    func testLoginErrorsAndValidCredentials() {
        let session = SessionStore()
        let vm = LoginViewModel()
        XCTAssertTrue(vm.isDisabled)
        vm.email = "no-es-correo"
        vm.password = "Bembos!1"
        XCTAssertFalse(vm.login(session: session))
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertNil(session.currentUser)
        vm.email = "demo@bembos.pe"
        XCTAssertNil(vm.errorMessage)
        vm.password = "Bembos!2"
        XCTAssertFalse(vm.login(session: session))
        vm.password = "Bembos!1"
        XCTAssertTrue(vm.login(session: session))
        XCTAssertEqual(vm.validatedEmail, "demo@bembos.pe")
        XCTAssertEqual(vm.validatedPassword, "Bembos!1")
        XCTAssertNotNil(session.currentUser)
    }

    @MainActor
    func testReactiveSearchAndSourceChanges() {
        let vm = HomeViewModel()
        XCTAssertGreaterThanOrEqual(vm.items.count, 8)
        XCTAssertEqual(Set(vm.items.map(\.id)).count, vm.items.count)
        vm.searchText = " CLASICA "
        XCTAssertTrue(vm.filteredItems.contains { $0.id == "clasica" })
        let unaccentedResults = vm.filteredItems.map(\.id)
        vm.searchText = "Clásica"
        XCTAssertEqual(vm.filteredItems.map(\.id), unaccentedResults)
        vm.searchText = "ROYAL"
        XCTAssertEqual(vm.filteredItems.map(\.id), ["royal"])
        vm.searchText = "tocino"
        XCTAssertTrue(vm.filteredItems.contains { $0.id == "quesoTocino" })
        vm.searchText = "no existe este producto"
        XCTAssertTrue(vm.filteredItems.isEmpty)
        vm.searchText = "Royal"
        vm.items.removeAll { $0.id == "royal" }
        XCTAssertTrue(vm.filteredItems.isEmpty)
        vm.searchText = ""
        XCTAssertEqual(vm.filteredItems.count, vm.items.count)
    }
}
