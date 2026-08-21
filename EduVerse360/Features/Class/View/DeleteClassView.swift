//
//  SwiftUIView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/08/2026.
//

import SwiftUI

struct DeleteClassView: View {
    @State var viewModel = DeleteClassViewModel()
    @Environment(NavigationRouter.self) private var router
    let classId : String
    var body: some View {
        VStack{
            Text(viewModel.className)
            Text(viewModel.description)
           
            Button(
                action:{
                    Task{
                        await viewModel.deleteClass(id: classId)
                    }
                },label:{
                    Text("Delete")
                        .foregroundColor(Color.white)
                }
            )
            .frame(maxWidth:120,maxHeight: 50)
            .background(Color.primary)
            .cornerRadius(10)
            
        }
        .alert(
            "Success",
            isPresented: $viewModel.isDeleteClass
        ) {
            Button("OK", role: .cancel) {
                router.pop()
            }
        } message: {
            Text("Class with id: \(classId) is deleted successfully")
        }
        .task {
            await viewModel.getClassById(id: classId)
        }
    }
}

#Preview {
    DeleteClassView(classId: "")
}
