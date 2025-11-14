//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {

    private var exploreData: [[AnyHashable: Any]]? {
        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
         let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
         let jsonDictionary = try? JSONSerialization.jsonObject(with: fileContent, options: .mutableContainers) as? [[AnyHashable: Any]] {
            return jsonDictionary
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "exploreContentCell", for: indexPath)
        if let titleLabel = cell.viewWithTag(1) as? UILabel,
           let titleText = exploreData?[indexPath.row]["title"] as? String {
            titleLabel.text = titleText
        }
        
        if let imageView = cell.viewWithTag(2) as? UIImageView,
           let name = exploreData?[indexPath.row]["backgroundImage"] as? String,
           let image = UIImage(named: name) {
            imageView.image = image
        }
        
        if let topDescription = cell.viewWithTag(3) as? UILabel,
           let topDescriptionText = exploreData?[indexPath.row]["topDescription"] as? String {
            topDescription.text = topDescriptionText
        }
        
        if let promoMessageLabel = cell.viewWithTag(4) as? UILabel,
           let promoMessageText = exploreData?[indexPath.row]["promoMessage"] as? String {
            promoMessageLabel.text = promoMessageText
        }
        
        if let bottomDescriptionLabel = cell.viewWithTag(5) as? UILabel,
           let bottomDescriptionText = exploreData?[indexPath.row]["bottomDescription"] as? String {
            if let bottomDescriptionAttributedString = bottomDescriptionText.htmlToAttributedString {
                bottomDescriptionLabel.attributedText = bottomDescriptionAttributedString
                bottomDescriptionLabel.textAlignment = .center
                bottomDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
            } else {
                bottomDescriptionLabel.text = bottomDescriptionText
            }
        }
        
        if let buttonContainer = cell.viewWithTag(6) as? UIStackView {
            buttonContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }

            let contentArray = exploreData?[indexPath.row]["content"] as? [[String: Any]] ?? []

            for content in contentArray {

                let title = content["title"] as? String ?? ""
                let target = content["target"] as? String ?? ""

                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.lightGray.cgColor

                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: 48).isActive = true

                button.restorationIdentifier = target

                button.addTarget(self,
                                 action: #selector(buttonTapped(_:)),
                                 for: .touchUpInside)

                buttonContainer.addArrangedSubview(button)

                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor)
                ])
            }

            buttonContainer.isHidden = contentArray.isEmpty
        }

        return cell
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if let target = sender.restorationIdentifier  {
            guard let url = URL(string: target) else { return }
            UIApplication.shared.open(url)
        }
    }
}
