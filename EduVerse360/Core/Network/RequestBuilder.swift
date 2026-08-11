//
//  RequestBuilder.swift
//  EduVerse360
//
//  Created by Ekta Rai on 01/08/2026.
//
import Foundation

struct RequestBuilder{
    
    static func build(for endPoint: APIEndpoint) -> URLRequest {
        
        var request  = URLRequest(url: endPoint.url)
        
        request.httpMethod = endPoint.method.rawValue
        
        request.setValue(
            MIMEType.json,
            forHTTPHeaderField: HTTPHeaders.contentType
        )
        
        request.setValue(
            MIMEType.json,
            forHTTPHeaderField: HTTPHeaders.accept
        )
        
        if let token = UserDefaultsManager.shared.read(key:.token){
            
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: HTTPHeaders.authorization
            )
        }
        
        return request
        
    }
}
