//
//  BiometricHelper.swift
//  Ejemplo Biometria
//
//  Created by Hernan Ruiz on 24/06/2021.
//

import Foundation
import LocalAuthentication

class BiometricHelper {

    public static var hasTouchID: Bool = false
    public static var hasFaceID: Bool = false

    //Chequeamos si el dispositivo tiene o no biometría
    static func localAuthIsAvailable() -> Bool  {
        let laContext = LAContext()
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            hasTouchID = true
            if #available(iOS 11.0, *) {
                hasTouchID = laContext.biometryType == .touchID
                hasFaceID = laContext.biometryType == .faceID
                return hasTouchID || hasFaceID
            } else {
                return hasTouchID
            }
        }
        return false
    }
}
