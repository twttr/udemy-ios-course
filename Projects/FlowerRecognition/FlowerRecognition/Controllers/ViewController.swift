//
//  ViewController.swift
//  FlowerRecognition
//
//  Created by Pavel Romanishkin on 04.04.21.
//

import UIKit
import CoreML
import Vision
import SDWebImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    let imagePicker = UIImagePickerController()
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Error picking the image")
        }
        guard let ciImage = CIImage(image: image) else {
            fatalError("Error converting to CIImage")
        }
        imageView.image = image
        
        detect(ciImage: ciImage)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func detect(ciImage: CIImage) {
        let config = MLModelConfiguration()
        if let model =  try? VNCoreMLModel(for: FlowerClassifier(configuration: config).model) {
            let request = VNCoreMLRequest(model: model) { (request, error) in
                self.processClassifications(for: request, error: error)
            }
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            guard let firstResult = classifications.first else {
                fatalError("classifications are empty")
            }
            self.navigationItem.title = firstResult.identifier
            self.networkManager.fetchFlower(flowerName: firstResult.identifier, completion: { (result) in
                self.textView.text = result["text"]
                self.imageView.sd_setImage(with: URL(string: result["image"]!))
            })
        }
    }
}


