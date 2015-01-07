package controllers

import play.api._
import play.api.mvc._

object OldRoutes extends Controller {

  def images(path : String) = Action {
    Redirect(routes.Assets.at("images/" + path))
  }
  
  def cr_xml(action: String, static: String) = Action {
      (action, static) match {
          case("", "") => Redirect(routes.Application.index)
          case("home", _) => Redirect(routes.Application.index)
          //case("quotes", _) => Redirect(routes.Quotes.index)      //Uncomment this when Kei finishes quotes page
          case(_, "help") => Redirect(routes.Help.index)
          case("faq", _) => Redirect(routes.About.faq)
          case("bios", _) => Redirect(routes.About.bios)
          case(_, "contact") => Redirect(routes.About.contact)
          case(_, "write") => Redirect(routes.About.write)
          case(_, "history") => Redirect(routes.About.history)
          case(_, _) => Redirect(routes.Application.index)
      }
  }

}
