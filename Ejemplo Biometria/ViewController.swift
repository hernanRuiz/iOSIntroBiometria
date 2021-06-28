//
//  ViewController.swift
//  Ejemplo Biometria
//
//  Created by Hernan Ruiz on 24/06/2021.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    private let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Seteamos un botón en la vista y lo vinculamos a una función que realiza
        autenticación por biometría */
        view.addSubview(button)
        view.backgroundColor = .white
        button.center = view.center
        // Seteamos el texto del botón según el tipo de biometría presente en el dispositivo
        var buttonBiometricTypeText = " con TouchID"
        if BiometricHelper.localAuthIsAvailable(), BiometricHelper.hasFaceID {
            buttonBiometricTypeText = " con FaceID"
        }
        button.setTitle("Ingresar" + buttonBiometricTypeText, for: .normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    @objc func onClick(){
        let context = LAContext()
        var error: NSError? = nil
        var reason: String = ""
        var fallbackText: String = ""
        
        // Definimos textos para los botones de fallback y de cancelar autenticación
        if BiometricHelper.localAuthIsAvailable() {
            reason = BiometricHelper.hasFaceID ? "Rostro no reconocido" : "Ingresando con TouchID"
            fallbackText = BiometricHelper.hasFaceID ? "Fallback FaceID" : "Fallback TouchID"
            context.localizedFallbackTitle = fallbackText
        }
        context.localizedCancelTitle = "Cancelar"
    
        // Ejecutamos autenticación por biometría
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason){ [weak self] success, error in
                
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        // Error en la autenticación
                        if let authError = error as? LAError {
                            // No mostramos el error si el usuario es el que cancela la autenticación
                            if authError.code != .userCancel {
                                self?.showAlert(title: "Falló la autenticación", message: "Volvé a intentar más tarde")
                            }
                        }
                        return
                    }
                    
                    // Success - Autenticación correcta --> avanzamos a la siguiente vista
                    let vc = UIViewController()
                    vc.view.backgroundColor = .systemBlue
                    vc.title = "Bienvenido!"
                    self?.present(UINavigationController(rootViewController: vc),
                                  animated: true,
                                  completion: nil)
                }
            }
        } else {
            // No se puede usar la funcionalidad. Biometría no enrolada en el dispositivo
            showAlert(title: "Biometría no disponible",
            message: "No se puede utilizar la funcionalidad en este momento")
        }
    }

    // Alert para mensajes de error
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
