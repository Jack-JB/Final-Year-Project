import SwiftUI
import SceneKit

struct ExpandableButton: View {
    let buttonSize: CGFloat = 60
    let buttonPadding: CGFloat = 15
    
    @State private var isExpanded = false
    @State private var selectedColor: Color? = nil
    
    let nodes: [SCNNode]
    let arViewController: ARViewController
    
    init(nodes: [SCNNode], arViewController: ARViewController) {
        self.nodes = nodes
        self.arViewController = arViewController
    }

    var body: some View {
        HStack {
            if isExpanded {
                HStack(spacing: buttonPadding) {
                    ColorButton(color: .red) { self.selectedColor = .red }
                    ColorButton(color: .blue) { self.selectedColor = .blue }
                    ColorButton(color: .green) { self.selectedColor = .green }
                }
                .transition(.move(edge: .leading))
            }
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 30))
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundColor(selectedColor ?? .primary)
                    .background(Color.secondary)
                    .cornerRadius(buttonSize / 2)
            }
            .padding(buttonPadding)
        }
        .onDisappear {
            selectedColor = nil
        }
        .onChange(of: selectedColor) { color in
            guard let color = color else { return }
            arViewController.changeNodeColour(nodes, color: UIColor(color))
            withAnimation {
                isExpanded = false
            }
        }
    }
}

struct ColorButton: View {
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            color
                .frame(width: 40, height: 40)
                .cornerRadius(20)
        }
    }
}


#if DEBUG
struct ColourBurron_Previews: PreviewProvider {
    static var previews: some View {
        var scene = SCNScene()
        let arViewController = ARViewController()
        ExpandableButton(nodes: scene.rootNode.childNodes, arViewController: arViewController)
    }
}
#endif
