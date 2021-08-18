//
//  ViewController.swift
//  Messenger
//
//  Created by Pavel Akulenak on 12.08.21.
//

import UIKit

class LoginViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()

    override func loadView() {
        let view = UIView()
        self.view = view
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupUI()
        setupTextFields()
        scrollView.keyboardDismissMode = .onDrag
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
        loginButton.addTarget(self, action: #selector(onLoginButton), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        imageView.frame = CGRect(x: (view.frame.size.width - 150) / 2,
                                 y: 30,
                                 width: 150,
                                 height: 150)
        emailTextField.frame = CGRect(x: 20 + view.safeAreaInsets.right,
                                      y: imageView.frame.maxY + 50,
                                      width: scrollView.frame.width - 40 - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                      height: 40)
        passwordTextField.frame = CGRect(x: 20 + view.safeAreaInsets.right,
                                         y: emailTextField.frame.maxY + 30,
                                         width: scrollView.frame.width - 40 - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                         height: 40)
        loginButton.frame = CGRect(x: 100 + view.safeAreaInsets.right,
                                         y: passwordTextField.frame.maxY + 30,
                                         width: scrollView.frame.width - 200 - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                         height: 40)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: loginButton.frame.maxY)
    }

    @objc private func onRegisterButton() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func onLoginButton() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {
            showAlertWithOneButton(title: "Woops!",
                                   message: "Please enter all information to log in.",
                                   actionTitle: "Ok",
                                   actionStyle: .default,
                                   handler: nil)
            return
        }
        AuthenticationManager.shared.logIn(email: email, password: password) { [weak self] error in
            guard let self = self else {
                return
            }
            if let error = error {
                self.showAlertWithOneButton(title: "Error",
                                            message: "\(error.localizedDescription)",
                                            actionTitle: "Ok",
                                            actionStyle: .default,
                                            handler: nil)
            } else {
                let vc = ConversationsViewController()
                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        imageView.image = UIImage(named: "messenger")
        imageView.contentMode = .scaleAspectFill
        imageView.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        emailTextField.backgroundColor = .white
        emailTextField.textColor = .black
        emailTextField.layer.cornerRadius = 10
        emailTextField.addBorder(width: 1, borderColor: .label)
        emailTextField.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        passwordTextField.backgroundColor = .white
        passwordTextField.textColor = .black
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.addBorder(width: 1, borderColor: .label)
        passwordTextField.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        loginButton.backgroundColor = .link
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        loginButton.layer.cornerRadius = 10
        loginButton.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        loginButton.addBorder(width: 1, borderColor: .label)
    }

    private func setupTextFields() {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.textAlignment = .center
        emailTextField.placeholder = "Email adress"
        emailTextField.returnKeyType = .next
        emailTextField.returnKeyType = .continue
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "Password"
        passwordTextField.returnKeyType = .join
    }

    private func configureNavBar() {
        title = "Log In"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register ",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(onRegisterButton))
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            onLoginButton()
        }
        return true
    }
}
