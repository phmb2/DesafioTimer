//
//  PageViewController.swift
//  DesafioTimer
//
//  Created by Pedro Barbosa on 20/04/21.
//

import UIKit

class PageViewController: UIViewController {
    
    // MARK: - Properties
    var page: Page

    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: page.onboardingPage.image)
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 200, height: 200)
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.contentMode = .scaleToFill
        label.numberOfLines = 0
        label.text = page.onboardingPage.description
        return label
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pular", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.addTarget(self, action: #selector(handleOnboardingSkip), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    init(with page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    // MARK: Helpers
    func configureLayout() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(imageView)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 120)
        imageView.centerX(inView: view)
        
        self.view.addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 24, paddingRight: 24)
        
        self.view.addSubview(skipButton)
        skipButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 80, paddingBottom: 30, paddingRight: 80)
    
    }
    
    // MARK: - Selectors
    @objc func handleOnboardingSkip() {
        let timerViewController = TimerViewController()
        self.navigationController?.pushViewController(timerViewController, animated: true)
    }
}
