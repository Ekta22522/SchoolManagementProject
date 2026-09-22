import SwiftUI
import UniformTypeIdentifiers

struct AllTeacherAssignmentView: View {
    @Environment(TabRouter.self) private var router
    @Environment(UserSession.self) private var session
    
    @State private var viewModel = AllTeacherAssignmentViewModel()
    @State private var hasAppeared = false
    
    private var teacherFilterId: Int? {
        session.activeRole == .teacher ? session.user?.id : nil
    }
    
    private var isStudent: Bool {
        session.activeRole == .student
    }
    
    
    
    var body: some View {
        ZStack{
            Color.pageBackground
                .ignoresSafeArea()
            VStack{
                // MARK: Headers
                
                HStack{
                    Text(session.activeRole == .teacher ? "My assignments" : "Assignments")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    
                    if !isStudent {
                        Button(action:{
                            router.push(AssignmentRoute.create)
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
                        viewModel.selectedFilter == .all ? Color.primary : .white
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
                        viewModel.selectedFilter == .published ? Color.primary : .white
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
                        viewModel.selectedFilter == .pending ? Color.primary : .white
                    )
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                }
                .padding()
                
                // MARK: Main Card List
                if viewModel.isLoading && viewModel.filteredAssignments.isEmpty {
                    // MARK: Loading State
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredAssignments.isEmpty {
                    // MARK: Empty State
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundStyle(.secondary)
                        Text("No assignments yet")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(isStudent ? "No assignments available." : "Tap + to create your first assignment.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView{
                        LazyVStack(spacing: 16) {

                            ForEach (viewModel.filteredAssignments){assignment in
                        AssignmentCard(assignment: assignment,
                                       viewPdfAction: {
                            viewModel.showAssignmentPdf = true
                            print("View PDF: \(assignment.title)")
                        })
                        .onTapGesture {
                            router.push(AssignmentRoute.detail(id: assignment.id))
                        }

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
                await viewModel.allTeacherAssignment(teacherId: teacherFilterId)
                }
            // The first .task only runs once, so when the teacher pops
            // back here after viewing/updating/deleting an assignment
            // the list would be stale — refetch on every reappear.
            .onAppear {
                if hasAppeared {
                    Task {
                        await viewModel.allTeacherAssignment(teacherId: teacherFilterId)
                    }
                }
                hasAppeared = true
            }
            
            
            
        }
        
    }
}

#Preview {
    AllTeacherAssignmentView()
}
