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
import UIKit
import CoreVideo

struct ClassifierView: View {
    
    @EnvironmentObject var foodItemViewModel : FoodItemViewModel
    @State private var selectedImage: UIImage? = nil
    @State private var prediction: String = ""
    @State private var isPickerPresented = false
    @State private var isLoading = false
    @State private var errorMessage: String = ""
    
    @State private var navigateToDetails = false

    var body: some View {
        NavigationView{
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

        Button("Confirm") {
            foodItemViewModel.changeSelectedFood(food: prediction)
            navigateToDetails = true
        }
        .buttonStyle(.borderedProminent)
    } else if !errorMessage.isEmpty {
        Text("Error: \(errorMessage)")
            .font(.caption)
            .foregroundColor(.red)
    } else {
        Text("Prediction: No Prediction")
            .foregroundColor(.secondary)
    }

    // Always present the NavigationLink in the view hierarchy
    NavigationLink(
        destination: FoodItemDetails(portionSize: 200.0)
            .environmentObject(foodItemViewModel),
        isActive: $navigateToDetails,
        label: { EmptyView() } // hidden link
    )
}

        }
        .onAppear { testModelLoading() }
        .padding()
        .photosPicker(isPresented: $isPickerPresented,
                      selection: Binding(get: { nil }, set: { newItem in
            if let newItem = newItem {
                Task { await loadAndClassifyImage(from: newItem) }
            }
        }))
    }

    // MARK: - Model Testing
    private func testModelLoading() {
        print("🔍 Testing model loading...")
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .cpuOnly
            print("⚙️ Using CPU-only configuration for simulator")

            if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodel") {
                let coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
                print("✅ Model loaded successfully from bundle")
                let _ = try VNCoreMLModel(for: coreMLModel)
                print("✅ Vision model created successfully")
            } else if let modelURL = Bundle.main.url(forResource: "FoodClassifier", withExtension: "mlmodelc") {
                let coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
                print("✅ Compiled model loaded successfully with CPU config")
            } else {
                let model = try FoodClassifier(configuration: config)
                let _ = try VNCoreMLModel(for: model.model)
                print("✅ Generated class loaded and Vision model created successfully")
            }
        } catch {
            print("❌ Model loading failed: \(error)")
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
            await MainActor.run { errorMessage = "Failed to preprocess image" }
            return
        }

        do {
            let config = MLModelConfiguration()
            config.computeUnits = .cpuOnly

            #if targetEnvironment(simulator)
            // -------------------------------
            // Simulator-safe CoreML direct prediction
            // -------------------------------
            let model = try FoodClassifier(configuration: config)
            guard let buffer = processedImage.toCVPixelBuffer() else {
                await MainActor.run { errorMessage = "Failed to convert image to CVPixelBuffer" }
                return
            }
            let prediction = try model.prediction(image: buffer)
            await MainActor.run { self.prediction = "\(prediction.target)" }

            #else
            // -------------------------------
            // Real device: use VNCoreMLRequest
            // -------------------------------
            guard let ciImage = CIImage(image: processedImage) else {
                await MainActor.run { errorMessage = "Failed to convert to CIImage" }
                return
            }

            let coreMLModel = try VNCoreMLModel(for: FoodClassifier(configuration: config).model)
            let request = VNCoreMLRequest(model: coreMLModel) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    Task { @MainActor in
                        self.prediction = "\(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
                    }
                } else {
                    Task { @MainActor in
                        self.errorMessage = "No classification results"
                    }
                }
            }

            request.imageCropAndScaleOption = .centerCrop
            let handler = VNImageRequestHandler(ciImage: ciImage,
                                                orientation: CGImagePropertyOrientation(image.imageOrientation))
            try handler.perform([request])
            #endif

        } catch {
            await MainActor.run { errorMessage = "Classification error: \(error.localizedDescription)" }
        }
    }

    // MARK: - Image Preprocessing
    private func preprocessImage(_ image: UIImage) -> UIImage? {
        let targetSize = CGSize(width: 299, height: 299)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - UIImage Orientation Extension
extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}

// MARK: - UIImage to CVPixelBuffer
extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        var pixelBuffer: CVPixelBuffer?

        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(buffer, [])
        let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        guard let ctx = context else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }

        ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer
    }
}

// MARK: - Preview
#Preview {
    ClassifierView()
}
