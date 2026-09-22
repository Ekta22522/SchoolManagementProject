import SwiftUI




struct ClassCardRow: View {

    let title: String
    let subtitle: String
    let action: () -> Void


    var body: some View {

        Button {
            action()
        } label: {
            HStack(spacing: 12) {

                VStack(alignment: .leading, spacing: 6) {

                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)

    }
}


struct AllClassesView: View {

    @Environment(TabRouter.self) private var router
    @State private var viewModel = AllClassesViewModel()

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header

                HStack {
                    Text("All Classes")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: {
                        router.push(ClassRoute.create)
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: 50, maxHeight: 50)
                            .background(Color.primary)
                            .clipShape(Circle())
                            .shadow(radius: 10, y: 2)
                    })
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 15)

                // MARK: Content

                if viewModel.isLoading && viewModel.classes.isEmpty {

                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if viewModel.classes.isEmpty {

                    VStack(spacing: 12) {
                        Image(systemName: "building.columns")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)

                        Text("No classes yet")
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text("Tap the + button to add your first class.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 30)

                } else {

                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.classes) { classItem in
                                ClassCardRow(
                                    title: classItem.className,
                                    subtitle: classItem.description,
                                    action: {
                                        router.push(ClassRoute.detail(id: classItem.id))
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getAllClasses()
            }
        }
    }
}


#Preview {
    AllClassesView()
        .environment(TabRouter())
}
