import UIKit

class ViewController: UIViewController {
    
    let loginTextField = UITextField()
    let passwordTextField = UITextField()
    
    let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedViews()
        setupLayout()
        configureTextFields()
        configureLoginButton()
    }
    
    func embedViews() {
        [loginTextField, passwordTextField, loginButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        
        [loginTextField, passwordTextField, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            loginTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureTextFields() {
        loginTextField.placeholder = "Enter your login"
        loginTextField.textColor = .black
        loginTextField.font = UIFont.systemFont(ofSize: 20)
        loginTextField.keyboardType = .default
        loginTextField.returnKeyType = .continue
        loginTextField.clearButtonMode = .whileEditing
        loginTextField.textAlignment = .center
        loginTextField.delegate = self
        
        passwordTextField.placeholder = "Enter your password"
        passwordTextField.textColor = .black
        passwordTextField.font = UIFont.systemFont(ofSize: 20)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.keyboardType = .default
        passwordTextField.returnKeyType = .done
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.textAlignment = .center
        passwordTextField.delegate = self
    }
    
    func configureLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 8
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped() {
        guard
            let login = loginTextField.text,
            login.isEmpty == false
        else {
            showAlert(message: "Login is empty!")
            return
        }
        
        guard
            let password = passwordTextField.text,
            validatePassword(password)
        else {
            showAlert(message: "Password must be at least 8 characters and include letters and numbers!")
            return
        }
        
        showAlert(message: "Login successful!")
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Notification",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func validatePassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[А-Яа-я])(?=.*\\d)[А-Яа-я\\d]{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.resignFirstResponder()
        } else if textField == passwordTextField {
            loginTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            
            loginButtonTapped()
        }
        
        return true
    }
}

#Preview(traits: .portrait) {
    ViewController()
}
