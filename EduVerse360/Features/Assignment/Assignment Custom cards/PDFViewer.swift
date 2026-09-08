//
//  PDFViewer.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/09/2026.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        
        loadPDF(in: pdfView)
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        loadPDF(in: pdfView)
    }
    
    private func loadPDF(in pdfView: PDFView) {
        guard let document = PDFDocument(url: url) else {
            print("Failed to load PDF")
            return
        }
        
        pdfView.document = document
    }
}
