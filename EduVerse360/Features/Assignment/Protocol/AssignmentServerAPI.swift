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
    
    func getTeacherAssignmentById(id:Int) async throws -> TeacherAssignimentByIdRes {
        do{
            let response : TeacherAssignimentByIdRes = try await APIClient.shared.request(APIEndpoint.getTeacherAssignmentById(id: id))
            return response
        }catch let error{
            throw error
        }
    }
    
    func updateTeacherAssignment(id:Int, req:AssignmentRequest) async throws -> UpdateAssignmentRes {

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

        // PDF attachment — only sent when the teacher picked a new file
        if let attachment = req.attachment,
           let fileName = req.attachmentFileName {

            multipart.addFile(
                data: attachment,
                name: "attachment",
                fileName: fileName,
                mimeType: "application/pdf"
            )
        }

        do{
            let response : UpdateAssignmentRes = try await APIClient.shared.multipartRequest(APIEndpoint.updateAssignment(id: id), multipart: multipart)
            return response
        }catch let error{
            throw error
        }
    }
    
    func deleteTeacherAssignment(id: Int) async throws -> DeleteTeacherAssignmentRes {
        let response : DeleteTeacherAssignmentRes = try await APIClient.shared.request(APIEndpoint.deleteAssignment(id: id))
        return response
    }
    
}

