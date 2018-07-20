//
//  Home_OneViewController.swift
//  rxSwiftNodeElm
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import ObjectMapper
import Moya
import Kingfisher


enum GetDataError:Error {
    case cannotConvertServerResponse
}

class Home_OneViewController: UIViewController,UITableViewDelegate {

    

    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var infoTableView: UITableView!
    var bag = DisposeBag()
    
    var contentList = Variable<[FirstCellModelData]>([])
    var weatherInfo = Variable<Weather>(Weather())
    var menuInfo = Variable<Menu>(Menu())

    var label_one:UILabel!
    var label_two:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoTableView.register(UINib.init(nibName: "FirstViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FirstViewCell")
        infoTableView.register(UINib.init(nibName: "SecondViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SecondViewCell")
        infoTableView.register(UINib.init(nibName: "ThirdViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ThirdViewCell")
        
        infoTableView.delegate = self

        //GetData
        _ = self.getHomeData().subscribe{  (model) in
            if let content = model.element?.contentList{
                self.contentList.value.removeAll()
                self.contentList.value.append(FirstCellModelData(headers: "", items: content))
            }
            if let weather = model.element?.weather{
                self.weatherInfo.value = weather
            }
            if let menu = model.element?.menu {
                self.menuInfo.value = menu
            }
        }
        
       //dataSource
        let dataSource = RxTableViewSectionedReloadDataSource<FirstCellModelData>(configureCell:{
                         (dataSource,tableView,indexPath,element) in
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FirstViewCell") as! FirstViewCell
                
                cell.picImageView.kf.setImage(with: URL(string: element.imgUrl!),
                                              placeholder:UIImage(named: "placeholder_image") ,
                                              options: nil,
                                              progressBlock: nil,
                                              completionHandler: nil)
                cell.ticAndPicInfo.text = element.title! + " | " + element.picInfo!
                cell.forward.text = element.forward
                cell.wordsInfo.text = element.wordsInfo
                cell.likeNum.text = "\(String(describing: element.likeCount!))"
                cell.likeBtn.tag = indexPath.row+100
                cell.likeBtn.addTarget(self, action: #selector(self.likeBtnClick(_ :)), for: .touchUpInside)
                return cell
            }
            if indexPath.row == 1 {
                let element = self.menuInfo.value
                let cell = tableView.dequeueReusableCell(withIdentifier: "SecondViewCell") as! SecondViewCell
                if let volume = element.vol {
                    cell.volumeLabel.text = "一个 VOL." + volume + " ∨"
                }
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdViewCell") as! ThirdViewCell
                cell.catrgroyLabel.text = "- " + "阅读" + " -"
                cell.titleLabel.text = element.title
                cell.authorLabel.text = element.author?.userName
                cell.picImageView.kf.setImage(with: URL(string: element.imgUrl!),
                                              placeholder: UIImage(named: "placeholder_image"),
                                              options: nil,
                                              progressBlock: nil,
                                              completionHandler: nil)
                cell.descTextField.text = element.forward
                
                if let postDate = element.postDate {
                    cell.dateLabel.text = self.getDate(dateString: postDate)
                }
                cell.likeCountLabel.text = "\(element.likeCount ?? 0)"                
                cell.likeBtn.tag = indexPath.row+100
                cell.likeBtn.addTarget(self, action: #selector(self.likeBtnClick(_:)), for: .touchUpInside)
                return cell
            }
            
        })
        
        //Bind
        contentList.asObservable()
            .bind(to: infoTableView.rx.items(dataSource: dataSource))
            .disposed(by:bag)
    
        weatherInfo.asObservable()
            .map{
                if let cityName = $0.cityName, let climate = $0.climate,let temperature = $0.temperature {
                   return cityName+" . "+climate+temperature+"℃"
                }
                return "获取中。。。"
                }
            .bind(to: self.weatherLabel.rx.text)
            .disposed(by: bag)
        
        weatherInfo.asObservable()
            .map{
                return self.transDateFormString(dateString: $0.date)
            }
            .bind(to:self.dateBtn.rx.attributedTitle(for: .normal))
            .disposed(by: bag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension Home_OneViewController {
    
    private func getHomeData() -> Observable<ListDetailModel> {
        
        return Observable.create { (observer:AnyObserver<ListDetailModel>) -> Disposable in
            
           oneAPIProvider.rx.request(OneAPI.home).subscribe{ (event) in
                
                switch event {
                case .success( let response):
                  let json  = try? response.mapJSON()
                  if let dic = (json as! NSDictionary)["data"] {
                    let model = ListDetailModel(JSON: (dic) as! [String:Any])!
                    observer.onNext(model)
                    observer.onCompleted()
                  }else{
                    observer.onError(GetDataError.cannotConvertServerResponse)
                    }
                case .error:
                    observer.onError(GetDataError.cannotConvertServerResponse)
                }
            }
        }
        
    }
}
extension Home_OneViewController{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        }
        if indexPath.row == 1 {
           return 30
        }
        return 450
    }
}
extension Home_OneViewController {
    
    //处理日期字符串 ”2018-08-02“
    private func transDateFormString(dateString:String?) -> NSMutableAttributedString  {
        if let date = dateString{
            //Year
            let yearStr = date.subString(start: 0, length: 4)
            //Month
            let monthStr = date.subString(start: 5, length: 2)
            //day
            let dayStr = date.subString(start: 8, length: 2)
            
            let combinStr = dayStr+" "+monthStr.description()+yearStr
            
            let combinAttributedStr = NSMutableAttributedString.init(string: combinStr)
            
            combinAttributedStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 28),NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.strokeWidth:-1.5,NSAttributedStringKey.strokeColor:UIColor.black], range: NSRange.init(location: 0, length: 2))
            
            combinAttributedStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10),NSAttributedStringKey.foregroundColor:UIColor.black], range: NSRange.init(location: 3, length: combinStr.count-3))
            
            return combinAttributedStr
            
        }else{
            let str = NSMutableAttributedString.init(string: "获取中...")
            str.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.black], range: NSRange.init(location: 0, length: 6))
            return str
        }
    }
    
    private func getDate(dateString:String) -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let nowDateString = formatter.string(from: date)
        
        ///
        let  formatterOld = DateFormatter()
        formatterOld.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let returnFormatter = DateFormatter()
        returnFormatter.dateFormat = "MM月dd日"
        if dateString.components(separatedBy: nowDateString).count > 1 {
            return "今天"
        }else{
           let date = formatterOld.date(from: dateString)
            return returnFormatter.string(from: date!)
        }
   }

    @objc func likeBtnClick(_ sender:UIButton) {
//        let index = sender.tag - 100
//        let cell = infoTableView.cellForRow(at: IndexPath.init(row: index, section: 0))
//        let model = contentList.value.first
        self.likeAnimation(sender)

    }
   
}
extension Home_OneViewController {
    //点赞动画效果
    func likeAnimation(_ button:UIButton) {
        let index = button.tag - 100
        let cell = infoTableView.cellForRow(at: IndexPath.init(row: index, section: 0))
        let model = contentList.value.first
        
        if index == 0 {
            (cell as! FirstViewCell).likeBtn.isSelected = !(cell as! FirstViewCell).likeBtn.isSelected
            
            if (cell as! FirstViewCell).likeBtn.isSelected {
                (cell as! FirstViewCell).likeBtn.setImage(UIImage.init(named: "喜欢_selected"), for: .normal)
                
                UIView.animate(withDuration: 0.0, animations: {
                    (cell as! FirstViewCell).likeNum.alpha = 0.0
                    (cell as! FirstViewCell).likeNum.text = "\( (model?.items[index].likeCount)!+1)"
                    
                    self.label_one = UILabel()
                    self.label_one.font = (cell as! FirstViewCell).likeNum.font
                    self.label_one.textColor = (cell as! FirstViewCell).likeNum.textColor
                    (cell as! FirstViewCell).contentView.addSubview(self.label_one)
                    self.label_one.frame = (cell as! FirstViewCell).likeNum.frame
                    self.label_one.text = "\((model?.items[index].likeCount!)!+0)"
                }, completion: nil)
                
                UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut], animations: {
                    self.label_one.center.y -= 5
                }) { (finish) in
                    self.label_one.removeFromSuperview()
                }
                
                UIView.animate(withDuration: 0.0, delay: 0.4, options: [.curveEaseIn], animations: {
                    self.label_two = UILabel()
                    self.label_two.font = (cell as! FirstViewCell).likeNum.font
                    self.label_two.textColor = (cell as! FirstViewCell).likeNum.textColor
                    (cell as! FirstViewCell).contentView.addSubview(self.label_two)
                    self.label_two.frame = (cell as! FirstViewCell).bottomLikeNum.frame
                    self.label_two.text = "\( (model?.items[index].likeCount)!+1)"
                }, completion: nil)
                
                UIView.animate(withDuration: 0.4, delay: 0.4, options: [], animations: {
                    self.label_two.center.y -= 5
                }) { (finish) in
                    self.label_two.removeFromSuperview()
                }
                UIView.animate(withDuration: 0.0, delay: 0.8, options: [], animations: {
                    (cell as! FirstViewCell).likeNum.alpha = 1.0
                }, completion: nil)
                
            }else{
                (cell as! FirstViewCell).likeBtn.setImage(UIImage.init(named: "喜欢"), for: .normal)
                
                UIView.animate(withDuration: 0.0, animations: {
                    (cell as! FirstViewCell).likeNum.alpha = 0.0
                    (cell as! FirstViewCell).likeNum.text = "\( (model?.items[index].likeCount)!+0)"
                    
                    self.label_one = UILabel()
                    self.label_one.font = (cell as! FirstViewCell).likeNum.font
                    self.label_one.textColor = (cell as! FirstViewCell).likeNum.textColor
                    (cell as! FirstViewCell).contentView.addSubview(self.label_one)
                    self.label_one.frame = (cell as! FirstViewCell).likeNum.frame
                    self.label_one.text = "\((model?.items[index].likeCount!)!+1)"
                }, completion: nil)
                
                UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut], animations: {
                    self.label_one.center.y += 5
                }) { (finish) in
                    self.label_one.removeFromSuperview()
                }
                
                UIView.animate(withDuration: 0.0, delay: 0.4, options: [.curveEaseIn], animations: {
                    self.label_two = UILabel()
                    self.label_two.font = (cell as! FirstViewCell).likeNum.font
                    self.label_two.textColor = (cell as! FirstViewCell).likeNum.textColor
                    (cell as! FirstViewCell).contentView.addSubview(self.label_two)
                    self.label_two.frame = (cell as! FirstViewCell).topLikeNum.frame
                    self.label_two.text = "\( (model?.items[index].likeCount)!+0)"
                }, completion: nil)
                
                UIView.animate(withDuration: 0.4, delay: 0.4, options: [], animations: {
                    self.label_two.center.y += 5
                }) { (finish) in
                    self.label_two.removeFromSuperview()
                }
                UIView.animate(withDuration: 0.0, delay: 0.8, options: [], animations: {
                    (cell as! FirstViewCell).likeNum.alpha = 1.0
                }, completion: nil)
                
            }
        }
        else{
           (cell as! ThirdViewCell).likeBtn.isSelected = !(cell as! ThirdViewCell).likeBtn.isSelected
            
            if (cell as! ThirdViewCell).likeBtn.isSelected {
                (cell as! ThirdViewCell).likeBtn.setImage(UIImage.init(named: "喜欢_selected"), for: .normal)
                
                UIView.animate(withDuration: 0.0, animations: {
                    (cell as! ThirdViewCell).likeCountLabel.alpha = 0.0
                    (cell as! ThirdViewCell).likeCountLabel.text = "\( (model?.items[index].likeCount)!+1)"
                    
                    self.label_one = UILabel()
                    self.label_one.font = (cell as! ThirdViewCell).likeCountLabel.font
                    self.label_one.textColor = (cell as! ThirdViewCell).likeCountLabel.textColor
                    (cell as! ThirdViewCell).contentView.addSubview(self.label_one)
                    self.label_one.frame = (cell as! ThirdViewCell).likeCountLabel.frame
                    self.label_one.text = "\((model?.items[index].likeCount!)!+0)"
                }, completion: nil)
                
                UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut], animations: {
                    self.label_one.center.y -= 5
                }) { (finish) in
                    self.label_one.removeFromSuperview()
                }
                
                UIView.animate(withDuration: 0.0, delay: 0.4, options: [.curveEaseIn], animations: {
                    self.label_two = UILabel()
                    self.label_two.font = (cell as! ThirdViewCell).likeCountLabel.font
                    self.label_two.textColor = (cell as! ThirdViewCell).likeCountLabel.textColor
                    (cell as! ThirdViewCell).contentView.addSubview(self.label_two)
                    self.label_two.frame = (cell as! ThirdViewCell).bottomLikeLabel.frame
                    self.label_two.text = "\( (model?.items[index].likeCount)!+1)"
                }, completion: nil)
                
                UIView.animate(withDuration: 0.4, delay: 0.4, options: [], animations: {
                    self.label_two.center.y -= 5
                }) { (finish) in
                    self.label_two.removeFromSuperview()
                }
                UIView.animate(withDuration: 0.0, delay: 0.8, options: [], animations: {
                    (cell as! ThirdViewCell).likeCountLabel.alpha = 1.0
                }, completion: nil)
                
            }else{
                (cell as! ThirdViewCell).likeBtn.setImage(UIImage.init(named: "喜欢"), for: .normal)
                
                UIView.animate(withDuration: 0.0, animations: {
                    (cell as! ThirdViewCell).likeCountLabel.alpha = 0.0
                    (cell as! ThirdViewCell).likeCountLabel.text = "\( (model?.items[index].likeCount)!+0)"
                    
                    self.label_one = UILabel()
                    self.label_one.font = (cell as! ThirdViewCell).likeCountLabel.font
                    self.label_one.textColor = (cell as! ThirdViewCell).likeCountLabel.textColor
                    (cell as! ThirdViewCell).contentView.addSubview(self.label_one)
                    self.label_one.frame = (cell as! ThirdViewCell).likeCountLabel.frame
                    self.label_one.text = "\((model?.items[index].likeCount!)!+1)"
                }, completion: nil)
                
                UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut], animations: {
                    self.label_one.center.y += 5
                }) { (finish) in
                    self.label_one.removeFromSuperview()
                }
                
                UIView.animate(withDuration: 0.0, delay: 0.4, options: [.curveEaseIn], animations: {
                    self.label_two = UILabel()
                    self.label_two.font = (cell as! ThirdViewCell).likeCountLabel.font
                    self.label_two.textColor = (cell as! ThirdViewCell).likeCountLabel.textColor
                    (cell as! ThirdViewCell).contentView.addSubview(self.label_two)
                    self.label_two.frame = (cell as! ThirdViewCell).topLikeLabel.frame
                    self.label_two.text = "\( (model?.items[index].likeCount)!+0)"
                }, completion: nil)
                
                UIView.animate(withDuration: 0.4, delay: 0.4, options: [], animations: {
                    self.label_two.center.y += 5
                }) { (finish) in
                    self.label_two.removeFromSuperview()
                }
                UIView.animate(withDuration: 0.0, delay: 0.8, options: [], animations: {
                    (cell as! ThirdViewCell).likeCountLabel.alpha = 1.0
                }, completion: nil)
                
            }
        }
        
        
    }
}
