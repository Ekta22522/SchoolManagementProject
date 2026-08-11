//
//  APIResponse.swift
//  EduVerse360
//
//  Created by Ekta Rai on 02/08/2026.
//

struct APIResponse<T: Codable>: Codable {

    let success: Bool
    let message: String
    let data: T

}
