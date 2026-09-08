//
//  AssignmentModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 05/09/2026.
//

import Foundation

struct Assignment :Decodable,Identifiable{
    let id : Int
    let title: String
    let description: String
    let className: String
    let section: String
    let subject: String
    let teacherId: Int
    let dueDate: String
    let maxMarks: Int
    let attachmentUrl:String?
    let attachmentOriginalName:String?
    let status: String
    let createdAt : String
    let updatedAt : String
    
}

struct AssignmentRequest :Encodable{
    let title: String
    let description: String
    let className: String
    let section: String
    let subject: String
    let dueDate: String
    let maxMarks: Int
    let status: String
    let attachment: Data?
    let attachmentFileName: String?
}

struct AssignmentResponse: Decodable {
    let success: Bool
    let message: String
    let data: Assignment
}


