//
//  MultipartFormData.swift
//  EduVerse360
//
//  Created by Ekta Rai on 02/08/2026.
//
import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

final class MultipartFormData{
    
    let boundary = UUID().uuidString
    
    private(set) var body = Data()
    
    func addText(
        name: String,
        value: String
    ) {

        body.append("--\(boundary)\r\n")

        body.append(
            "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
        )

        body.append("\(value)\r\n")
    }
    
    
    func addFile(
        data: Data,
        name: String,
        fileName: String,
        mimeType: String
    ) {

        body.append("--\(boundary)\r\n")

        body.append(
            """
            Content-Disposition: form-data; name="\(name)"; filename="\(fileName)"
            Content-Type: \(mimeType)

            """
        )

        body.append(data)

        body.append("\r\n")
    }
    
    func finalize() {

        body.append("--\(boundary)--\r\n")

    }
}


