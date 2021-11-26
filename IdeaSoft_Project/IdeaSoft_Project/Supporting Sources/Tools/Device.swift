//
//  Device.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 26.11.2021.
//

import UIKit

typealias Device = UIDevice

extension Device {
    var type: DeviceType { .init() }
    
    var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
    
    var isIphone6OrSmaller: Bool {
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return width <= 375
    }

    var isPhoneSEorSamller: Bool {
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return width == 320
    }

    var isPhone6: Bool {
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return width == 375
    }
    
    var isIPhonePlus: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1920: return true
            default: break
            }
        }

        return false
    }

    var isIphoneXr: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1792: return true
            default: return false
            }
        } else {
            return false
        }
    }

    var isPhoneX: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                break; // ("iPhone 5 or 5S or 5C")
            case 1334:
                break; // ("iPhone 6/6S/7/8")
            case 2208:
                break; // ("iPhone 6+/6S+/7+/8+")
            case 1792, 2436, 2688:
                return true
            default:
                break; // ("unknown")
            }
        }

        return false
    }
    
    var isIphone12: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            return UIScreen.main.nativeBounds.height == 2532
        }
        return false
    }
    
    var isIphone12ProMax: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            return UIScreen.main.nativeBounds.height == 2778
        }
        return false
    }
    
    var isIphone12Mini: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            return UIScreen.main.nativeBounds.height == 2436 && UIScreen.main.nativeBounds.width == 1125
        }
        return false
    }
    
    var hasNotch: Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        return bottomPadding > 0
    }
}

extension UIApplication {
    static var window: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window
    }
}

extension Device {
    enum DeviceType {
        case iPhone6, iPhoneSE, iPhoneX, iPhoneXr, iPhonePlus, iPhone12, iPhone12ProMax, iPhone12Mini, unsupported

        init() {
            if Device.current.isIphoneXr { self = .iPhoneXr }
            else if Device.current.isPhoneX { self = .iPhoneX }
            else if Device.current.isIPhonePlus { self = .iPhonePlus }
            else if Device.current.isPhone6 { self = .iPhone6 }
            else if Device.current.isPhoneSEorSamller { self = .iPhoneSE }
            else if Device.current.isIphone12 { self = .iPhone12 }
            else if Device.current.isIphone12ProMax { self = .iPhone12ProMax }
            else if Device.current.isIphone12Mini { self = .iPhone12Mini }
            else { self = .unsupported }
        }
        
        var nativeScale: CGFloat {
            switch self {
            case .iPhone6, .iPhoneSE, .iPhoneXr: return 2.0
            case .iPhoneX, .iPhone12, .iPhone12ProMax, .iPhone12Mini: return 3.0
            case .iPhonePlus: return 2.608
            case .unsupported: return .zero
            }
        }
    }
}

