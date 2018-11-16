//
//  ViewController.swift
//  w3MachineLearning
//
//  Created by Xcode User on 2018-09-19.
//  Copyright © 2018 Jeanice Nguyen. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scene : UIImageView!
    @IBOutlet weak var answerLabel : UILabel!
    
    let vowels : [Character] = ["a", "e", "i", "o", "u"]
    
    func detectScene(image: CIImage) {
        answerLabel.text = "detecting scene ...."
        guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model)
            else{
                fatalError("Can't load places ml model")
        }
        let request = VNCoreMLRequest(model: model) {[weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topresult = results.first else{
                    fatalError("unexpected result of type from VNCoreMLrequest")
            }
            
            let article = (self?.vowels.contains(topresult.identifier.first!))! ? "an" : "a"
            
            self?.answerLabel.text = "\(Int(topresult.confidence * 100))% its \(article) \(topresult.identifier)"
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
               try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
    }
    
    @IBAction func pickImage(sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        scene.image = image
        
        let ciImage = CIImage(image: image!)
        detectScene(image: ciImage!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let image = UIImage(named: "train_night")
        scene.image = image
        
        let ciImage = CIImage(image: image!)
        detectScene(image: ciImage!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

