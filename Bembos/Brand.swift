import SwiftUI

enum Brand {
    static let blue = Color(red: 17.0 / 255, green: 0, blue: 207.0 / 255)
    static let red = Color(red: 0.96, green: 0.04, blue: 0.10)
    static let yellow = Color(red: 1.00, green: 0.71, blue: 0.00)
    static let background = Color(red: 0.97, green: 0.97, blue: 0.98)
    static let ink = Color(red: 0.10, green: 0.10, blue: 0.16)
    static func heading(_ size: CGFloat) -> Font {
        .custom("DejaVuSansCondensed-BoldOblique", size: size, relativeTo: .title)
    }
}

struct BrandLogo: View {
    var white = false
    var body: some View {
        Image(white ? "brandLogoWhite" : "brandLogo")
            .resizable().scaledToFit()
            .accessibilityLabel("Bembos")
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var enabled
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 18)
            .foregroundStyle(.white)
            .background(enabled ? Brand.blue : Brand.blue.opacity(0.4), in: Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct LabeledField<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title).font(.subheadline.weight(.medium)).foregroundStyle(Brand.ink)
            content()
                .padding(16).frame(minHeight: 54)
                .background(.white, in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.55), lineWidth: 1))
        }
    }
}

struct PasswordField: View {
    let title: String
    @Binding var value: String
    @State private var isVisible = false
    var body: some View {
        LabeledField(title: title) {
            HStack(spacing: 10) {
                Group {
                    if isVisible { TextField("Tu contraseña", text: $value) }
                    else { SecureField("Tu contraseña", text: $value) }
                }
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .accessibilityLabel(title)
                Button { isVisible.toggle() } label: {
                    Image(systemName: isVisible ? "eye" : "eye.slash")
                        .foregroundStyle(Brand.ink).frame(width: 32, height: 28)
                }
                .accessibilityLabel(isVisible ? "Ocultar contraseña" : "Mostrar contraseña")
            }
        }
    }
}

struct Feedback: View {
    let text: String
    var success = false
    var body: some View {
        Label(text, systemImage: success ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
            .font(.subheadline).foregroundStyle(success ? Color.green : Brand.red)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.updatesFrequently)
    }
}
