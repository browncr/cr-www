package controllers

import play.api._
import play.api.mvc._
import models._
import play.api.db.slick._
import play.api.db.slick.Config.driver.simple._

object Application extends Controller {

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

}
