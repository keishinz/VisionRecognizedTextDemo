//
//  TranslateViewController.swift
//  VisionRecognizedTextDemo
//
//  Created by Keishin CHOU on 2019/12/26.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import AVFoundation
import Amplify


class TranslateViewController: UIViewController {
    
    var translation: String?
    let translateLabel = UILabel()
    
    var audioData: Data?
    var player: AVAudioPlayer?

//    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        
//        translateLabel.sizeToFit();
        self.view.addSubview(translateLabel)
        translateLabel.translatesAutoresizingMaskIntoConstraints = false
        translateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        translateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        translateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
        translateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        
        print(translation!)
        translateLabel.text = translation
        translateLabel.textColor = .darkText
        translateLabel.numberOfLines = 0
        translateLabel.lineBreakMode = .byWordWrapping
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(viewDismiss))
        let siriButton = UIBarButtonItem(image: UIImage(systemName: "mic"), style: .plain, target: self, action: #selector(readText))
        let pollyButton = UIBarButtonItem(image: UIImage(systemName: "mic.fill"), style: .plain, target: self, action: #selector(readTextPolly))
        navigationItem.rightBarButtonItems = [siriButton, pollyButton]
    }
    
//    @objc func viewDismiss() {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @objc func readText() {
        let utterance = AVSpeechUtterance(string: translation!)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @objc func readTextPolly() {
        let options = PredictionsTextToSpeechRequest.Options(voiceType: .japaneseFemaleMizuki, pluginOptions: nil)

        _ = Amplify.Predictions.convert(textToSpeech: self.translation!, options: options, listener: { (event) in

            switch event {
            case .completed(let result):
                print(result.audioData)
                self.audioData = result.audioData
                self.player = try? AVAudioPlayer(data: result.audioData)
                self.player?.play()
            default:
                print("")

            }
        })

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
