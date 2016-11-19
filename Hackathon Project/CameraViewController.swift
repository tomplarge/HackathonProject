//
//  CameraViewController.swift
//  Hackathon Project
//
//  Created by Tom Large on 11/19/16.
//  Copyright © 2016 WildHacks. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var TextField: UITextField!
    @IBAction func LibraryButton(_ sender: Any) {
        let LibraryUI = UIImagePickerController()
        LibraryUI.delegate = self
        LibraryUI.allowsEditing = true
        LibraryUI.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(LibraryUI, animated: true, completion: nil)
    }
    @IBAction func DoneButton(_ sender: Any) {
    }
    @IBAction func CameraButton(_ sender: Any) {
        let CameraUI = UIImagePickerController()
        CameraUI.delegate = self
        CameraUI.allowsEditing = true
        CameraUI.sourceType = UIImagePickerControllerSourceType.camera
        self.present(CameraUI, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        ImageView.image = originalImage
        dismiss(animated: true, completion: nil)
    }

}
