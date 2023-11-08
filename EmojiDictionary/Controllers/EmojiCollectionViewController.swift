//
//  EmojiCollectionViewController.swift
//  EmojiDictionary
//
//  Created by 曹家瑋 on 2023/11/8.
//

import UIKit

private let reuseIdentifier = "Item"

class EmojiCollectionViewController: UICollectionViewController {
    
    // 用來定義 id
    struct PropertyKeys {
        static let saveUnwind = "saveUnwind"
    }

    /// 用來存儲表格的數據
    var emojis: [Emoji] = [
        Emoji(symbol: "😀", name: "Grinning Face",description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "😕", name: "Confused Face",description: "A confused, puzzled face.", usage: "unsurewhat to think; displeasure"),
        Emoji(symbol: "😍", name: "Heart Eyes",description: "A smiley face with hearts for eyes.",usage: "love of something; attractive"),
        Emoji(symbol: "🧑‍💻", name: "Developer",description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software,programming"),
        Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "something slow"),
        Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "good memory"),
        Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
        Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
        Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
        Emoji(symbol: "📚", name: "Stack of Books", description: "Three colored books stacked on each other.", usage: "homework, studying"),
        Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
        Emoji(symbol: "💤", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
        Emoji(symbol: "🏁", name: "Checkered Flag", description: "A black-and-white checkered flag.", usage: "completion")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 設定每個cell的大小讓它們各自剛好填滿容器
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        // 建立group，每個群組的高度為70點，寬度填滿容器
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(70)
            ),
            subitem: item,
            count: 1
        )
        
        // 將 group 包裝成 section
        let section = NSCollectionLayoutSection(group: group)
        
        // 對collectionView設定最終的CompositionalLayout
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 重新加載數據以更新視圖
        collectionView.reloadData()
    }
    

    // MARK: - Navigation
    
    // 處理用戶點擊添加按鈕或點擊行(row)以編輯一個表情符號的操作。
    // 根據用戶的操作初始化 AddEditEmojiTableViewController 並傳遞相應的表情符號或nil。
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        
        // 嘗試將 sender 轉型為 UICollectionViewCell。如果轉型成功，表示用戶想要編輯一個現有的表情符號。
        if let cell = sender as? UICollectionViewCell,
           let indexPath = collectionView.indexPath(for: cell) {
            // 編輯現有的Emoji
            // 通過 indexPath 從 emojis陣列 中獲取要編輯的表情符號，並將其傳遞給新視圖控制器。
            let emojiToEdit = emojis[indexPath.row]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } 
        // 如果 sender 不是一個 UITableViewCell（如果用戶點擊了添加按鈕）
        else {
            // 添加新的Emoji
            // 使用 nil 初始化 AddEditEmojiTableViewController 表示將創建一個新的表情符號。
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
        
    }
    
    // 根據情況更新表格的內容
    @IBAction func unwindToEmojiTableView(_ unwindSegue: UIStoryboardSegue) {
        // 確認segue與來源控制器的身份，並取得emoji數據
        guard unwindSegue.identifier == PropertyKeys.saveUnwind,
              let sourceViewController = unwindSegue.source as? AddEditEmojiTableViewController,
              let emoji = sourceViewController.emoji else { return }
        
        // 確認是編輯現有的emoji還是新增一個emoji
        // 如果有選擇的項目，則更新該表情符號
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            emojis[selectedIndexPath.row] = emoji
            collectionView.reloadItems(at: [selectedIndexPath])
        } else {
            // 沒有選擇的項目，表示創建了一個新的表情符號
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            collectionView.insertItems(at: [newIndexPath])
        }
        
    }


    // MARK: - UICollectionViewDataSource

    // 返回集合視圖的區段數
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // 返回每個區段的項目數量
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }

    // 提供每個項目的單元格
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EmojiCollectionViewCell else {
            fatalError("Unable to dequeue EmojiCollectionViewCell")
        }
        
        // 從 emojis array中獲取對應行的 emoji 對象，用於配置單元格的顯示內容。
        let emoji = emojis[indexPath.item]
        cell.update(with: emoji)
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    // 為集合視圖的每個項目設置上下文選單配置
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // 創建一個上下文選單配置，當選單被觸發時會呼叫閉包
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (elements) -> UIMenu? in
            // 創建一個刪除動作
            let delete = UIAction(title: "Delete") { (action) in
                // 當選擇刪除時，呼叫 deleteEmoji
                self.deleteEmoji(at: indexPath)
            }
            
            // 返回包含刪除動作的選單
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
        }
        return config
    }
    
    // 刪除表情的函式
    func deleteEmoji(at indexPath: IndexPath) {
        // 從資料陣列中移除該表情
        emojis.remove(at: indexPath.row)
        // 從集合視圖中刪除對應項目
        collectionView.deleteItems(at: [indexPath])
    }

}

