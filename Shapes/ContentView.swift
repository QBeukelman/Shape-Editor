//
//  ContentView.swift
//  Shapes
//
//  Created by Quentin Beukelman on 22/06/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var shapes: [Shape] = []
    @State private var selectedShapeType: ShapeType = .ellipse
    @State var g_tapLocation: CGPoint = .zero
    
    
    var body: some View {
        
        renderCanvas()
        
        // MARK: - Add shape
            .onTapGesture { tapLocation in
                g_tapLocation = tapLocation
                // Deselect all shapes when a new shape is added
                shapes.indices.forEach {
                    shapes[$0].isSelected = false
                    shapes[$0].shadowColor = Color.clear
                }
                let shape = Shape.randomShape(at: tapLocation)
                shapes.append(shape)
            }
    }
    
    
    // MARK: - Edit Shape Menu
    func renderMenu() -> some View {
        if let selectedShape = shapes.first(where: { $0.isSelected }) {
            return AnyView(
                VStack(spacing: 20) {
                    
                    addColorPicker(selectedShape: selectedShape)
                    addShapeToggle(selectedShape: selectedShape)
                    addSizeSlider(selectedShape: selectedShape)
                    
                    Button("Done") {
                        shapes.indices.forEach {
                            shapes[$0].isSelected = false
                            shapes[$0].shadowColor = Color.clear
                        }
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    // MARK: - Add Color Picker
    func addColorPicker(selectedShape: Shape) -> some View {
        ColorPicker("Select Color", selection: Binding(
            get: { selectedShape.color },
            set: { newValue in
                if let index = shapes.firstIndex(where: { $0.id == selectedShape.id }) {
                    shapes[index].color = newValue
                    shapes[index].shadowColor = newValue
                }
            }
        ))
    }
    
    // MARK: - Add Shapes Toggle
    func addShapeToggle(selectedShape: Shape) -> some View {
        Toggle("Circle", isOn: Binding(
            get: { selectedShape.shapeType == .ellipse },
            set: { newValue in
                if let index = shapes.firstIndex(where: { $0.id == selectedShape.id }) {
                    if newValue {
                        shapes[index].shapeType = .ellipse
                        let shape = Shape.randomShape(
                            at: g_tapLocation,
                            shapeType: .ellipse,
                            size: shapes[index].size,
                            color: shapes[index].color)
                        shapes[index] = shape
                        shapes[index].isSelected = true
                        shapes[index].shadowColor = shape.color
                        
                    } else {
                        shapes[index].shapeType = .rectangle
                        let shape = Shape.randomShape(
                            at: g_tapLocation,
                            shapeType: .rectangle,
                            size: shapes[index].size,
                            color: shapes[index].color)
                        shapes[index] = shape
                        shapes[index].isSelected = true
                        shapes[index].shadowColor = shape.color
                    }
                }
                selectedShapeType = newValue ? .ellipse : .rectangle
            }
        ))
        .tint(.gray)
    }
    
    // MARK: - Add Size Slider
    func addSizeSlider(selectedShape: Shape) -> some View {
        HStack {
            Text("Size")
                .padding(.trailing, 20)
            Slider(value: Binding(
                get: { selectedShape.size.width },
                set: { newValue in
                    if let index = shapes.firstIndex(where: { $0.id == selectedShape.id }) {
                        shapes[index].size = CGSize(width: newValue, height: newValue)
                    }
                }
            ), in: 50...150, step: 1)
        }
        .tint(.gray)
    }
    
    
    // MARK: - Render Shapes
    func renderShapes() -> some View {
        ZStack {
            ForEach(shapes) { shape in
                shape.view
                    .frame(width: shape.size.width, height: shape.size.height)
                    .position(x: shape.position.x, y: shape.position.y)
                    .foregroundColor(shape.color)
                    .shadow(color: shape.shadowColor, radius: 15)
                    .onTapGesture {
                        handleTap(shape: shape)
                        g_tapLocation = shape.position
                    }
                
                // MARK: Drag
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                if let index = shapes.firstIndex(where: { $0.id == shape.id }) {
                                    shapes[index].position = value.location
                                    shapes[index].isDragging = true
                                    g_tapLocation = value.location
                                }
                            })
                        
                            .onEnded({ value in
                                if let index = shapes.firstIndex(where: { $0.id == shape.id }) {
                                    shapes[index].isDragging = false
                                    g_tapLocation = value.location
                                }
                            })
                    )
            }
        }
    }
    
    
    // MARK: - Render Canvas
    func renderCanvas() -> some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            // MARK: Render Shapes
            renderShapes()
            
            VStack {
                // MARK: Clear Button
                HStack {
                    Spacer()
                    Button(action: { shapes.removeAll() }) {
                        Image(systemName: "eraser.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                }
                Spacer()
                
                // MARK: Render Edit Menu
                HStack {
                    Spacer()
                    renderMenu()
                }
                .onTapGesture {}
                .padding()
                .background(
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }
    
    
    
    // MARK: - Handle Tap
    func handleTap(shape: Shape) {
        // Deselect all shapes when a new shape is added
        shapes.indices.forEach {
            shapes[$0].isSelected = false
            shapes[$0].shadowColor = Color.clear
        }
        if let index = shapes.firstIndex(where: { $0.id == shape.id }) {
            if shapes[index].isSelected {
                shapes[index].shadowColor = Color.clear
                shapes[index].isSelected = false
            } else {
                // Deselect other shapes
                shapes.indices.forEach { shapes[$0].isSelected = false }
                shapes[index].shadowColor = shape.color
                shapes[index].isSelected = true
            }
        }
    }
}


// MARK: - Shape
struct Shape: Identifiable {
    var isDragging = false
    var position = CGPoint.zero
    let id = UUID()
    let view: AnyView
    var shapeType: ShapeType
    var size: CGSize
    var color: Color
    var shadowColor: Color = Color.clear
    var isSelected = false
    
    static func randomShape(at position: CGPoint, shapeType: ShapeType? = nil, size: CGSize? = nil, color: Color? = nil) -> Shape {
        let randomColor = color ?? Color.random
        let randomSize = CGFloat.random(in: 50...150)
        let equalRandomSize = size ?? CGSize(width: randomSize, height: randomSize)
        let selectedShapeType = shapeType ?? (Bool.random() ? ShapeType.ellipse : ShapeType.rectangle)
        
        let shapeView: AnyView
        switch selectedShapeType {
        case .ellipse:
            shapeView = AnyView(Ellipse())
        case .rectangle:
            shapeView = AnyView(Rectangle())
        }
        
        return Shape(
            isDragging: false,
            position: position,
            view: shapeView,
            shapeType: selectedShapeType,
            size: equalRandomSize,
            color: randomColor,
            shadowColor: Color.clear
        )
    }
}


enum ShapeType {
    case ellipse
    case rectangle
}

extension Color {
    static var random: Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(Float.random(in: 0...1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
