import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 21) {
                BrandLogo().frame(height: 62).frame(maxWidth: .infinity).padding(.vertical, 16)
                VStack(alignment: .leading, spacing: 8) {
                    Text("SÚMATE AL SABOR").font(Brand.heading(27)).foregroundStyle(Brand.blue)
                    Text("Crea tu cuenta Bembos.").foregroundStyle(.secondary)
                }
                Group {
                    LabeledField(title: "Nombre *") {
                        TextField("¿Cómo te llamas?", text: $viewModel.name)
                            .textContentType(.name).textInputAutocapitalization(.words)
                            .accessibilityLabel("Nombre")
                    }
                    LabeledField(title: "Correo electrónico *") {
                        TextField("nombre@dominio.com", text: $viewModel.email)
                            .keyboardType(.emailAddress).textContentType(.emailAddress)
                            .textInputAutocapitalization(.never).autocorrectionDisabled()
                            .accessibilityLabel("Correo electrónico")
                    }
                    PasswordField(title: "Contraseña *", value: $viewModel.password)
                    PasswordField(title: "Confirmar contraseña *", value: $viewModel.confirmation)
                }
                .disabled(viewModel.registeredUser != nil)
                Text("Usa al menos 6 caracteres, una mayúscula y un carácter especial como !, @ o #. Los puntos, comas, punto y coma y tildes no cuentan como especiales.")
                    .font(.footnote).foregroundStyle(.secondary)
                if let error = viewModel.errorMessage { Feedback(text: error) }
                if let success = viewModel.successMessage { Feedback(text: success, success: true) }
                Button(viewModel.registeredUser == nil ? "Crear cuenta" : "Cuenta creada") {
                    viewModel.register(session: session)
                }
                .buttonStyle(PrimaryButtonStyle()).disabled(viewModel.isDisabled)
            }
            .padding(25).frame(maxWidth: 540).frame(maxWidth: .infinity)
        }
        .background(.white).scrollDismissesKeyboard(.interactively)
        .navigationTitle("Crear cuenta").navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(viewModel.registeredUser != nil)
        .task(id: viewModel.registeredUser?.id) {
            guard let user = viewModel.registeredUser else { return }
            do { try await Task.sleep(nanoseconds: 1_200_000_000) }
            catch { return }
            guard !Task.isCancelled else { return }
            session.signIn(user)
        }
    }
}
