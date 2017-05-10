//
//  ParseData.swift
//  TodoPole
//
//  Created by Alberto Banet on 15/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import Foundation
import Parse



class ParseData: NSObject {
  
  static let sharedInstance: ParseData = {
    let instance = ParseData()
    return instance
  }()
  
  var primeraVezAutoresLeidos: Bool = true
  
  
  // Cargar todas las figuras visibles desde la cache si hay
  func cargarFigurasVisibles(red: Bool, completion: @escaping ([Figura]) -> ()) {
    let arrayFavoritos = Favoritos.sharedInstance.arrayFavoritos
    let arrayAutoresBloqueados = ConfigurationAutores.getAutoresBloqueados()
    let arrayNivelesBloqueados = ConfigurationNiveles.getNivelesBloqueados()
    

    let campoOrden = ConfigurationOrden.fieldOrderDatabase()
    let query = PFQuery(className:"Figura")
    if red {
      query.cachePolicy = .networkOnly
    } else {
      query.cachePolicy = .cacheElseNetwork
    }
    query.whereKey("visible", equalTo: true)
    query.whereKey("profesional", equalTo: true)
    query.whereKey("objectId", notContainedIn: arrayFavoritos) // ahora las figuras que estén en favoritos no se mostrarán en la lista de figuras completa.
    if let listaBloqueo = arrayAutoresBloqueados {
      query.whereKey("autor", notContainedIn: listaBloqueo)
    }
    if let listaBloqueoNiveles = arrayNivelesBloqueados {
      query.whereKey("nivel", notContainedIn: listaBloqueoNiveles)
    }
    query.order(byDescending: campoOrden)
    cargarQueryParse(query, completion: completion)
  }
  
  // Cargar todas las figuras amateurs desde la cache si hay
  func cargarFigurasAmateurs(red: Bool, completion: @escaping ([Figura]) -> ()) {
    let arrayFavoritos = Favoritos.sharedInstance.arrayFavoritos
    let campoOrden = ConfigurationOrden.fieldOrderDatabase()
    let query = PFQuery(className:"Figura")
    if red {
      query.cachePolicy = .networkOnly
    } else {
      query.cachePolicy = .cacheElseNetwork
    }
    query.whereKey("visible", equalTo: true) // para que no le salgan a la gente
    query.whereKey("profesional", equalTo: false)
    query.whereKey("objectId", notContainedIn: arrayFavoritos)
    query.order(byDescending: campoOrden)
    cargarQueryParse(query, completion: completion)
  }
  
  // Cargar las figuras del mail que las ha subido
  func cargarFigurasEvolution(red: Bool, completion: @escaping ([Figura]) -> ()) {
    let conf = DefaultConfiguration()
    let mail = conf.evolutionMail ?? "NotMail"
    let query = PFQuery(className:"Figura")
    if red {
      query.cachePolicy = .networkOnly
    } else {
      query.cachePolicy = .cacheElseNetwork
    }
    query.whereKey("visible", equalTo: true) // para que no le salgan a la gente
    query.whereKey("email", equalTo: mail)
    query.order(byDescending: "createdAt")
    cargarQueryParse(query, completion: completion)
  }
  
  // Cargar las figuras favoritas
  func cargarFigurasFavoritas(red: Bool, completion: @escaping ([Figura]) -> ()) {
    let arrayFavoritos = Favoritos.sharedInstance.arrayFavoritos
    print("vamos a buscar lo que está en arrayFav: \(arrayFavoritos)")
    let query = PFQuery(className:"Figura")
    if red {
      query.cachePolicy = .networkOnly
    } else {
      query.cachePolicy = .cacheElseNetwork
    }
    query.whereKey("objectId", containedIn: arrayFavoritos)
    query.whereKey("visible", equalTo: true)
    cargarQueryParse(query, completion: completion)
  }
  
  
  
  // Cargas las figuras que se corresponden con un tipo dado
  // tipo -> Tipo de las figuras que se van a cargar
  
  // No se está usando actualmente
  func cargarFigurasTipo (_ tipo: TipoFigura, completion: @escaping ([Figura]) -> ()) {
    let query = PFQuery(className:"Figura")
    query.whereKey("visible", equalTo: true)
    query.whereKey("profesional", equalTo: true)
    query.whereKey("tipo", equalTo: tipo.rawValue)
    cargarQueryParse(query, completion: completion)
  }
  
  func cargarFigurasTipo(_ tipo: TipoFigura, red: Bool, completion: @escaping ([Figura]) -> ()) {
    let arrayFavoritos = Favoritos.sharedInstance.arrayFavoritos
    let arrayAutoresBloqueados = ConfigurationAutores.getAutoresBloqueados()
    let arrayNivelesBloqueados = ConfigurationNiveles.getNivelesBloqueados()
    let campoOrden = ConfigurationOrden.fieldOrderDatabase()
    
    let query = PFQuery(className:"Figura")
    if red {
      query.cachePolicy = .networkOnly
    } else {
      query.cachePolicy = .cacheElseNetwork
    }
    query.whereKey("visible", equalTo: true)
    query.whereKey("profesional", equalTo: true)
    query.whereKey("tipo", equalTo: tipo.rawValue)
    query.whereKey("objectId", notContainedIn: arrayFavoritos) // ahora las figuras que estén en favoritos no se mostrarán en la lista de figuras completa.
    if let listaBloqueo = arrayAutoresBloqueados {
      query.whereKey("autor", notContainedIn: listaBloqueo)
    }
    if let listaBloqueoNiveles = arrayNivelesBloqueados {
      query.whereKey("nivel", notContainedIn: listaBloqueoNiveles)
    }
    query.order(byDescending: campoOrden)
    cargarQueryParse(query, completion: completion)
  }
  
  
  
  private func cargarQueryParse(_ query: PFQuery<PFObject>, completion: @escaping ([Figura]) -> ()) {
    query.limit = 300 // límite impuesto por Parse? Ahora es 1000.
    query.includeKey("escuelaId")
    query.findObjectsInBackground {
      (objects: [PFObject]?, error: Error?) -> Void in
      if error == nil { // datos encontrados
        var figuras = [Figura]()
        for object in objects! {
          let nuevaFigura = Figura(object: object)
          // leemos la escuela
          if let pfEscuela = object.object(forKey: "escuelaId") as? PFObject {
            let escuela = Escuela(object: pfEscuela)
            nuevaFigura.escuela = escuela
          }
          figuras.append(nuevaFigura)
        }
        DispatchQueue.main.async {
          completion(figuras)
        }
      } else {
        // No hay datos ni en la red ni en la caché...ups!
        print("no estamos encontrando datos")
      }
    }
  }
  
  
  
  // carga un vídeo de parse
  // No hace falta: usar url directamente
  func cargarVideo(figura: Figura, completion: @escaping (Data)-> Void) {
    print("vamos a visionar \(String(describing: figura.nombre))")
    if let videoFile = figura.fileVideo {
      print("url del video: \(String(describing: figura.urlStringVideo))")
      videoFile.getDataInBackground(block: {
        (videoData: Data?, error: Error?) in
        guard error != nil else { return }
        if let video = videoData {
          // tenemos el fichero con el vídeo para mostrar
          completion(video)
        }
      })
    }
    
  }
  
  
  // Incrementamos el campo likes de la figura
  func incrementarLikes(figura: Figura) {
    let query = PFQuery(className:"Figura")
    query.getObjectInBackground(withId: figura.objectId!) {
      (figura: PFObject?, error: Error?) -> Void in
      if error == nil && figura != nil {
        figura?.incrementKey("likes")
        figura?.saveInBackground()
      } else {
        print("error")
      }
    }
  }
  
  // MARK: Functions about authors
  
  func listOfAuthors(red: Bool, completion: @escaping ([String])->()) {
    
    let query = PFQuery(className:"Profesores")
    query.whereKey("visible", equalTo: true)
    if red {
      query.cachePolicy = .networkOnly
    } else {
      query.cachePolicy = .cacheElseNetwork
    }
    
    // cogerá la información de las figuras ya leídas.
    query.findObjectsInBackground {
      (objects: [PFObject]?, error: Error?) -> Void in
      var list = [String]()
      guard let listObjects = objects else {
        return
      }
      for object in listObjects {
        let profesor = object["name"] as! String
        if !list.contains(profesor) {
          list.append(profesor)
        }
      }
      completion(list)
      
    }
  }
  
  func listOfAuthorsNow() -> [String] {
    let query = PFQuery(className:"Profesores")
    query.whereKey("visible", equalTo: true)
    query.order(byAscending: "name")
    if primeraVezAutoresLeidos {
      query.cachePolicy = .networkElseCache
      primeraVezAutoresLeidos = false
    } else {
      query.cachePolicy = .cacheElseNetwork
    }
    var list = [String]()
    do {
      let profesoresObjects = try query.findObjects()
      for object in profesoresObjects {
        let profesor = object["name"] as! String
        if !list.contains(profesor) {
          list.append(profesor)
        }
      }
    } catch {
    }
    return list
  }
  
 
  
} // Fin de la clase
