//
//  UIImageView+AsyncImage.swift
//  ANF Code Test
//
//  Created by Sindhu, K on 14/11/25.
//

import UIKit

private var aspectRatioKey: UInt8 = 0
private var activityIndicatorKey: UInt8 = 1

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    private var aspectRatioConstraint: NSLayoutConstraint? {
        get { objc_getAssociatedObject(self, &aspectRatioKey) as? NSLayoutConstraint }
        set { objc_setAssociatedObject(self, &aspectRatioKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var activityIndicator: UIActivityIndicatorView {
        get {
            if let existing = objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView {
                return existing
            }
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.hidesWhenStopped = true
            indicator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(indicator)

            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])

            objc_setAssociatedObject(self, &activityIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return indicator
        }
    }

    func setImage(from source: String, tableView: UITableView? = nil) {
        self.image = nil

        if let old = aspectRatioConstraint {
            removeConstraint(old)
            aspectRatioConstraint = nil
        }

        activityIndicator.startAnimating()

        if let localImage = UIImage(named: source) {

            imageCache.setObject(localImage, forKey: NSString(string: source))

            applyImage(localImage, tableView: tableView)
            return
        }

        guard let url = URL(string: source) else {
            activityIndicator.stopAnimating()
            return
        }

        let cacheKey = NSString(string: source)

        if let cached = imageCache.object(forKey: cacheKey) {
            applyImage(cached, tableView: tableView)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self, weak tableView] data, _, _ in
            guard let self = self else { return }

            guard let data = data,
                  let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
                return
            }

            imageCache.setObject(downloadedImage, forKey: cacheKey)

            DispatchQueue.main.async {
                self.applyImage(downloadedImage, tableView: tableView)
            }
        }.resume()
    }

    private func applyImage(_ image: UIImage, tableView: UITableView?) {
        activityIndicator.stopAnimating()

        self.image = image

        let aspect = image.size.height / image.size.width
        let c = heightAnchor.constraint(equalTo: widthAnchor, multiplier: aspect)
        c.isActive = true
        aspectRatioConstraint = c

        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
}
