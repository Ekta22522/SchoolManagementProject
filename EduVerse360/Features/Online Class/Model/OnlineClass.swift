//
//  OnlineClass.swift
//  EduVerse360
//
//  Created by Ekta Rai on 31/08/2026.
//

struct OnlineClass:Decodable,Identifiable{
    let id: Int
    let title : String?
    let description : String
    let className : String
    let section : String
    let subject : String
    let teacherId : Int
    let meetingUrl : String
    let scheduledAt : String
    let classMode : String?
    let durationMinutes : Int
    let status : String
    let createdAt : String
    let updatedAt : String
    
}
