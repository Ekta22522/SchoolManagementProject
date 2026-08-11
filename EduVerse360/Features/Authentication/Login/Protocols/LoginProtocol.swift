//
//  LoginAPIProtocol.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/07/2026.
//

import Foundation
protocol LoginProtocol{
    func login(req: LoginRequest) async throws -> LoginResponse
}
