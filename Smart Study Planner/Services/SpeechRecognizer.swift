import Foundation
import Speech
import SwiftUI

class SpeechRecognizer: ObservableObject {
    @Published var isRecording = false
    @Published var transcribedText = ""
    @Published var errorMessage: String?
    
    private var audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self?.errorMessage = nil
                case .denied:
                    self?.errorMessage = "Speech recognition permission denied"
                case .restricted:
                    self?.errorMessage = "Speech recognition restricted on this device"
                case .notDetermined:
                    self?.errorMessage = "Speech recognition not yet authorized"
                @unknown default:
                    self?.errorMessage = "Unknown authorization status"
                }
            }
        }
    }
    
    func startRecording() {
        // Reset state
        transcribedText = ""
        errorMessage = nil
        
        // Check if speech recognition is available
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            errorMessage = "Speech recognition is not available at this time"
            return
        }
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Failed to configure audio session: \(error.localizedDescription)"
            return
        }
        
        // Create and configure the speech recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            errorMessage = "Unable to create speech recognition request"
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        // Start recognition
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = "Recognition error: \(error.localizedDescription)"
                self.stopRecording()
                return
            }
            
            if let result = result {
                self.transcribedText = result.bestTranscription.formattedString
            }
            
            if result?.isFinal == true {
                self.stopRecording()
            }
        }
        
        // Configure audio engine
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            errorMessage = "Failed to start audio engine: \(error.localizedDescription)"
            return
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
    }
} 