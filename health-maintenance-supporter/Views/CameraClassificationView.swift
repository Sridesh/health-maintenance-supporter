//
//  CameraClassificationView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-15.
//


import SwiftUI
import CoreML
import Vision
import UIKit

struct CameraClassificationView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var prediction: String = ""
    @State private var isCameraPresented = false
    @State private var isLoading = false
    @State private var errorMessage: String = ""
    
    @EnvironmentObject var foodItemViewModel : FoodItemViewModel

    var body: some View {
        VStack(spacing: 20) {
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.appSecondary.opacity(0.3))
                    .frame(height: 250)
                    .overlay(
                        VStack(spacing: 10) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.appPrimary)
                            Text("Take a photo of your food to identify")
                                .foregroundColor(.appPrimary)
                                .multilineTextAlignment(.center)
                        }
                    )
            }
            
            Button("Take Photo") {
                isCameraPresented = true
            }
            .padding()
            .background(Color.appSecondary)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(isLoading)
            
            if isLoading {
                ProgressView("Classifying...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            if !prediction.isEmpty {
                VStack(spacing: 10) {
                    Text("Prediction: \(prediction)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    NavigationLink(destination:
                        FoodItemDetails(portionSize: 200.00)
                        .environmentObject(foodItemViewModel)
                    ) {
                        Text("Confirm")
                            .padding()
                            .background(Color.appSecondary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            } else if !errorMessage.isEmpty {
                Text("Error: \(errorMessage)")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            testModelLoading()
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color.appSecondary.opacity(0.2))
        .sheet(isPresented: $isCameraPresented) {
            CameraView { image in
                selectedImage = image
                Task {
                    await classifyImage(image)
                }
            }
        }
    }
    
    // MARK: - Model Testing
    private func testModelLoading() {
        print("Testing model loading...")
        do {
            let config = MLModelConfiguration()
            
            // Test 1: Check if model file exists in bundle
            if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodel") {
                
                let coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)

                let visionModel = try VNCoreMLModel(for: coreMLModel)
                print("vision model created successfully")
                
            } else if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodelc") {
                let coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
                print("Compiled model loaded successfully")
                
            } else {
                print("No model file found in bundle")
                // List all files containing "FoodClassifier" for debugging
                if let bundlePath = Bundle.main.resourcePath {
                    let allFiles = try? FileManager.default.contentsOfDirectory(atPath: bundlePath)
                    let modelFiles = allFiles?.filter { $0.contains("FoodClassifier") } ?? []
                    print("📁 Files containing 'FoodClassifier': \(modelFiles)")
                }

                let model = try FoodClassifier(configuration: config)
                let visionModel = try VNCoreMLModel(for: model.model)
            }
            
        } catch {
            print("Error details: \(error.localizedDescription)")
            
            if error.localizedDescription.contains("inference context") {
                print("Simulator limitation.")
            }
        }
    }
    
    // MARK: - Image Classification
    private func classifyImage(_ image: UIImage) async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
            prediction = ""
        }
        
        guard let processedImage = preprocessImage(image) else {
            await MainActor.run {
                errorMessage = "Failed to preprocess image"
                isLoading = false
            }
            return
        }
        
        guard let ciImage = CIImage(image: processedImage) else {
            await MainActor.run {
                errorMessage = "Failed to convert to CIImage"
                isLoading = false
            }
            return
        }
        
        do {
            // Create model configuration for CPU-only computation
            let config = MLModelConfiguration()
            config.computeUnits = .cpuOnly  // Force CPU-only for simulator compatibility
            
            // load the .mlmodel file directly
            let coreMLModel: MLModel
            if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodelc") {
                //use compiled model with configuration
                coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
                print("Loaded compiled .mlmodelc with CPU-only config")
            } else if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodel") {
                // Use raw .mlmodel as fallback
                coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
                print("Loaded raw .mlmodel with CPU-only config")
            } else {
                coreMLModel = try FoodClassifier(configuration: config).model
                print("Loaded generated class model with CPU-only config")
            }
            
            
            // Vision model
            let model = try VNCoreMLModel(for: coreMLModel)
            print("VNCoreMLModel created successfully")
            
            let request = VNCoreMLRequest(model: model) { request, error in
                if let error = error {
                    Task { @MainActor in
                        self.errorMessage = "Classification error: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                    return
                }
                
                if let results = request.results as? [VNClassificationObservation] {
                    print("🔍 Classification results:")
                    for (index, result) in results.prefix(5).enumerated() {
                        print("  \(index + 1). \(result.identifier): \(Int(result.confidence * 100))%")
                    }
                    
                    // get the top result
                    if let topResult = results.first {
                        Task { @MainActor in
                            if topResult.confidence > 0.01 { // Lower threshold for debugging
                                self.prediction = "\(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
                            } else {
                                self.prediction = "Low confidence: \(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
                            }
                            self.isLoading = false
                        }
                    } else {
                        Task { @MainActor in
                            self.errorMessage = "No classification results returned"
                            self.isLoading = false
                        }
                    }
                } else {
                    Task { @MainActor in
                        self.errorMessage = "Invalid result type - expected VNClassificationObservation"
                        self.isLoading = false
                    }
                }
            }
            
            // image crop and scale option to match training
            request.imageCropAndScaleOption = .centerCrop
            
            // image orientation
            let orientation = CGImagePropertyOrientation(image.imageOrientation)
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            try handler.perform([request])
            
        } catch {
            await MainActor.run {
                errorMessage = "Model loading error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    // MARK: - Image Preprocessing
    private func preprocessImage(_ image: UIImage) -> UIImage? {
        // Resize to expected input size (adjust based on your model's requirements)
        let targetSize = CGSize(width: 299, height: 299) // Common size for food classification models
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - Camera View
struct CameraView: UIViewControllerRepresentable {
    let onImageCaptured: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageCaptured(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
