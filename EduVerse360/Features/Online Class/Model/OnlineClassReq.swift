//
//  onlineClassReq.swift
//  EduVerse360
//
//  Created by Ekta Rai on 31/08/2026.
//

struct OnlineClassReq:Encodable{
    let title : String
    let description : String
    let className : String
    let section : String
    let subject : String
    let meetingUrl : String
    let scheduledAt : String
    let durationMinutes : Int
}

