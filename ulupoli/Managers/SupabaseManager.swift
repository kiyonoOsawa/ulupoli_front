import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        let url = URL(string: "https://zikalqhtlagzzsbwxbmg.supabase.co")!
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inppa2FscWh0bGFnenpzYnd4Ym1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc2Mjg0MDIsImV4cCI6MjA2MzIwNDQwMn0.hg_9ge43ZoDsNWYcmI7j_dlVDe39mf8tpWiVCXPi0Hc"
        client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
}
