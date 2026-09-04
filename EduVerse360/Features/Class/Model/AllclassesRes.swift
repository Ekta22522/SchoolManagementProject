//
//  AllclassesReq.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//

struct AllclassesRes: Decodable{
    let success : Bool
    let totalClasses :Int
    let data : [Class]
    
    enum CodingKeys : String,CodingKey{
        case success
        case totalClasses = "total_classes"
        case data
    }
}
