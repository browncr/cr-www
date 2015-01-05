package controllers

import play.api._
import play.api.mvc._
import models._
import play.api.db.slick._
import play.api.db.slick.Config.driver.simple._

object Help extends Controller {

  def index = Action {
    Ok(views.html.help())
  }

  def review = Action {
    Ok(views.html.help_review())
  }

  def search = Action {
    Ok(views.html.help_search())
  }

  def instructor_names = Action {
    Ok(views.html.help_instructor_names())
  }

}
