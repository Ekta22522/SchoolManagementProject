import SwiftUI
import UniformTypeIdentifiers

struct AllTeacherAssignmentView: View {
    @Environment(NavigationRouter.self) private var router
    
    @State private var viewModel = AllTeacherAssignmentViewModel()
    
    
    
    var body: some View {
        ZStack{
            Color.pageBackground
                .ignoresSafeArea()
            VStack{
                // MARK: Headers
                
                HStack{
                    Text("My assignments")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    
                    Button(action:{
                        router.goToCreateAssigniment()
                    },label:{
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: 50,maxHeight: 50)
                            .background(Color.primary)
                            .clipShape(Circle())
                            .shadow( radius: 10, y: 2)
                        
                    })
                }
                
                // MARK: Filters
                HStack(spacing:20){
                    Button("All"){
                        withAnimation{
                            viewModel.selectedFilter = .all
                        }
                        viewModel.filterAssignment(status: .all)
                    }
                    .foregroundStyle(viewModel.selectedFilter == .all ? .white : .secondaryText )
                    .padding(.horizontal,16)
                    .padding(.vertical,8)
                    .background(
                        viewModel.selectedFilter == .all ? .black : .white
                    )
                    .clipShape(Capsule())
                    
                    
                    Button("Published"){
                        withAnimation{
                            viewModel.selectedFilter = .published
                        }
                        viewModel.filterAssignment(status: .published)
                    }
                    .foregroundStyle(viewModel.selectedFilter == .published ? .white : .secondaryText )
                    .padding(.horizontal,16)
                    .padding(.vertical,8)
                    .background(
                        viewModel.selectedFilter == .published ? .black : .white
                    )
                    .clipShape(Capsule())
                    
                    Button("Pending"){
                        withAnimation{
                            viewModel.selectedFilter = .pending
                        }
                        viewModel.filterAssignment(status: .pending)
                    }
                    .foregroundStyle(viewModel.selectedFilter == .pending ? .white : .secondaryText )
                    .padding(.horizontal,16)
                    .padding(.vertical,8)
                    .background(
                        viewModel.selectedFilter == .pending ? .black : .white
                    )
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                }
                .padding()
                
                // MARK: Main Card List
                ScrollView{
                    LazyVStack(spacing: 16) {
                           
                        ForEach (viewModel.filteredAssignments){assignment in
                    AssignmentCard(assignment: assignment,
                                   viewPdfAction: {
                        viewModel.showAssignmentPdf = true
                        print("View PDF: \(assignment.title)")
                    })
                    .onTapGesture {
                        router.goToTeacherAssignmentById(id: assignment.id)
                    }
                            
                        }
                        }
                }
                
         
                
             
            }
            .padding()
            .sheet(isPresented: $viewModel.showAssignmentPdf) {
                PDFScreen( pdfURL: "https://www.ioactive.com/wp-content/uploads/pdfs/IOActive_Remote_Car_Hacking.pdf")
            }
            .task {
                await viewModel.allTeacherAssignment()
                }
            
            
            
        }
        
    }
}

#Preview {
    AllTeacherAssignmentView()
}
