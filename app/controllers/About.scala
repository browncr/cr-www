package controllers

import play.api._
import play.api.mvc._

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

}

