// EmojiDictionary

import UIKit

private let reuseIdentifier = "Item"

class EmojiCollectionViewController: UICollectionViewController {

    var emojis: [Emoji] = [
        Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
        Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
        Emoji(symbol: "🧑‍💻", name: "Developer", description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software, programming"),
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
        
        /*
         "[This (vvv) defines] an item size for each cell in the collection view. Each item should be the full size of its container
         */
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        //"As in the BasicCollectionView app, in EmojiDictionary each row in the collection is represented by a group. You'll want the group to be set to a fixed height of 70 and the full width of its container. Each group will contain one item.
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)
            ),
            subitem: item,
            count: 1
        )
        
        // "Finally, each group is encapsulated into a section and the section is used to set the final compositional layout" (Develop in Swift Data Collections – Emoji Dictionary Lab).
        
        let section = NSCollectionLayoutSection(group: group)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
    
        //Step 2: Fetch model object to display
        let emoji = emojis[indexPath.item]

        //Step 3: Configure cell
        cell.update(with: emoji)

        //Step 4: Return cell
        return cell
    }
    
    /*
     "With a table view, there are built-in mechanisms to handle row deletion. A collection view doesn't have this feature, but it does allow you to attach a context menu to items, which can be used for a similar purpose. These context menus are the same as those used throughout iOS 13, so they should be familiar to your users.
     "To create a context menu for an item, you must implement the collectionView(_ :contextMenuConfigurationForItemAt:point:) method from UICollectionViewDelegate (which, as noted, is a protocol that a UICollectionViewController already adopts).
     */
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil)
            { (elements) -> UIMenu? in
            
                let delete = UIAction(
                    title: "Delete")
                    { (action) in
                        
                        if let indexPath = indexPaths.first {
                            self.deleteEmoji(at: indexPath)
                        }
                    
                    }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
        }
        
        return config
    }
    
    // "This [(^^^)] defines a UIContextMenuConfiguration that contains a UIMenu with a single action.
    // To enable deletions, the deleteEmoji method must be defined. Deleting an emoji removes it from the emoji collection and then removes it from the collection view" (Develop in Swift Data Collections – Emoji Dictionary Lab).
    
    func deleteEmoji(at indexPath: IndexPath) {
        emojis.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }

    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
            // Editing Emoji
            let emojiToEdit = emojis[indexPath.row]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            // Adding Emoji
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? AddEditEmojiTableViewController,
            let emoji = sourceViewController.emoji else { return }
        
        if let path = collectionView.indexPathsForSelectedItems?.first {
                // Updates existing emoji
            emojis[path.row] = emoji
            collectionView.reloadItems(at: [path])
        } else {
                // Adds new emoji
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            collectionView.insertItems(at: [newIndexPath])
        }
    }

}
