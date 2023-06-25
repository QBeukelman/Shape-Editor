
# de Volksbank

## Shape Editor Application SwiftUI


This is a Shape Editor application built using SwiftUI. The application serves as a test assignment for the iOS Developer position at de Volksbank. It allows you to add and manipulate shapes on a canvas.



## Features

> **Add shapes:** Tap on the canvas to add a new shape at the tapped location. By default, the shape color, size and type will be random.

> **Edit shapes:** When a shape is selected, you can modify its properties using the Edit Shape Menu. The properties you can change include the color, shape type (ellipse or rectangle), and size.

> **Drag shapes:** You can drag shapes on the canvas by tapping and holding on a shape and then moving it to a new location.

> **Clear canvas:** You can clear the canvas and remove all shapes by tapping the eraser button.



## Usage

1. Run the application or preview ContentView.
2. Tap on the canvas to add a shape at the tapped location. By default, it will be a random shape.
3. To select a shape and access its properties, tap on the shape.
4. The Edit Shape Menu will appear, allowing you to modify the selected shape's properties.
5. You can change the color of the shape by using the color picker.
6. You can switch the shape type between ellipse and rectangle using the shape toggle.
7. Adjust the size of the shape using the size slider.
8. Tap outside the Edit Shape Menu to close it.
9. To move a shape, tap and hold on it, then drag it to a new location.
10. To remove all shapes from the canvas, tap the eraser button.



## Implementation Details

The application is implemented using SwiftUI and consists of the following components:

> **ContentView:** The main view of the application, which contains the canvas, shape rendering, shape manipulation functions, and the Edit Shape Menu.

> **Shape:** A model representing a shape. It contains properties such as position, shape type, size, color, and selection status.

> **ShapeType:** An enumeration representing the shape types (ellipse and rectangle).

> **Extensions:** Additional extensions for generating random colors, random sizes, and previewing the ContentView.



## Requirements

- Xcode 12.0 or later
- iOS 14.0 or later



## Preview

The ContentView is previewed in the ContentView_Previews struct.

```swift
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
```
