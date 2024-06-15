//
//  PhotoPicker.swift
//  SwiftUIUtil
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import PhotosUI

public struct PhotoPicker: UIViewControllerRepresentable {
  
  // MARK: - Properties
  
  @Binding var selectedImage: UIImage?
  
  
  // MARK: - Initializers
  
  public init(selectedImage: Binding<UIImage?>) {
    _selectedImage = selectedImage
  }
  
  
  // MARK: - LifeCycles
  
  public func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.selectionLimit = 1
    
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator
    return picker
  }
  
  public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
  
  
  // MARK: - Coordinator
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, PHPickerViewControllerDelegate {
    var parent: PhotoPicker
    
    init(_ parent: PhotoPicker) {
      self.parent = parent
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true, completion: nil)
      
      guard let provider = results.first?.itemProvider else { return }
      
      if provider.canLoadObject(ofClass: UIImage.self) {
        provider.loadObject(ofClass: UIImage.self) { (image, error) in
          DispatchQueue.main.async {
            self.parent.selectedImage = image as? UIImage
          }
        }
      }
    }
  }
}
