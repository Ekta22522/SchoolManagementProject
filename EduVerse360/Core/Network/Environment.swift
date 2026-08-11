//
//  Environment.swift
//  EduVerse360
//
//  Created by Ekta Rai on 01/08/2026.
//
import Foundation

enum APIEnvironment{
    case development
    case staging
    case production
    
var baseURL: URL{
    
    switch self{
        
    case.development:
        return URL(string:"http://localhost:3000")!
        
    case.staging:
        return URL(string:"")!
        
    case.production:
        return URL(string:"")!
    }
    }
}
