import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let bioTextView = UITextView()
    private let saveButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileImageView()
        setupUsernameLabel()
        setupBioTextView()
        setupSaveButton()
        setupResetButton()
        setupStackView()
        loadProfileData()
    }
}

// MARK: - setup profile image view

private extension ViewController {
    
    func setupProfileImageView() {
        profileImageView.image = UIImage(systemName: "person.crop.circle")
        profileImageView.layer.cornerRadius = 75
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - setup username label

private extension ViewController {
    
    func setupUsernameLabel() {
        usernameLabel.text = "Your name"
        usernameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        usernameLabel.textAlignment = .center
        usernameLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeName))
        usernameLabel.addGestureRecognizer(tapGesture)
    }
}

// MARK: - setup bio text view

private extension ViewController {
    
    func setupBioTextView() {
        bioTextView.text = "Tell about yourself..."
        bioTextView.font = .systemFont(ofSize: 18)
        bioTextView.textColor = .darkGray
        bioTextView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        bioTextView.delegate = self
        bioTextView.isScrollEnabled = false
        bioTextView.layer.cornerRadius = 8
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.lightGray.cgColor
        bioTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
    }
}

// MARK: - setup buttonы

private extension ViewController {
    
    func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 6
        saveButton.addTarget(self, action: #selector(saveProfileData), for: .touchUpInside)
    }
    
    func setupResetButton() {
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = .systemRed
        resetButton.tintColor = .white
        resetButton.layer.cornerRadius = 6
        resetButton.addTarget(self, action: #selector(resetProfile), for: .touchUpInside)
    }
}

// MARK: - setup stack view

private extension ViewController {
    
    func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            profileImageView,
            usernameLabel,
            bioTextView,
            saveButton,
            resetButton
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.setCustomSpacing(24, after: bioTextView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            
            bioTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            bioTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            saveButton.widthAnchor.constraint(equalToConstant: 80),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            
            resetButton.widthAnchor.constraint(equalToConstant: 80),
            resetButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

// MARK: - @objc functions

private extension ViewController {
    
    @objc func changeProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func changeName() {
        let alertController = UIAlertController(title: "Change name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter new name"
            textField.text = self.usernameLabel.text
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let newName = alertController.textFields?.first?.text, !newName.isEmpty {
                self.usernameLabel.text = newName
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func saveProfileData() {
        UserDefaults.standard.set(usernameLabel.text, forKey: "username")
        UserDefaults.standard.set(bioTextView.text, forKey: "bio")
        
        let alert = UIAlertController(title: "Saved", message: "Your profile was saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func resetProfile() {
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "This will delete all your profile data.",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "username")
            defaults.removeObject(forKey: "bio")
            
            self.profileImageView.image = UIImage(systemName: "person.crop.circle")
            self.usernameLabel.text = "Your name"
            self.bioTextView.text = "Tell about yourself..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - load profile data

private extension ViewController {
    
    func loadProfileData() {
        if let username = UserDefaults.standard.string(forKey: "username") {
            usernameLabel.text = username
        }
        
        if let bio = UserDefaults.standard.string(forKey: "bio") {
            bioTextView.text = bio
        }
    }
}

// MARK: - image picker controller

extension ViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - preview

#Preview(traits: .portrait) {
    ViewController()
}
