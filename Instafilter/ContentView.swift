//
//  ContentView.swift
//  Instafilter
//
//  Created by Guntars Reiss on 31/08/2022.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI

// MARK: - Day 64

// MARK: - Day 63
// MARK: - Lesson One
// Core Image and how to use it in SwiftUI
struct LessonOne: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
        }
        .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        // Step 1: Load our image into a UIImage
        guard let inputImage = UIImage(named: "Example") else { return }
        // Step 2: Convert that into CIImage. CIImage is what Core Image wants to work with.
        let beginImage = CIImage(image: inputImage)
        // Step 3: Create the context and filter
        let context = CIContext()
        let currentFilter = CIFilter.twirlDistortion()
        // Step 4: Customize the filter
        currentFilter.inputImage = beginImage
        
        
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
    
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }
        
        // Step 5: Get a CIImage from our filter
        guard let outputImage = currentFilter.outputImage else { return }
        // Step 6-8: Convert the CIImage back to CGimage, then to UIImage and finally to SwiftUI Image.
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
}

// MARK: - Lesson Two
// How to wrap UIViewController in a SwiftUI view
struct LessonTwoView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select Image") {
                showingImagePicker = true
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable { // makeUIVC + updateUIVC to conform to protocol

    func makeUIViewController(context: Context) -> some UIViewController {
        // Step 1: Make configuration, asking to provide us only images
        var config = PHPickerConfiguration()
        config.filter = .images
        // Step 2: Create and return the picker that does the actual work of selecting an image
        let picker = PHPickerViewController(configuration: config)
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // not used
    }
}



