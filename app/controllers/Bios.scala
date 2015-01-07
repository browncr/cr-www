package controllers

import play.api._
import play.api.mvc._
import play.api.http._
import models.Tables._
import play.api.db.slick._
import play.api.db.slick.Config.driver.simple._


object Bios extends Controller {
  
  def staffPhoto(edition: String, uid: Int, fluff: String) = DBAction { implicit request =>
      val photo = StaffPhotos.filter(usr => usr.edition === edition && usr.userId === uid).list.head.data
      val photoLen = photo.length().toInt
      val photoBytes : Array[Byte] = photo.getBytes(1, photoLen)
      
      Ok(photoBytes).as("image/jpeg")
  }

}

