import SwiftUI


struct AppTextField: View {
    let title: String
    let imageName: String
    let placeholder: String
    let field: Field
    let error: String?

    @Binding var text: String
    @FocusState.Binding var focusedField: Field?

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)
                .fontWeight(.semibold)

            // TextField box
            HStack {
                Image(imageName)
                    .foregroundStyle(.gray)
                    .padding()

                TextField(placeholder, text: $text)
                    .focused($focusedField, equals: field)
                    .submitLabel(.next)
                    .onSubmit {
                        if field == .username {
                            focusedField = .password
                        } else {
                            focusedField = nil
                        }
                    }
            }
            .frame(width: 300, height: 45)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.textFieldColor, lineWidth: 1)
            )

            // Error MUST be outside the TextField box
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(width: 300, alignment: .leading)
        .padding(.bottom, 8)
    }
}
