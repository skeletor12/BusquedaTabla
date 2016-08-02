//
//  ViewBuscado.swift
//  BusquedaTabla
//
//  Created by Luis Rodriguez on 02/08/16.
//  Copyright © 2016 Luis Rodriguez. All rights reserved.
//

import UIKit

class ViewBuscado: UIViewController {
    
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    
    var ISBN = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urls="https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + ISBN
        let url = NSURL(string: urls)
        let datos: NSData? = NSData(contentsOfURL: url!)
        
        do {
            
            var arreglo: [String] = []
            
            let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
            let dico1 = json as! NSDictionary
            let dico2 = dico1["ISBN:"+ISBN] as! NSDictionary
            
            self.titulo.text = dico2["title"] as! NSString as String
            
            let autores =  dico2["authors"] as! NSArray
            for autor in autores
            {
                arreglo.append(autor["name"] as! NSString as String)
            }
            
            let arrautor = Autores(arreglo)
            self.autor.text = arrautor
            
            let busqueda = dico2.objectForKey("cover")
            
            if busqueda != nil {
                
                let dico3 = dico2["cover"] as! NSDictionary
                let dico4 = dico3["large"] as! NSString as String
                let cover = NSURL(string: dico4)
                let coverL:NSData? = NSData(contentsOfURL: cover!)
                portada.image = UIImage(data: coverL!)
            } else {
                portada.image = UIImage(named: "url.png")
                
            }
        }
            
        catch _ {
            
        }
        
    }
    
    func Autores(arreglo: [String]) -> String
    {
        var autores: String = ""
        
        if (arreglo.count == 1){
            
            return arreglo[0]
        }
        else
        {
            autores = arreglo.joinWithSeparator("-")
            return autores
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
