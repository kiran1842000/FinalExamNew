//
//  NewsTableViewController.swift
//  Kiran_PadinhareKUnnoth_FE_8940891
//
//  Created by IS on 2023-12-09.
//

import UIKit


class NewsTableViewController: UITableViewController {
    

    
    
    @IBOutlet var newsTableView: UITableView!
    
    var newsData:[Article] = []
    

    @IBAction func getCityName(_ sender: UIBarButtonItem) {
    
    
    
        let alert = UIAlertController(title: "Enter the city", message: " ", preferredStyle: .alert)
        
        alert.addTextField()
        alert.textFields![0].placeholder = "City Name"
        alert.textFields![0].keyboardType = UIKeyboardType.namePhonePad
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive,handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default ,handler: {(action) in
            let cityName = alert.textFields![0].text
            self.getCityNews(cityName: cityName!)
        }))
        
        self.present(alert, animated: true)
        
    }
    
    func getCityNews(cityName : String){
        
        
        //Step 1
        //API Session
        guard let city  = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return}
        let urlString = "https://newsapi.org/v2/everything?q=\(city)&apiKey=0d6cee0307ce4370a4e15c56a9ab712c"
       

        //instance of URLSession class and assign the value of your URL to the URL in the class
        let urlSession = URLSession(configuration: .default)
        
        
        let url = URL(string: urlString)
     
        
        //check for valid URL
        if let url = url{
      
            
            //Create a variable to capture data from the url
            let dataTask = urlSession.dataTask(with: url){
                (data,_,error) in
                //if URL is okey, then get the data and decode
                if let data = data {
                
                    
                    let jsonDecoder = JSONDecoder()
                    do{
                        
                        let readableData = try jsonDecoder.decode(News.self, from: data)
                      
                        self.updateUI(with: readableData.articles)
                    }
                    catch {
                        print("Can't Decode")
                    }
                }
            }
            dataTask.resume()
           
        }
        
        
    }
    
    func updateUI(with data: [Article]){
        DispatchQueue.main.sync{
            newsData = data
            newsTableView.reloadData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }

    // MARK: - Table view data source

   override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsTableViewCell
        let item = newsData[indexPath.row]
        cell.newsTitle.text = String("\(item.title)")
        cell.newsDescription.text = String("\(item.description)")
        cell.newsSource.text = String("\(item.source.name)")
        cell.newsAuthor.text = String("\(item.author)")
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
