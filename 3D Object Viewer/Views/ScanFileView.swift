//
//  ScanFileView.swift
//  3D Object Viewer
//
//  Created by Aren Akian on 11/19/24.
//
//  Description:
//      View that creates an interactive scene for a given .usdz file
//      Allows the user to zoom, drag, rotate, and reset the 3D object.
//      
//
import SwiftUI
import SceneKit

struct ScanFileView: View {
    @State var fileURL: URL?
    @State private var scene: SCNScene?
    @State private var cameraNode = SCNNode()
    @State private var updateView = false

    var body: some View {
        if let url = fileURL {
            VStack {
                ZStack {
                    // Blank BG Rectangle to reduce flicker on resetView()
                    Rectangle()
                        .fill(.white)
                    
                    SceneView(scene: scene,
                              pointOfView: cameraNode,
                              options: [.allowsCameraControl,
                                        .autoenablesDefaultLighting]
                    )
                    .id(updateView) // force update view
                    .highPriorityGesture(
                        TapGesture(count: 2)
                            .onEnded {
                                resetView()
                            }
                    )
                }
                .frame(maxHeight: .infinity)
                .toolbarBackgroundVisibility(.visible)
                .ignoresSafeArea(.all)
                
                // Display file name
                Text(url.lastPathComponent)
                    .padding(.top)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Pinch to zoom, drag to rotate, double-tap to reset")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Button("Reset View") {
                        self.resetView()
                    }
                    .bold()
                    .padding()
                    .background(.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                    
             
            }
            .background(.ultraThinMaterial)
            .onAppear {
                setupScene()
            }
        }
    }
        
    private func setupScene() {
        if scene == nil {
            scene = SCNScene()
        }
        if cameraNode.camera == nil {
            cameraNode.camera = SCNCamera()
        }
        if cameraNode.parent == nil {
            scene?.rootNode.addChildNode(cameraNode)
        }
            
        loadFile()
    }
    
    private func loadFile() {
        guard let url = fileURL else {
            print("Failed to find URL")
            return
        }
        
        let sceneSource = SCNSceneSource(url: url, options: nil)
        if let newScene = sceneSource?.scene() {
            scene = newScene
            resetView()
        }
    }
    
    private func resetView() {
        // Reset camera
        cameraNode.position = SCNVector3(0, 0, 40)
        cameraNode.eulerAngles = SCNVector3Zero
        cameraNode.scale = SCNVector3(1, 1, 1)
        
        //  Force view update with animation to reduce jarring transition
        withAnimation(.snappy) {
            updateView.toggle()
        }
    }
}


#Preview {
    if let url = Bundle.main.url(forResource: "Airforce Sneaker",
                                 withExtension: "usdz") {
        ScanFileView(fileURL: url)
            .onAppear {
                print("URL valid: \(url)")
            }
    } else {
        EmptyView()
    }
    
}
