//
//  AssignmentProtocolImp.swift
//  EduVerse360
//
//  Created by Ekta Rai on 05/09/2026.
//
import Foundation


class AssignmentServerAPI: AssignmentProtocol {
    
    func createAssignment(
        req: AssignmentRequest
    ) async throws -> AssignmentResponse {
        
        let multipart = MultipartFormData()
        
        multipart.addText(
            name: "title",
            value: req.title
        )
        
        multipart.addText(
            name: "description",
            value: req.description
        )
        
        multipart.addText(
            name: "className",
            value: req.className
        )
        
        multipart.addText(
            name: "section",
            value: req.section
        )
        
        multipart.addText(
            name: "subject",
            value: req.subject
        )
        
        multipart.addText(
            name: "dueDate",
            value: req.dueDate
        )
        
        multipart.addText(
            name: "maxMarks",
            value: String(req.maxMarks)
        )
        
        multipart.addText(
            name: "status",
            value: req.status
        )
        
        // PDF attachment
        if let attachment = req.attachment,
           let fileName = req.attachmentFileName {
            
            multipart.addFile(
                data: attachment,
                name: "attachment",
                fileName: fileName,
                mimeType: "application/pdf"
            )
        }
        
        let response: AssignmentResponse =
        try await APIClient.shared.multipartRequest(
            APIEndpoint.createTeacherAssignment,
            multipart: multipart
        )
        
        return response
    }
    
    func getAllAssignment() async throws -> AllTeacherAssignmentRes {
        do{
            let response : AllTeacherAssignmentRes = try await APIClient.shared.request(APIEndpoint.allTeacherAssignment)
            return response
        }catch let error{
            throw error
        }
    }
    
}

