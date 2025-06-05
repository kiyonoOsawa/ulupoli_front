// MissionViewModel.swift (PlayerModelに合わせて修正)
import Foundation
import CoreNFC
import Combine

class MissionViewModel: NSObject, ObservableObject, NFCTagReaderSessionDelegate {
    
    @Published var recordedPlayers: [PlayerModel] = []
    @Published var isMissionComplete: Bool = false
    @Published var feedbackMessage: String = "NFCスキャンボタンを押してください"
    //ここどうする？？何人にするかこちらで弄れるようにする？
    let missionPlayerCount: Int = 5
    private var session: NFCTagReaderSession?
    
    func startNFCScanning() {
        guard NFCTagReaderSession.readingAvailable else {
            self.feedbackMessage = "このデバイスはNFCに対応していません。"
            return
        }
        session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self)
        session?.alertMessage = "プレイヤーのNFCタグにiPhoneをかざしてください。"
        session?.begin()
        self.feedbackMessage = "スキャン待機中..."
    }
        
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if let nfcError = error as? NFCReaderError, nfcError.code == .readerSessionInvalidationErrorUserCanceled {
            DispatchQueue.main.async { self.feedbackMessage = "スキャンがキャンセルされました。" }
            return
        }
        DispatchQueue.main.async { self.feedbackMessage = "エラー: \(error.localizedDescription)" }
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let firstTag = tags.first else { return }
        
        session.connect(to: firstTag) { [weak self] (error: Error?) in
            guard let self = self else { return }
            if error != nil {
                session.invalidate(errorMessage: "タグへの接続に失敗しました。")
                return
            }
            
            let uidData: Data
            switch firstTag {
            case .feliCa(let tag): uidData = tag.currentIDm
            case .miFare(let tag): uidData = tag.identifier
            default:
                session.invalidate(errorMessage: "対応していない種類のタグです。")
                return
            }
            
            // UID(Data)を16進数文字列に変換
            let uidString = uidData.map { String(format: "%02X", $0) }.joined()
            
            // 16進数文字列のUIDをIntに変換してcard_idとする
            guard let cardId = Int(uidString, radix: 16) else {
                // 変換に失敗した場合 (UIDが大きすぎるなど)
                DispatchQueue.main.async {
                    self.feedbackMessage = "UIDをカードIDに変換できませんでした。"
                }
                session.restartPolling()
                return
            }
            
            // 新しいPlayerModelを生成する（必須項目はダミーデータで埋める）
            let newPlayer = PlayerModel(
                id: nil, // サーバーDBのIDは不明なのでnil
                name: "Player (CardID: ...\(String(cardId).suffix(4)))", // 仮の名前
                roll: 0, // 仮のデータ
                status: 1, // 仮のデータ
                room_id: nil,
                card_id: cardId, // ★NFCから読み取ったIDを設定
                deleted_at: nil,
                created_at: Date(),
                updated_at: Date()
            )
            
            DispatchQueue.main.async {
                // Equatableに準拠させたので、containsで重複チェックが可能
                if !self.recordedPlayers.contains(newPlayer) {
                    self.recordedPlayers.append(newPlayer)
                    self.feedbackMessage = "\(newPlayer.name) を記録しました！"
                    self.checkMissionCompletion()
                } else {
                    self.feedbackMessage = "\(newPlayer.name) は既に記録済みです。"
                }
                
                if !self.isMissionComplete {
                    session.alertMessage = "次のタグをスキャンしてください。"
                    session.restartPolling()
                } else {
                    session.alertMessage = "ミッションを達成しました！"
                    session.invalidate()
                }
            }
        }
    }
    
    private func checkMissionCompletion() {
        if recordedPlayers.count >= missionPlayerCount {
            isMissionComplete = true
            feedbackMessage = "ミッション完了！おめでとうございます！"
        }
    }
}
