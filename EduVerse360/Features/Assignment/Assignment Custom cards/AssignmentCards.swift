//
//  AssignmentCards.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/09/2026.
//

import SwiftUI

struct AssignmentCard: View {
    let assignment : Assignment
    let viewPdfAction : () -> Void
    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack{
                HStack(spacing:2){
                    Text(assignment.subject)
                    Text(".")
                        .offset(y:-6)
                    Text("\(assignment.className) \(assignment.section)")
                    
                }
                .foregroundStyle(Color.tertiaryText)
                Spacer()
                Button(assignment.status){
                    
                }
                .foregroundStyle(Color.teal)
                .padding(.horizontal,16)
                .padding(.vertical,8)
                .background(
                    Color.tealTint
                )
                .clipShape(Capsule())
            }
            
           
            Text(assignment.title)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing:2){
                Text("Due \(formatDueDate(assignment.dueDate))")
                Text(".")
                    .offset(y:-6)
                Text("\(assignment.maxMarks) marks")
            }
                .foregroundStyle(Color.tertiaryText)
            
            if let fileName = assignment.attachmentOriginalName {
                HStack {
                    Image(systemName: "paperclip")

                    Text(fileName)
//                        .lineLimit(1)
                    Spacer()
                }
                .foregroundStyle(Color.secondaryText)
                .padding(.horizontal,14)
                .padding(.vertical,16)
                .background(Color.inputFields)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onTapGesture{viewPdfAction()}
                    
                
            }
            
            
            Divider()
                .foregroundStyle(Color.divider)
                .padding(.vertical,10)
            HStack{
                VStack(alignment:.leading){
                    Text("18 of 29 submitted")
                        .fontWeight(.semibold)
                    Text("Marking not started")
                        .foregroundStyle(Color.tertiaryText)
                        .font(.subheadline)
                }
                Spacer()
                Button("Mark"){
                    
                }
                .foregroundStyle(Color.secondaryText)
                .padding(.horizontal,14)
                .padding(.vertical,12)
                .background(Color.inputFields)
                .clipShape(Capsule())
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08),
                radius: 6,
                x: 0,
                y: 3)
    }
}


#Preview {
    AssignmentCard(
        assignment: Assignment(
            id: 5,
            title: "Social Studies Assignment",
            description: "Complete Chapter 5 questions",
            className: "Grade 9",
            section: "A",
            subject: "Social Studies",
            teacherId: 23,
            dueDate: "2026-09-05T18:14:00.000Z",
            maxMarks: 100,
            attachmentUrl: "assignments/1788600504327-9dc6515a-36de-4702-ab18-ddee2731e65a.pdf",
            attachmentOriginalName: "Ekta_Rai_CV_iOS_React.pdf",
            status: "published",
            createdAt: "2026-09-05T09:28:24.339Z",
            updatedAt: "2026-09-05T09:28:24.339Z"
        
        ),
        viewPdfAction: {}
    )
}

func formatDueDate(_ dateString: String) -> String {
    
    let inputFormatter = ISO8601DateFormatter()
       inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let date = inputFormatter.date(from: dateString) else {
        return dateString
    }
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "d MMM, HH:mm"
    
    return outputFormatter.string(from: date)
}

