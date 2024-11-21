//
//  ScanModel.swift
//  3D Object Viewer
//
//  Created by Aren Akian on 11/19/24.
//
// Description:
//      SwiftData Model for the Scan Data. 
//
import Foundation
import SwiftData

@Model
final class ScanModel {
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
}
