package controllers

import play.api._
import play.api.mvc._
import models.Tables._
import play.api.db.slick._
import play.api.db.slick.Config.driver.simple._


object Quotes extends Controller {

  def index = DBAction { implicit request =>
    val quotesList = CrQuotes2005.filter(quote => quote.edition === Global.current_edition && quote.published === true)
    val masterArray: Array[List[models.Tables.CrQuotes2005Row]] = new Array[List[models.Tables.CrQuotes2005Row]](8)
    
    for (i <- 0 to 7) {
      masterArray(i) = quotesList.filter(quote => quote.questId === (i+1)).list
    }
    
    Ok(views.html.quotes(masterArray))
  }

}