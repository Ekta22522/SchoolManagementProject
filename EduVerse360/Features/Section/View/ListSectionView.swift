import SwiftUI

struct ListSectionView: View {

    @State var viewModel = ListSectionViewModel()

    @Environment(NavigationRouter.self) private var router

    var body: some View {
        VStack {
            if let sections = viewModel.listSection {

                List(sections) { section in

                    VStack(alignment: .leading) {

                        Text("id: \(section.id)")

                        Text("Class ID: \(section.classId)")

                        if let className = section.className {
                            Text("ClassName: \(className)")
                        }

                        Text("Section Name: \(section.sectionName)")

                        Text("Class Teacher: \(section.classTeacher)")

                        Text("Capacity: \(section.capacity)")

                        Text("Created At: \(section.createdAt)")
                    }
                    .onTapGesture {
                        router.goToSectionById(
                            id:(section.id)
                        )
                    }
                }
            }
        }
        .task {
            await viewModel.getAllSection()
        }
    }
}

#Preview {
    ListSectionView()
}
