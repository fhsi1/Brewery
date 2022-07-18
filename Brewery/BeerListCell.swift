//
//  BeerListCell.swift
//  Brewery
//
//  Created by Yujean Cho on 2022/04/21.
//

import UIKit
import SnapKit
import Kingfisher

class BeerListCell: UITableViewCell {
    // imageView
    let beerimageView = UIImageView()
    
    // nameLabel
    let nameLabel = UILabel()
    
    // hashtagLabel
    let taglineLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [beerimageView, nameLabel, taglineLabel].forEach {
            contentView.addSubview($0)
        }
        
        // beerImageView configuration
        beerimageView.contentMode = .scaleAspectFit
        
        // nameLabel configuration
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 2
        
        // taglineLabel configuration
        taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
        taglineLabel.textColor = .systemBlue
        taglineLabel.numberOfLines = 0
        
        beerimageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(beerimageView.snp.trailing).offset(10)
            $0.bottom.equalTo(beerimageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        taglineLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    func configure(with beer: Beer) {
        let imageURL = URL(string: beer.imageURL ?? "")
        beerimageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon.png")) // placeholder - 이미지가 없는 경우 대비
        nameLabel.text = beer.name ?? "이름 없는 맥주"
        taglineLabel.text = beer.tagLine
        
        accessoryType = .disclosureIndicator // cell 의 오른쪽에 화살표같은 꺽쇠 생성
        selectionStyle = .none // cell 을 tap 하더라도 회색 음영이 생기지 않도록 설정
    }
}
