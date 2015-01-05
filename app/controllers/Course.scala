package controllers

import play.api._
import play.api.mvc._
import models.Tables._
import play.api.db.slick._
import play.api.db.slick.Config.driver.simple._

object Course extends Controller {

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def search = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def review(dept : String, num : String, offering : String, section : String) = DBAction { implicit request =>
  val courses = CrReview2008.filter(rev => rev.departmentCode === dept && rev.courseNum === num && rev.edition === offering && rev.section === section).list.toString
    Ok(play.api.libs.json.Json.toJson(courses))
  }

}

