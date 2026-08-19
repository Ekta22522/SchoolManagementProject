
//
//  Untitled.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//

import Foundation
struct ClassReq: Encodable{
    
    let className : String
    let description : String
    
    
    enum CodingKeys:String, CodingKey{
        case className = "class_name"
        case description
        
    }
}



