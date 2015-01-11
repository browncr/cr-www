
import play.api._
import play.api.cache._
import play.api.Play.current
import play.api.db.slick._
import play.api.db.slick.Config.driver.simple._
import models.Tables._


package object Global extends GlobalSettings {
  type DBSession = play.api.db.slick.Config.driver.simple.Session

  lazy val current_edition = Play.current.configuration.getString("cr.current_edition").get
  lazy val current_edition_id =Play.current.configuration.getString("cr.current_edition_id").get
  lazy val next_edition = Play.current.configuration.getString("cr.next_edition").get
  lazy val next_edition_id = Play.current.configuration.getString("cr.next_edition_id").get
  lazy val next_mocha_id = Play.current.configuration.getString("cr.next_mocha_id").get
  lazy val restrict_to_community = Play.current.configuration.getBoolean("cr.restrict_to_community").getOrElse(true)
  lazy val subdomain =Play.current.configuration.getString("cr.subdomain")
  lazy val site_dir = Play.current.configuration.getString("cr.site_dir")
  lazy val data_dir =  Play.current.configuration.getString("cr.data_dir")

  def departments: List[CrDepartment2005Row] = Cache.getOrElse("departments", 600) {
    DB.withSession { implicit session =>
      CrDepartment2005.sortBy(_.bannerCode).list
    }
  }

}
