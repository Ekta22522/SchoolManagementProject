import SwiftUI




struct ClassItemRow: View {
    
    let title: String
    let subtitle: String
    let action: () -> Void
    
    
    var body: some View {
        
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        
    }
}


struct AllClassesView: View {
    
    @Environment(NavigationRouter.self) private var router
    @State private var viewModel = AllClassesViewModel()
    
    var body: some View {
        VStack(alignment:.trailing){
            HStack(spacing:50){
                Button(action:{
                    router.goToAllOnlineClass()
                },label:{
                    Text("Online Class")
                        .foregroundStyle(Color.white)
                })
                
                .frame(maxWidth: 100, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(20)
                .padding()
                
                Text("All Classes")
                    .font(.headline)
                Button(action:{
                    router.goToClasses()
                },label:{
                    Text("Add")
                        .foregroundStyle(Color.white)
                })
                
                .frame(maxWidth: 100, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(20)
                .padding()
                
            }
            List(viewModel.classes) { classItem in
                ClassItemRow(
                    title: classItem.className,
                    subtitle: classItem.description,
                    action: {
                        router.goToClassById(id: "\(classItem.id)")
                    })
            }
        }
        .navigationTitle("All Classes")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getAllClasses()
        }
    }
}


#Preview {
    AllClassesView()
}
