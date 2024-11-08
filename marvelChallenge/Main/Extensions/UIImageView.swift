
import UIKit

extension UIImageView {
    func downloadThumbnail(thumbnail: Thumbnail?) {
        if let path = thumbnail?.path?.replacingOccurrences(of: "http:", with: "https:"),
           let imageExtension = thumbnail?.imageExtension,
           let url = URL(string: path+"."+imageExtension) {
            
            Task {
                do {
                    let data = try await downloadImageData(from: url)
                    self.image = UIImage(data: data)
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
