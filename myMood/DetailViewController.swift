import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var happinessIndex : Float = 0.0
    
    let addImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Picture", for: .normal)
        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        return button
    }()
    let deleteImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete Picture", for: .normal)
        button.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        return button
    }()
    
    
    let imageView : UIImageView = {
        let iV = UIImageView()
        iV.backgroundColor = UIColor.lightGray
        iV.translatesAutoresizingMaskIntoConstraints = false
        return iV
    }()
    
    // View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Details"
        view.addSubview(imageView)
        view.addSubview(addImageButton)
        view.addSubview(deleteImageButton)
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupImageViewConstraints()
        setupButtonConstraints()
        setupDeleteButton()
    }
    
    func setupButtonConstraints() {
        addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addImageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addImageButton.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20).isActive = true
    }
    
    func setupImageViewConstraints() {
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
    }
    
    func setupDeleteButton(){
        deleteImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteImageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deleteImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        deleteImageButton.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -80).isActive = true
        
    }
    func addImage () {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photolibrary", style: .default, handler: { (action : UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: { (nil) in
            self.present(actionSheet, animated: true, completion: nil)
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func deleteImage()  {
        imageView.image = nil
    }
}
