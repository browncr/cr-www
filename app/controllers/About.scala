package controllers

import play.api._
import play.api.mvc._
import models.Tables._
import play.api.db.slick._
import play.api.db.slick.Config.driver.simple._


object About extends Controller {

  def index = Action {
    Ok(views.html.about("Your new application is ready."))
  }

  def history = Action {
    Ok(views.html.about_history("Your new application is ready."))
  }

  def contact = Action {
    Ok(views.html.about_contact("Your new application is ready."))
  }

  def write = Action {
    Ok(views.html.about_write())
  }
  
  def faq = TODO
  
  def new_site = TODO
  
  def bios = DBAction { implicit request =>
      val userList = CrUserBios2005.filter(usr => usr.edition === "2014.2015.2")
      val execList = userList.filter(usr => usr.lev >= 4.toByte).list
      val editorList = userList.filter(usr => usr.lev === 3.toByte).list
      val writerList = userList.filter(usr => usr.lev === 2.toByte).list
      
      Ok(views.html.about_bio(execList, editorList, writerList))
  }

}

