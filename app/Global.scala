
import play.api._

package object Global extends GlobalSettings {

  lazy val current_edition = Play.current.configuration.getString("cr.current_edition").get
  lazy val current_edition_id =Play.current.configuration.getString("cr.current_edition_id").get
  lazy val next_edition = Play.current.configuration.getString("cr.next_edition").get
  lazy val next_edition_id = Play.current.configuration.getString("cr.next_edition_id").get
  lazy val next_mocha_id = Play.current.configuration.getString("cr.next_mocha_id").get
  lazy val restrict_to_community = Play.current.configuration.getBoolean("cr.restrict_to_community").getOrElse(true)
  lazy val subdomain =Play.current.configuration.getString("cr.subdomain")
  lazy val site_dir = Play.current.configuration.getString("cr.site_dir")
  lazy val data_dir =  Play.current.configuration.getString("cr.data_dir")



}
