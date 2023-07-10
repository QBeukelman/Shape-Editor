//
//  ContentView-ViewModel.swift
//  Shapes
//
//  Created by Quentin Beukelman on 30/06/2023.
//

import Foundation
import SwiftUI

// MARK: - Main Actor
/// The main actor is responsible for running all user interface updates
/// UI Updates must happen on the main actor

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var shapes: [Shape] = []
        @Published var selectedShapeType: ShapeType = .ellipse
        @Published var g_tapLocation: CGPoint = .zero
        
        func saveCanvas(shapes: [Shape], name: String) {
            let filePath = FileManager.documentsDirectory
            
        }
        
        func addNewShape(tapLocation: CGPoint) {
            g_tapLocation = tapLocation
            deselectAllShapes()
            let shape = Shape.randomShape(at: tapLocation)
            shapes.append(shape)
        }
        
        func deselectAllShapes() {
            // Deselect all shapes when a new shape is added
            shapes.indices.forEach {
                shapes[$0].isSelected = false
                shapes[$0].shadowColor = Color.clear
            }
        }
        
    }
}


// MARK: - File Manager
extension FileManager {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
