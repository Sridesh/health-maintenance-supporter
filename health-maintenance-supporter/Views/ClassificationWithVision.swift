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

    var body: some View {
        VStack(spacing: 20) {
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 250)
                    .overlay(Text("No Image Selected"))
            }
            
            Button("Choose Image") {
                isPickerPresented = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
            
            if isLoading {
                ProgressView("Classifying...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            if !prediction.isEmpty {
                Text("Prediction: \(prediction)")
                    .font(.headline)
                    .foregroundColor(.primary)
            } else if !errorMessage.isEmpty {
                Text("Error: \(errorMessage)")
                    .font(.caption)
                    .foregroundColor(.red)
            } else {
                Text("Prediction: No Prediction")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
    testModelLoading()
}
        .padding()
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
// MARK: - Model Testing
private func testModelLoading() {
    print("🔍 Testing model loading...")
    do {
        // Create CPU-only configuration for simulator compatibility
        let config = MLModelConfiguration()
        config.computeUnits = .cpuOnly
        print("⚙️ Using CPU-only configuration for simulator")
        
        // Test 1: Check if model file exists in bundle
        if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodel") {
            print("✅ Found .mlmodel at: \(modelURL)")
            // Test 2: Try loading the model with CPU config
            let coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
            print("✅ Model loaded successfully from bundle")
            // Test 3: Try creating Vision model
            let visionModel = try VNCoreMLModel(for: coreMLModel)
            print("✅ Vision model created successfully")
            
            // Print model details
            print("📋 Model details:")
            print("  - Input features: \(coreMLModel.modelDescription.inputDescriptionsByName.keys)")
            print("  - Output features: \(coreMLModel.modelDescription.outputDescriptionsByName.keys)")
            
        } else if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodelc") {
            print("✅ Found .mlmodelc at: \(modelURL)")
            let coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
            print("✅ Compiled model loaded successfully with CPU config")
            
        } else {
            print("❌ No model file found in bundle")
            // List all files containing "FoodClassifier" for debugging
            if let bundlePath = Bundle.main.resourcePath {
                let allFiles = try? FileManager.default.contentsOfDirectory(atPath: bundlePath)
                let modelFiles = allFiles?.filter { $0.contains("FoodClassifier") } ?? []
                print("📁 Files containing 'FoodClassifier': \(modelFiles)")
            }
            
            // Try loading using generated class as fallback
            print("🔄 Trying generated class...")
            let model = try FoodClassifier(configuration: config)
            print("✅ Generated class loaded successfully with CPU config")
            let visionModel = try VNCoreMLModel(for: model.model)
            print("✅ Vision model from generated class created successfully")
        }
        
    } catch {
        print("❌ Model loading failed: \(error)")
        print("❌ Error details: \(error.localizedDescription)")
        
        // Additional debugging for simulator issues
        if error.localizedDescription.contains("inference context") {
            print("💡 This appears to be a simulator limitation.")
            print("💡 Try running on a physical device for full CoreML support.")
            print("💡 Ensure your model is compatible with CPU-only execution.")
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
    // Preprocess the image to match training conditions
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
        
        // Load the .mlmodel file directly
        let coreMLModel: MLModel
        if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodelc") {
            // Use compiled model with configuration
            coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
            print("✅ Loaded compiled .mlmodelc with CPU-only config")
        } else if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodel") {
            // Use raw .mlmodel as fallback
            coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
            print("✅ Loaded raw .mlmodel with CPU-only config")
        } else {
            // Fallback to generated class (last resort)
            coreMLModel = try FoodClassifier(configuration: config).model
            print("⚠️ Loaded generated class model with CPU-only config")
        }
        
        // Print model information for debugging
        print("📋 Model input descriptions:")
        for (name, desc) in coreMLModel.modelDescription.inputDescriptionsByName {
            print("  - \(name): \(desc)")
        }
        print("📋 Model output descriptions:")
        for (name, desc) in coreMLModel.modelDescription.outputDescriptionsByName {
            print("  - \(name): \(desc)")
        }
        
        // Create Vision model
        let model = try VNCoreMLModel(for: coreMLModel)
        print("✅ VNCoreMLModel created successfully")
        
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
                
                // Get the top result
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
        
        // Set image crop and scale option to match training
        request.imageCropAndScaleOption = .centerCrop
        
        // Use proper image orientation
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

