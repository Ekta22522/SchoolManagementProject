//
//  DeleteOnlineClass.swift
//  EduVerse360
//
//  Created by Ekta Rai on 04/09/2026.
//
import SwiftUI

struct DeleteOnlineClassView: View {
    @FocusState private var focusedField: Field?
    @State var viewModel = DeleteOnlineClassViewModel()
    @Environment(NavigationRouter.self) private var router
    let onlineClassId : Int
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            
            // MARK: - Title
            
            AppTextField(
                title: "Title",
                imageName: "",
                placeholder: "Enter your title",
                field: .title,
                error: viewModel.titleError,
                text: $viewModel.title,
                focusedField: $focusedField
            )
            
            // MARK: - Class
            
            Text("Class")
                .font(.caption)
                .padding(.top, 5)
                .padding(.bottom, 6)
            
            Menu {
                
                Button("Grade 1") {
                    viewModel.className = "Grade 1"
                }
                
                Button("Grade 2") {
                    viewModel.className = "Grade 2"
                }
                
                Button("Grade 3") {
                    viewModel.className = "Grade 3"
                }
                
                Button("Grade 4") {
                    viewModel.className = "Grade 4"
                }
                
                Button("Grade 5") {
                    viewModel.className = "Grade 5"
                }
                
                Button("Grade 6") {
                    viewModel.className = "Grade 6"
                }
                
                Button("Grade 7") {
                    viewModel.className = "Grade 7"
                }
                
                Button("Grade 8") {
                    viewModel.className = "Grade 8"
                }
                
            } label: {
                
                HStack {
                    
                    Text(
                        viewModel.className.isEmpty
                        ? "Select your class"
                        : viewModel.className
                    )
                    .foregroundColor(
                        viewModel.className.isEmpty
                        ? .secondary
                        : .primary
                    )
                    
                    Spacer()
                    
                    Image("dropdown")
                }
                .padding(.horizontal, 12)
                .frame(
                    maxWidth: .infinity,
                    minHeight: 45
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            Color.textFieldColor,
                            lineWidth: 1
                        )
                )
            }
            
            
            // MARK: - Section
            
            Text("Section")
                .font(.caption)
                .padding(.top, 10)
                .padding(.bottom, 6)
            
            Menu {
                
                Button("Sec A") {
                    viewModel.section = "Sec A"
                }
                
                Button("Sec B") {
                    viewModel.section = "Sec B"
                }
                
                Button("Sec C") {
                    viewModel.section = "Sec C"
                }
                
                Button("Sec D") {
                    viewModel.section = "Sec D"
                }
                
            } label: {
                
                HStack {
                    
                    Text(
                        viewModel.section.isEmpty
                        ? "Select Your Section"
                        : viewModel.section
                    )
                    .foregroundColor(
                        viewModel.section.isEmpty
                        ? .secondary
                        : .primary
                    )
                    
                    Spacer()
                    
                    Image("dropdown")
                }
                .padding(.horizontal, 12)
                .frame(
                    maxWidth: .infinity,
                    minHeight: 45
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            Color.textFieldColor,
                            lineWidth: 1
                        )
                )
            }
        
          
            
            // MARK: - Subject
            
            Text("Subject")
                .font(.caption)
                .padding(.top, 10)
                .padding(.bottom, 6)
            
            Menu {
                
                Button("Science") {
                    viewModel.subject = "Science"
                }
                
                Button("Math") {
                    viewModel.subject = "Math"
                }
                
                Button("Social Studies") {
                    viewModel.subject = "Social Studies"
                }
                
                Button("English") {
                    viewModel.subject = "English"
                }
                
            } label: {
                
                HStack {
                    
                    Text(
                        viewModel.subject.isEmpty
                        ? "Select your Subject"
                        : viewModel.subject
                    )
                    .foregroundColor(
                        viewModel.subject.isEmpty
                        ? .secondary
                        : .primary
                    )
                    
                    Spacer()
                    
                    Image("dropdown")
                }
                .padding(.horizontal, 12)
                .frame(
                    maxWidth: .infinity,
                    minHeight: 45
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            Color.textFieldColor,
                            lineWidth: 1
                        )
                )
            }
            
        
            
            // MARK: - Create Button
            
            Button {
                
                Task {
                    await viewModel.deleteOnlineClass(id: onlineClassId)
                }
                
            } label: {
                
                HStack {
                    
                    if viewModel.isLoading {
                        
                        ProgressView()
                            .tint(.white)
                        
                        Text("Deleting...")
                            .foregroundColor(.white)
                        
                    } else {
                        
                        Text("Delete Class")
                            .foregroundColor(.white)
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    minHeight: 50
                )
                .background(Color.primary)
                .cornerRadius(10)
            }
            .disabled(viewModel.isLoading)
            .padding(.top, 20)
            .padding(.bottom, 30)
            .task {
                await viewModel.getOnlineClassId(id: onlineClassId)
                
            }
            .alert("Success", isPresented: $viewModel.isSuccess) {
                Button("OK") {
                    // Optional: navigate back
                }
            } message: {
                Text("Online class deleted successfully.")
            }
            if let error = viewModel.errorMessage {
                
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
            
            
            
        }
        .padding(.horizontal, 25)
        .frame(
            maxWidth: .infinity,
            minHeight: 600,
            alignment: .top
        )
        
        
    }
}



#Preview {
   DeleteOnlineClassView(onlineClassId: 0)
}
