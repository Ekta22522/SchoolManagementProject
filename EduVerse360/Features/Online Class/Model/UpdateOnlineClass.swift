//
//  UpdateOnlineClass.swift
//  EduVerse360
//
//  Created by Ekta Rai on 02/09/2026.
//

struct UpdateOnlineClassReq:Encodable{
    let title : String
    let description : String
    let className : String
    let section : String
    let subject : String
    let meetingUrl : String
    let scheduledAt : String
    let durationMinutes : Int
}

struct UpdateOnlineClassRes:Decodable{
    let success : Bool
    let message : String
    let data : OnlineClass
}
