//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {
    public var exploreData: [ANFExploreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadExploreData()
    }
    
    private func loadExploreData() {
        guard let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
              let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            print("❌ exploreData.json not found or unreadable.")
            return
        }

        do {
            let decodedData = try JSONDecoder().decode([ANFExploreData].self, from: fileContent)
            self.exploreData = decodedData
            self.tableView.reloadData()
        } catch {
            print("❌ JSON decoding failed: \(error)")
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exploreData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "exploreContentCell", for: indexPath)
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            titleLabel.text = exploreData[indexPath.row].title
        }
        
        if let imageView = cell.viewWithTag(2) as? UIImageView,
           let image = UIImage(named: exploreData[indexPath.row].backgroundImage) {
            imageView.image = image
        }
        
        if let topDescription = cell.viewWithTag(3) as? UILabel {
            topDescription.text = exploreData[indexPath.row].topDescription
        }
        
        if let promoMessageLabel = cell.viewWithTag(4) as? UILabel {
            promoMessageLabel.text = exploreData[indexPath.row].promoMessage
        }
        
        if let bottomDescriptionLabel = cell.viewWithTag(5) as? UILabel,
           let bottomDescriptionText = exploreData[indexPath.row].bottomDescription {
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

            let contentArray = exploreData[indexPath.row].content ?? []

            for content in contentArray {

                let title = content.title
                let target = content.target ?? ""

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
