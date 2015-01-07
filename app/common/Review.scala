package common

import play.api._
import play.api.mvc._
import play.twirl.api.Html
import scala.xml.Utility.escape
import models.Tables._
import play.api.db.slick.Config.driver.simple._
import play.api.db.slick.Config.driver.simple.{Session => DBSession}

object Review {

  implicit val offeringsOrdering = Ordering.by[(String,List[String]),String](_._1).reverse

  // For a given department and course number, get all offerings.
  def getOfferings(dept: String, num: String)(implicit session: DBSession) = {
    CrReview2008.filter(rev =>
      rev.revision === 0 &&
      rev.departmentCode === dept &&
      rev.edition <= Global.current_edition &&
      rev.courseNum === num)
    .map(rev => (rev.edition, rev.section))
    .list
    .groupBy(_._1)
    .mapValues(_.map(_._2))
    .toList
    .sorted
  }


  // Given the textual contents of a review, mark it up with XML
  def markup_review_content(content: String) = {
    val ulevel = 0 // TODO: track and store ulevel
    var xml_content = "";
    content.replaceAll("\r", "").split("""(\s*\n\s*\t\s*|\s*\n\s*\n\s*)""")
    .map { para =>
        if (ulevel >= 6) {
            // TODO: use a flag to specify if char-count should be included
            // (instead of always including it for webmasters)
            xml_content += "<p char-count=\"" + para.length.toString + "\">"
        } else {
            xml_content += "<p>";
        }
        xml_content += scala.xml.Utility.escape(para).replaceAll("""\b([A-Z]{3,4}) *([0-9]{4})(-?([A-Z]))?(-S([0-9]{1,2}))?\b""", """<a href="/$1/$2$4">$0</a>""") + "</p>"
    }
    Html(xml_content);
  }

  def course_link(dept: String, num: String, offered: String, section: String) = {
    f"/$dept%s/$num%s/$offered%s/$section%s"
  }

}
