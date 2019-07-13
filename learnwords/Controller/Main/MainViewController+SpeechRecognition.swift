//
//  MainViewController+SpeechRecognition.swift
//  learnwords
//
//  Created by Krzysztof Kapała on 13/07/2019.
//  Copyright © 2019 kapala. All rights reserved.
//

import Speech

extension MainViewController {
    
    func authorizeSpeechRecognition() {
        self.recordBtn.stopAnimation()
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                do {
                    self.recordBtn.startAnimation()
                    try self.startRecording()
                } catch let error {
                    self.recordBtn.stopAnimation()
                    print("There was a problem starting recording: \(error.localizedDescription)")
                }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            }
        }
    }
    
    func startRecording() throws {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024,
                        format: recordingFormat) { [unowned self]
                            (buffer, _) in
                            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            [unowned self]
            (result, _) in
            if let transcription = result?.bestTranscription {
                print(transcription.formattedString)
                self.textField.text = transcription.formattedString
                self.stopRecording()
                self.isWordCorrect(typedWord: self.textField.text)
                
            }
        }
    }
    
    func stopRecording() {
        self.recordBtn.stopAnimation()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        request.endAudio()
        request = SFSpeechAudioBufferRecognitionRequest()
        recognitionTask?.cancel()
    }
}
