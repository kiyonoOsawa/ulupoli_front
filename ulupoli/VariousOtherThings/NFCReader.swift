import Foundation
import CoreNFC

// NFCリーダークラス。NFCタグのUID取得を目的とする。
class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate, NFCTagReaderSessionDelegate {
    // セッションがアクティブになったときに呼ばれる（NFCTagReaderSessionDelegateの必須メソッド）。
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // ここでは特に何も処理していません。
    }
    
    // NFCNDEFReaderSessionがエラーで無効化されたときに呼ばれる（NFCNDEFReaderSessionDelegateの必須メソッド）。
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        // ここでは特に何も処理していません。
    }
    
    // NFCNDEFReaderSessionでNDEFメッセージが検出されたときに呼ばれる（NFCNDEFReaderSessionDelegateの必須メソッド）。
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // ここでは特に何も処理していません。
    }
    
    // タグのUIDを格納するPublishedプロパティ。UIとバインドされる。
    @Published var tagUID: String = "UIDを取得するにはタグをスキャンしてください"
    @Published var lastUID: String? = nil
    
    // NFCタグリーダーセッションのインスタンスを保持するためのプロパティ。
    private var session: NFCTagReaderSession?
    
    // NFCスキャンを開始するメソッド。
    func beginScanning() {
        // デバイスがNFC読み取りに対応しているか確認。
        guard NFCTagReaderSession.readingAvailable else {
            tagUID = "このデバイスではNFCが使えません"
            return
        }
        
        // ISO14443（主に交通系ICカード等）に対応したNFCタグのスキャンを開始。
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "NFCタグにiPhoneをかざしてください"
        session?.begin()
    }
    
    // MARK: - NFCTagReaderSessionDelegate
    
    // セッションがエラーで無効化されたときに呼ばれる。
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // エラー内容をNSErrorに変換
        let nsError = error as NSError
        // ユーザーキャンセルの場合は何もしない
        if nsError.domain == NFCErrorDomain && nsError.code == 201 { // 201: session invalidated by user
            // 何もせずreturn
            return
        }
        // それ以外のエラー時のみエラーメッセージを表示
        DispatchQueue.main.async { [weak self] in
            self?.tagUID = "エラー: \(error.localizedDescription)"
        }
    }
    
    // タグが検出されたときに呼ばれる。
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let firstTag = tags.first else { return }
        session.connect(to: firstTag) { [weak self] error in
            if let error = error {
                session.invalidate(errorMessage: "接続に失敗しました: \(error.localizedDescription)")
                return
            }
            if case let .miFare(miFareTag) = firstTag {
                let uidData = miFareTag.identifier
                let uidString = uidData.map { String(format: "%02X", $0) }.joined()
                DispatchQueue.main.async {
                    self?.tagUID = "UID: \(uidString)"
                    // 追加: UIDを保持
                    self?.lastUID = uidString
                }
                session.alertMessage = "UIDを取得しました"
                session.invalidate()
            } else {
                session.invalidate(errorMessage: "対応していないタグです")
            }
        }
    }
}
