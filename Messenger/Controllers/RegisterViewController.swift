//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Pavel Akulenak on 12.08.21.
//

import UIKit

class RegisterViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let firstNameTextField = UITextField()
    private let lastNameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let registerButton = UIButton()

    override func loadView() {
        let view = UIView()
        self.view = view
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(registerButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
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
        registerButton.addTarget(self, action: #selector(onRegisterButton), for: .touchUpInside)
        imageView.isUserInteractionEnabled = true
        let tapOnImageView = UITapGestureRecognizer(target: self, action: #selector(onImageViewGesture))
        imageView.addGestureRecognizer(tapOnImageView)
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
        firstNameTextField.frame = CGRect(x: 20 + view.safeAreaInsets.right,
                                      y: imageView.frame.maxY + 50,
                                      width: scrollView.frame.width - 40 - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                      height: 40)
        lastNameTextField.frame = CGRect(x: 20 + view.safeAreaInsets.right,
                                      y: firstNameTextField.frame.maxY + 30,
                                      width: scrollView.frame.width - 40 - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                      height: 40)
        emailTextField.frame = CGRect(x: 20 + view.safeAreaInsets.right,
                                      y: lastNameTextField.frame.maxY + 30,
                                      width: scrollView.frame.width - 40 - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                      height: 40)
        passwordTextField.frame = CGRect(x: 20 + view.safeAreaInsets.right,
                                         y: emailTextField.frame.maxY + 30,
                                         width: scrollView.frame.width - 40 - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                         height: 40)
        registerButton.frame = CGRect(x: 100 + view.safeAreaInsets.right,
                                         y: passwordTextField.frame.maxY + 30,
                                         width: scrollView.frame.width - 200 - view.safeAreaInsets.left - view.safeAreaInsets.right,
                                         height: 40)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: registerButton.frame.maxY)
    }

    @objc private func onRegisterButton() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            showAlertWithOneButton(title: "Woops!",
                                   message: "Please enter all information to create a new account.",
                                   actionTitle: "Ok",
                                   actionStyle: .default,
                                   handler: nil)
            return
        }
        if password.count < 6 {
            showAlertWithOneButton(title: "The password is too short!",
                                   message: "Password must be more than 6 characters.",
                                   actionTitle: "Ok",
                                   actionStyle: .default,
                                   handler: nil)
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

    @objc private func onImageViewGesture() {
        print("tap")
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        firstNameTextField.backgroundColor = .white
        firstNameTextField.textColor = .black
        firstNameTextField.layer.cornerRadius = 10
        firstNameTextField.addBorder(width: 1, borderColor: .label)
        firstNameTextField.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        lastNameTextField.backgroundColor = .white
        lastNameTextField.textColor = .black
        lastNameTextField.layer.cornerRadius = 10
        lastNameTextField.addBorder(width: 1, borderColor: .label)
        lastNameTextField.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
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
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        registerButton.layer.cornerRadius = 10
        registerButton.addShadow(color: .label, opacity: 1, offSet: .zero, radius: 10)
        registerButton.addBorder(width: 1, borderColor: .label)
    }

    private func setupTextFields() {
        firstNameTextField.autocorrectionType = .no
        firstNameTextField.textAlignment = .center
        firstNameTextField.placeholder = "First name"
        firstNameTextField.returnKeyType = .continue
        lastNameTextField.autocorrectionType = .no
        lastNameTextField.textAlignment = .center
        lastNameTextField.placeholder = "Last name"
        lastNameTextField.returnKeyType = .continue
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
        title = "Register"
        navigationController?.navigationBar.tintColor = .label
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            onRegisterButton()
        }
        return true
    }
}

