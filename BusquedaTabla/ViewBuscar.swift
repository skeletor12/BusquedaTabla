//
//  ViewBuscar.swift
//  BusquedaTabla
//
//  Created by Luis Rodriguez on 02/08/16.
//  Copyright © 2016 Luis Rodriguez. All rights reserved.
//

import UIKit

class ViewBuscar: UIViewController {
    
    
//var libros : Array<Array<String>> = Array<Array<String>>()
    
    @IBOutlet weak var ISBN: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    
    @IBAction func ISBN(sender: AnyObject) {
        busqueda()
    }
    
    
    func busqueda() {
        
        let libro = libros()
        let IsbnNumber=String(self.ISBN.text!)
        libro.isnb = IsbnNumber
        let urls="https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + IsbnNumber
        let url = NSURL(string: urls)
        let datos: NSData? = NSData(contentsOfURL: url!)
        
        if datos == nil {
            let alert = UIAlertController(title: "Aviso", message: "CONEXION FALLIDA", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            
            if texto! == "{}" {
                let alert = UIAlertController(title: "Aviso", message: "NO EXISTE REGISTRO", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                
                do {
                    
                    var arreglo: [String] = []
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let dico1 = json as! NSDictionary
                    let dico2 = dico1["ISBN:"+IsbnNumber] as! NSDictionary
                    
                    self.titulo.text = dico2["title"] as! NSString as String
                    let tema = dico2["title"] as! String
                    libro.titulo = tema
                    libreria.append(libro)
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
    

    @IBAction func limpiar(sender: AnyObject) {
        self.autor.text = ""
        self.portada.image = UIImage()
        self.titulo.text = ""
        self.ISBN.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let returnIsbn = segue.destinationViewController as! TableViewController
            returnIsbn.isbn = String(self.ISBN.text!)
            returnIsbn.tema = String(self.titulo.text!)
        print (returnIsbn.isbn)

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
 

}
