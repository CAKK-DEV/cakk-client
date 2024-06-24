//
//  MultiplePhotoPicker.swift
//  SwiftUIUtil
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import PhotosUI

public struct MultiplePhotoPicker: UIViewControllerRepresentable {
  
  // MARK: - Properties
  
  private let selectionLimit: Int
  
  @Binding var selectedImages: [UIImage]
  
  
  // MARK: - Initializers
  
  public init(
    selectionLimit: Int = 0, /// 0은 선택 제한이 없음을 의미합니다.
    selectedImages: Binding<[UIImage]>
  ) {
    self.selectionLimit = selectionLimit
    _selectedImages = selectedImages
  }
  
  
  // MARK: - LifeCycles
  
  public func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.selectionLimit = selectionLimit
    
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
    var parent: MultiplePhotoPicker
    
    init(_ parent: MultiplePhotoPicker) {
      self.parent = parent
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true, completion: nil)
      
      let group = DispatchGroup()
      var images = [UIImage]()
      
      for result in results {
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
          group.enter()
          result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
            if let image = object as? UIImage {
              images.append(image)
            }
            group.leave()
          }
        }
      }
      
      group.notify(queue: .main) {
        self.parent.selectedImages = images
      }
    }
  }
}
