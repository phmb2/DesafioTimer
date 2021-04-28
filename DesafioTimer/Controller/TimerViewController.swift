//
//  ViewController.swift
//  DesafioTimer
//
//  Created by Pedro Barbosa on 15/04/21.
//

import UIKit
import UserNotifications
import AVFoundation

class TimerViewController: UIViewController {
    
    // MARK: - Properties
    let timerArray = [10, 20, 30, 40, 50, 60]
    var timer: Timer = Timer()
    var timerRemaining: Int = 10
    var timerSelected: Int = 10
    let center = UNUserNotificationCenter.current()
    var soundEffect: AVAudioPlayer?
    
    let timerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "analog_clock"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 300, height: 300)
        return imageView
    }()
    
    let timerPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let countdownLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 100)
        label.textColor = .black
        return label
    }()
    
    private let timerStartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Começar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.heightAnchor.constraint(equalToConstant: 42).isActive = true
        button.addTarget(self, action: #selector(handleTimerStart), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "Onboarding")
        
        timerPickerView.delegate = self
        timerPickerView.dataSource = self
        center.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLayout()
    }
    
    // MARK: - Helpers
    func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubview(timerImageView)
        timerImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 50)
        timerImageView.centerX(inView: view)
        
        view.addSubview(timerPickerView)
        timerPickerView.anchor(top: timerImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        view.addSubview(countdownLabel)
        countdownLabel.anchor(top: timerImageView.bottomAnchor, paddingTop: 80)
        countdownLabel.centerX(inView: view)
        
        view.addSubview(timerStartButton)
        timerStartButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 24, paddingBottom: 30, paddingRight: 24)
    }
    
    func startCountdown() {
        
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerPerformAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func startNotification() {
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
          if granted {
            print("Permissão autorizada para notificação local")
            
            let content = UNMutableNotificationContent()
            content.title = "Alarme"
            content.body = "Seu alarme tocou!"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.timerRemaining), repeats: false)
            let request = UNNotificationRequest(identifier: "timerNotification", content: content, trigger: trigger)
            self.center.add(request)
          } else if let error = error {
            print("Permissão negada para notificação local: \(error.localizedDescription)")
          }
        }
    }
    
    func cancelNotification() {
        center.removePendingNotificationRequests(withIdentifiers: ["timerNotification"])
    }
    
    func shakeView(view: UIView) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.7
        animation.repeatCount = 4
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.isAdditive = true

        view.layer.add(animation, forKey: "shake")
    }
    
    func ringAlarm() {
        let path = Bundle.main.path(forResource: "ring_alarm.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        } catch {
            print("Couldn't load ring_alarm.mp3")
        }
    }
    
    // MARK: - Selectors
    @objc func handleTimerStart() {
        if !timerPickerView.isHidden {
            timerPickerView.isHidden = true
            countdownLabel.isHidden = false
            timerSelected = timerRemaining
            startCountdown()
            startNotification()
            timerStartButton.setTitle("Cancelar", for: .normal)
        } else {
            timerPickerView.isHidden = false
            countdownLabel.isHidden = true
            timerStartButton.setTitle("Começar", for: .normal)
            cancelNotification()
            self.timer.invalidate()
        }
    }
    
    @objc func timerPerformAction() {
        if (timerRemaining != 0) {
            self.timerRemaining -= 1
            self.countdownLabel.text = "\(self.timerRemaining)"
        } else {
            countdownLabel.isHidden = true
            timerPickerView.isHidden = false
            timerStartButton.setTitle("Começar", for: .normal)
            self.timer.invalidate()
            shakeView(view: timerImageView)
            ringAlarm()
            timerRemaining = timerSelected
        }
    }
}

// MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension TimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return timerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       let value = "\(timerArray[row]) segundos"
       return value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timerRemaining = timerArray[row]
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension TimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
          withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Recebeu notificação local: \(notification)")
    }
}
