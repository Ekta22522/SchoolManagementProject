
import SwiftUI

struct ListOnlineClassView: View {

    @Environment(NavigationRouter.self) private var router
    @State private var viewModel = ListOnlineClassViewModel()
  

    var body: some View {

        ZStack(alignment: .bottomTrailing) {

            // MARK: - Background
            Color.primary
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 8) {

                    Text("Ready To Learn?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Choose your online class")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25)
                .padding(.top, 35)
                .padding(.bottom, 25)


                // MARK: - White Content Section
                VStack(alignment: .leading, spacing: 0) {

                    Text("Online Classes")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 25)
                        .padding(.top, 25)
                        .padding(.bottom, 15)


                    // MARK: - Classes
                    ScrollView(.vertical, showsIndicators: false) {

                        if let onlineClasses = viewModel.onlineClass,
                           !onlineClasses.isEmpty {

                            LazyVStack(spacing: 15) {

                                ForEach(onlineClasses) { onlineClass in
                                  


                                    VStack(alignment: .leading, spacing: 12) {

                                        // MARK: Title
                                        if let title = onlineClass.title {

                                            Text(title)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.primary)
                                        }


                                        // MARK: Description
                                        Text(onlineClass.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(3)


                                        Divider()


                                        // MARK: Class Information
                                        HStack(spacing: 15) {

                                            // Class
                                            VStack(alignment: .leading, spacing: 4) {

                                                Text("Class")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)

                                                Text(onlineClass.className)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                            }


                                            Spacer()


                                            // Subject
                                            VStack(alignment: .trailing, spacing: 4) {

                                                Text("Subject")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)

                                                Text(onlineClass.subject)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                            }
                                        }


                                        // MARK: Section
                                        HStack {

                                            Label(
                                                onlineClass.section,
                                                systemImage: "person.3"
                                            )
                                            .font(.caption)
                                            .foregroundColor(.secondary)

                                            Spacer()

                                            Label(
                                                "\(onlineClass.durationMinutes) min",
                                                systemImage: "clock"
                                            )
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        }

                                    }
                                    .onTapGesture{
                                        router.goToOnlineClassById(id: onlineClass.id)
                                    }
                                    .padding(18)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 16,
                                            style: .continuous
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(
                                            cornerRadius: 16,
                                            style: .continuous
                                        )
                                        .stroke(
                                            Color.gray.opacity(0.15),
                                            lineWidth: 1
                                        )
                                    )
                                    .shadow(
                                        color: .black.opacity(0.08),
                                        radius: 8,
                                        x: 0,
                                        y: 3
                                    )
                                }
                                    
                               
                            }
                           

                        } else {

                            // MARK: - Empty State
                            VStack(spacing: 12) {

                                Image(systemName: "video.slash")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)

                                Text("No Online Classes")
                                    .font(.headline)
                                    .fontWeight(.semibold)

                                Text("There are no online classes available yet.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 80)
                            .padding(.horizontal, 30)
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.white
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 40,
                                style: .continuous
                            )
                        )
                )
            }
            .ignoresSafeArea(edges: .bottom)


            // MARK: - Create Class Button
            Button {

                router.goToOnlinceClass()

            } label: {

                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 58, height: 58)
                    .background(Color.primary)
                    .clipShape(Circle())
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            }
            .padding(.trailing, 25)
            .padding(.bottom, 25)
        }
        .task {
            await viewModel.getListOnlineClass()
        }
    }
}


#Preview {
    ListOnlineClassView()
}

