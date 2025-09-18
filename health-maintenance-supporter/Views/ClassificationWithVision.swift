//
//  Classifier.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-09.
//

import SwiftUI
import CoreML
import Vision
import PhotosUI

struct ClassificationWithVisionView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var prediction: String = ""
    @State private var isPickerPresented = false
    @State private var isLoading = false
    @State private var errorMessage: String = ""
    
    @State private var isSheetOpen = false
    
    @EnvironmentObject var foodItemViewModel : FoodItemViewModel
    @EnvironmentObject var mealViewModel : MealsViewModel

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
                    .overlay(Text("Upload an image of your food to identify").foregroundColor(.appPrimary))
            }
            
            Button("Choose Image") {
                isPickerPresented = true
            }
//            .buttonStyle(.borderedProminent)
            .padding()
            .background(Color.appSecondary)
            .foregroundColor(.appWhiteText)
            .cornerRadius(10)
            .disabled(isLoading)
            
            if isLoading {
                ProgressView("Classifying...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            if !prediction.isEmpty {
                VStack(spacing:10){
                    Text("Prediction: \(prediction)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                        Button("Confirm") {
                            let name = prediction.components(separatedBy: " (").first ?? prediction
                            foodItemViewModel.changeSelectedFood(food: name)
                            isSheetOpen = true
                        }
                        .padding()
                        .background(Color.appPrimary)
                        .cornerRadius(10)
                        .sheet(isPresented: $isSheetOpen) {
                            FoodItemDetails(portionSize: 100.0)
                                .environmentObject(foodItemViewModel)
                                .environmentObject(mealViewModel)
                        }
                }
            } else if !errorMessage.isEmpty {
                Text("Error: \(errorMessage)")
                    .font(.caption)
                    .foregroundColor(Color.clear)
            }
        }
        .onAppear {
            testModelLoading()
        }
        .padding()
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background(Color.appSecondary.opacity(0.2))
        .photosPicker(isPresented: $isPickerPresented,
                      selection: Binding(get: { nil }, set: { newItem in
            if let newItem = newItem {
                Task {
                    await loadAndClassifyImage(from: newItem)
                }
            }
        }))
    }
    

// MARK: - Model Testing
private func testModelLoading() {
    print("Testing model loading...")
    do {
        let config = MLModelConfiguration()
//        config.computeUnits = .cpuOnly

        
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
    
    // MARK: - Image Loading and Classification
    @MainActor
    private func loadAndClassifyImage(from item: PhotosPickerItem) async {
        isLoading = true
        errorMessage = ""
        prediction = ""
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
                await classifyImage(uiImage)
            }
        } catch {
            errorMessage = "Failed to load image: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Image Classification
private func classifyImage(_ image: UIImage) async {
    guard let processedImage = preprocessImage(image) else {
        await MainActor.run {
            errorMessage = "Failed to preprocess image"
        }
        return
    }
    
    guard let ciImage = CIImage(image: processedImage) else {
        await MainActor.run {
            errorMessage = "Failed to convert to CIImage"
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
                    }
                } else {
                    Task { @MainActor in
                        self.errorMessage = "No classification results returned"
                    }
                }
            } else {
                Task { @MainActor in
                    self.errorMessage = "Invalid result type - expected VNClassificationObservation"
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

