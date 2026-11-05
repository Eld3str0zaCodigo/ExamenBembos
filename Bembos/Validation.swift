import Foundation

enum Validation {
    static func normalizedEmail(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    static func isValidEmail(_ value: String) -> Bool {
        let email = normalizedEmail(value)
        guard email.count <= 254,
              let local = email.split(separator: "@").first, local.count <= 64 else { return false }
        let pattern = #"^[A-Za-z0-9_%+\-]+(?:\.[A-Za-z0-9_%+\-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9\-]{0,61}[A-Za-z0-9])?\.)+[A-Za-z]{2,63}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    static func passwordError(_ value: String) -> String? {
        guard value.count >= 6 else { return "La contraseña debe tener al menos 6 caracteres." }
        guard value.unicodeScalars.contains(where: { CharacterSet.uppercaseLetters.contains($0) }) else {
            return "Agrega al menos una letra mayúscula."
        }
        // Explicit permitted punctuation excludes dots, commas, semicolons and accent marks.
        let special = CharacterSet(charactersIn: "!\"#$%&'()*+-/:<=>?@[\\]^_`{|}~")
        guard value.unicodeScalars.contains(where: { special.contains($0) }) else {
            return "Agrega un carácter especial, por ejemplo !, @, # o $. Los puntos, comas, punto y coma y tildes no cuentan."
        }
        return nil
    }
}
