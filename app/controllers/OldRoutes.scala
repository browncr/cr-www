package controllers

import play.api._
import play.api.mvc._

object OldRoutes extends Controller {

  def images(path : String) = Action {
    Redirect(routes.Assets.at("images/" + path))
  }

}
