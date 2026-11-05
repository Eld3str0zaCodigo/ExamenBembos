import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                BrandLogo().frame(height: 88).frame(maxWidth: .infinity)
                    .padding(.top, 50).padding(.bottom, 24)
                VStack(alignment: .leading, spacing: 6) {
                    Text("¡QUÉ BUENO VERTE!").font(Brand.heading(25)).foregroundStyle(Brand.blue)
                    Text("Ingresa y encuentra tu Bembos favorita.").font(.subheadline).foregroundStyle(.secondary)
                }
                LabeledField(title: "Correo electrónico *") {
                    TextField("nombre@dominio.com", text: $viewModel.email)
                        .keyboardType(.emailAddress).textContentType(.emailAddress)
                        .textInputAutocapitalization(.never).autocorrectionDisabled()
                        .accessibilityLabel("Correo electrónico")
                }
                PasswordField(title: "Contraseña *", value: $viewModel.password)
                if let error = viewModel.errorMessage { Feedback(text: error) }
                Button("Iniciar sesión") { viewModel.login(session: session) }
                    .buttonStyle(PrimaryButtonStyle()).disabled(viewModel.isDisabled)
                NavigationLink { RegisterView() } label: {
                    Text("¿No tienes cuenta? Regístrate")
                        .font(.headline).multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity).padding(.vertical, 17)
                        .overlay(Capsule().stroke(Brand.blue, lineWidth: 1.5))
                }
                Text("Sabor peruano. Espíritu Bembos.")
                    .font(.footnote).foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity).padding(.top, 18)
            }
            .padding(.horizontal, 25).padding(.bottom, 32)
            .frame(maxWidth: 540).frame(maxWidth: .infinity)
        }
        .background(.white).scrollDismissesKeyboard(.interactively)
        .toolbar(.hidden, for: .navigationBar)
    }
}
