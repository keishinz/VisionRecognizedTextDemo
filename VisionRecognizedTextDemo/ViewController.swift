//
//  ViewController.swift
//  VisionRecognizedTextDemo
//
//  Created by Keishin CHOU on 2019/12/26.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var image: UIImage? = {
        let image = UIImage()
        return image
    }()
    
    lazy private var textDetectionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en_US"]
        request.usesLanguageCorrection = true
        return request
    }()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(useCamera))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(usePhoto))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func useCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Cannot use camera.")
        }
    }
    
    @objc func usePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func processImage() {
        guard  let image = image, let cgImage = image.cgImage else { return }
        let requests = [textDetectionRequest]
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(requests)
            } catch {
                print("Process image error: \(error.localizedDescription)")
            }
//        }
        
    }
    
    func handleDetectedText(request: VNRequest?, error: Error?) {

        if error == nil {
            guard let observations = request?.results as? [VNRecognizedTextObservation] else { return }
            for observation in observations {
                let bestObservation = observation.topCandidates(1).first
                print(bestObservation?.string ?? "")
                print(bestObservation?.confidence ?? 0)
//                print(bestObservation?.boundingBox(for: Range<String.Index>))
            }
            
            let newViewController = ResultTableViewController()
            newViewController.observations = observations
            newViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(newViewController, animated: true)
            
        }
        
//        if let error = error {
//            presentAlert(title: "Error", message: error.localizedDescription)
//            return
//        }
        
        
        
    }
    
    fileprivate func presentAlert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }


}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[.editedImage] as? UIImage
        imageView.image = image
        dismiss(animated: true, completion: processImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

