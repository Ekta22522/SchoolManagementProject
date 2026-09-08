//
//  PDFScreen.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/09/2026.
//

import SwiftUI

struct PDFScreen: View {
    let pdfURL: String
    var body: some View {
        if let url = URL(string: pdfURL) {
            PDFViewer(url: url)
                .navigationTitle("PDF")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("Invalid PDF URL")
        }
    }
}


#Preview {
    PDFScreen( pdfURL: "https://www.ioactive.com/wp-content/uploads/pdfs/IOActive_Remote_Car_Hacking.pdf")
}
