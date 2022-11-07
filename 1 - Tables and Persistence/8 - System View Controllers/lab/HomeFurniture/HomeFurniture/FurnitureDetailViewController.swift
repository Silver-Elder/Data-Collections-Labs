
import UIKit

class FurnitureDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var furniture: Furniture?
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var furnitureTitleLabel: UILabel!
    @IBOutlet var furnitureDescriptionLabel: UILabel!
    
    init?(coder: NSCoder, furniture: Furniture?) {
        self.furniture = furniture
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            photoImageView.image = nil
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancel)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
            alert.addAction(photoLibrary)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
            
            alert.addAction(camera)
        }
        
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //see p.193
        guard let image = info[.originalImage] as? UIImage else { return } // (see p.194)
        
        furniture?.imageData = image.jpegData(compressionQuality: 0.9)
        
        photoImageView.image = image
        dismiss(animated: true, completion: nil)
        
        
    }
    
    /*
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
     // ^^^ This code
    */

    @IBAction func actionButtonTapped(_ sender: UIButton) { // (see p.180)
        guard furniture != nil else { return }
        
        var activityItems: [Any] = []
        
        if let photo = photoImageView.image {
            activityItems.append(photo)
        }
        
        if let title = furnitureTitleLabel.text {
            activityItems.append(title)
        }
        
        if let description = furnitureDescriptionLabel.text {
            activityItems.append(description)
        }
        
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    
}

// Pick up on p.198 — b4
