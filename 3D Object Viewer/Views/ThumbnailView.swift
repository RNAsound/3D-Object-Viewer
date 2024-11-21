//
//  ThumbnailView.swift
//  3D Object Viewer
//
//  Created by Aren Akian on 11/19/24.
//
//  Description:
//      The Thumbnail view for a given .usdz file, for use in GalleryView.
//      Generates a thumbnail for the 3D object using Quicklook,
//      and display's the input file's name.
//
//  Note:
//      This only works on a real device.
//      QuickLook thumbnail generator is broken on Canvas and Preview,
//      and will display default AR icon unless you're using on a real device
//

import SwiftUI
import QuickLookThumbnailing

struct ThumbnailView: View {
    @State var fileURL: URL?
    @State var thumbnailImage: Image?
    
    var body: some View {
        VStack {
            if let thumbnailImage = thumbnailImage {
                HStack(alignment: .center, spacing: 0){
                    thumbnailImage
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .clipped()
                        .scaleEffect(0.9)
                        .padding(.horizontal, 10)

                    Spacer()
                    
                    Text(fileURL?.deletingPathExtension().lastPathComponent ?? "No File Selected")
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                }
                .frame(maxHeight: 160)

            } else {
                ProgressView()
                    .frame(width: 120, height: 120)
                    .onAppear {
                        generateThumbnail(for: fileURL)
                    }
            }
        }
    }
    
    func generateThumbnail(for resource: URL?) {
        guard let url = resource else { return }
        
        let size: CGSize = CGSize(width: 120, height: 120) // Adjust as needed
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: size,
            scale: scale,
            representationTypes: .all
        )
        
        let generator = QLThumbnailGenerator.shared
        generator.generateBestRepresentation(for: request) {  (thumbnail, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error generating thumbnail: \(error.localizedDescription)")

                } else if let thumbnail = thumbnail {
                    thumbnailImage = Image(uiImage: thumbnail.uiImage)
                } else {
                    print("Failed to generate a thumbnail.")
                    
                }
            }
        }
    }
}


#Preview {
    if let url = Bundle.main.url(forResource: "robot", withExtension: "usdz") {
        ThumbnailView(fileURL: url)
            .onAppear {
                print("URL valid: \(url)")
            }
    } else {
        EmptyView()
    }
}
