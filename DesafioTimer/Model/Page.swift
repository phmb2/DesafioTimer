//
//  Page.swift
//  DesafioTimer
//
//  Created by Pedro Barbosa on 20/04/21.
//

import UIKit

struct OnboardingPage {
    var image: UIImage?
    var description: String
}

enum Page: Int, CaseIterable {
    case pageOne
    case pageTwo
    case pageThree

    var index: Int {
        rawValue
    }

    var onboardingPage: OnboardingPage {
        switch self {
        case .pageOne:
            return OnboardingPage(image: UIImage(named: "onboarding_page_one"), description: "Olá! Bem vindo ao Timer App! Você pode selecionar diferentes tempos na aplicação.")
        case .pageTwo:
            return OnboardingPage(image: UIImage(named: "onboarding_page_two"), description: "O Timer App apresenta a funcionalidade de um contador regressivo para facilitar sua vida.")
        case .pageThree:
            return OnboardingPage(image: UIImage(named: "onboarding_page_three"), description: "Com a sua permissão, o Timer App notifica você quando o alarme for iniciado.")
        }
    }
}




