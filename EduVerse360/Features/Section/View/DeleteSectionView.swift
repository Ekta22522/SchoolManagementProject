//
//  DeleteSectionView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 25/08/2026.
//

import SwiftUI

struct DeleteSectionView: View {
    var sectionId : Int
    @State var viewModel = DeleteSectionViewModel()
    @Environment(NavigationRouter.self) private var router
    var body: some View {
        VStack{
            Text(viewModel.sectionName)
           
            Button(
                action:{
                    Task{
                        await viewModel.deleteSection(id: sectionId)
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
            isPresented: $viewModel.isDeleteSuccess
        ) {
            Button("OK", role: .cancel) {
                router.pop()
            }
        } message: {
            Text("Class with id: \(sectionId) is deleted successfully")
        }
        .task {
            await viewModel.getSectionById(id: sectionId)
        }
    }
}

#Preview {
    DeleteSectionView(sectionId: 0)
}
