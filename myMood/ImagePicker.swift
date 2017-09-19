import UIKit

protocol ImagePickerDelegate {
    func updateEventWithImage(image:UIImage)
    func removeEventImage()
}

class ImagePicker: UIView, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBAction func addImageAction(_ sender: Any) {
        addImage()
    }
    @IBOutlet weak var deleteImageButton: UIButton!
    
    @IBAction func deleteImage(_ sender: Any) {
        deleteImage()
    }
    
    let bottomVC = UIApplication.shared.keyWindow?.rootViewController
    var delegate:ImagePickerDelegate? = nil
   
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.backgroundColor = UIColor.white
  
    }
   
    func addImage () {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.bottomVC?.present(imagePickerController, animated: true, completion: nil)
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (action : UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.bottomVC?.present(imagePickerController, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (nil) in
            self.bottomVC?.dismiss(animated: true, completion: nil)
        }))
        
        self.bottomVC?.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        self.delegate?.updateEventWithImage(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func deleteImage()  {
        self.delegate?.removeEventImage()
        imageView.image = nil
    }
}
