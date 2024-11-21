//
//  GalleryView.swift
//  3D Object Viewer
//
//  Created by Aren Akian on 11/19/24.
//
//  Description:
//      Gallery view for the 3D Scans in MockData.
//      After authentication is complete, this is the app's home view.
//      Shows a thumbnail of each scan in a List.
//      Tapping on a list item navigates to ScanFileView for that file.
//
import SwiftUI
import SwiftData

struct GalleryView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Query private var scans: [ScanModel]
    @Query private var users: [User]
    @State private var reloadView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{
                List{
                    if !scans.isEmpty {
                        // sort scans reverse-alphabetical order
                        // to ensure robot is first
                        let sortedScans = scans.sorted {
                            $0.url.lastPathComponent > $1.url.lastPathComponent
                        }
                        ForEach(sortedScans) { scan in
                            NavigationLink(
                                destination: ScanFileView(fileURL: scan.url)
                            ) {
                                ThumbnailView(fileURL: scan.url)
                                    .scaleEffect(1)
                            }
                        }
                        .onDelete(perform: deleteScans)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .id(reloadView)
                .refreshable {
                    if scans.count < 5 {
                        loadData()
                    }
                }
                
                if scans.isEmpty {
                    withAnimation {
                        Text("Pull to refresh")
                    }
                }
                
                Spacer()
                
                Button{
                    print("Signing out user ")
                    authViewModel.signOut()
                } label: {
                    Text("Sign Out")
                        .padding()
                        .background(.red,
                                    in: RoundedRectangle(cornerRadius: 12 ))
                        .foregroundStyle(.white)
                        .bold()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .tint(.orange)
        .onAppear{
            if scans.isEmpty {
                loadData()
            }
        }
    }
    
    // Loads the mockData into the model context
    private func loadData() {
        for item in mockData {
            if let mockScan = Bundle.main.url(
                forResource: item,
                withExtension: "usdz"
            ){
                if scans.contains(where: { $0.url == mockScan }) {
                    // do nothing to filter out repeat data
                }
                else{
                    modelContext.insert(ScanModel(url: mockScan))
                }
            }
            reloadView.toggle()
        }
    }
    
    // Handle's deletion of a scan from the list
    private func deleteScans(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(scans[index])
            }
        }
    }
}

#Preview {
    GalleryView()
        .modelContainer(for: [ScanModel.self], inMemory: true)
}
