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

  def truncate_avg(avg: Float) = {
    f"$avg%.2f"
  }

  val deptRegex = """ *([A-Za-z]{2,4}([ ,]+[A-Za-z]{2,4})*) *""".r
  val courseRegex = """\b([A-Z]{3,4}) *([0-9]{4})(-?([A-Z]))?(-S([0-9]{1,2}))?\b""".r
  val courseSearchRegex = """ *([A-Za-z]{2,4}) *([0-9]{1,4})([A-Za-z]?) *""".r

  /**
   * If a query forms a course code (e.g. "CSCI0310") according to the course
   * search regular expression, this function will take care of adjusting
   * the strings to be usable for searching for a course.
   *
   * This function strives to be as user-friendly as possible, and accepts
   * the course code in a wide variety of shortened or non-standard forms. For
   * example, you can specify:
   *
   *   - without leading zeros (CSCI310 (or even CSCI40 for CSC0040))
   *   - with pre-banner department codes (CS0310)
   *   - without the trailing zero (i.e. pre-Banner style) (CSCI031 or
   *     CS031 or CS31)
   *
   * Note that sometimes it's ambiguous how a pre-Banner number should be
   * translated.  For example, is CS190 CSCI1900 or CSCI0190?  In these
   * instances, the 3rd element of the returned array (alt_num) is an
   * alternative course number which should be tried in addition to the
   * regular number.
   */
  def matchCourseCode(dept: String, num: String, letterRaw: String)(implicit session: DBSession) = {
    val letter = if (letterRaw == null) "" else letterRaw
    val fixedDept = if (dept.length == 2) {
      Search.getBannerCode(dept.toUpperCase).list match {
        case d::rest => Some(d)
        case Nil => None
      }
    } else Some(dept.toUpperCase)
    val (fixedNum, altNum) = num.length match {
      case 1 => ("00" + num(0) + "0" + letter, None)
      case 2 if num(1) == '0' => ("00" + num(0) + "0" + letter, None)
      case 2 => ("0" + num + "0" + letter, None)
      case 3 => (num + "0" + letter, Some("0" + num + letter))
      case _ => (num + letter, None)
    }
    val a = (fixedDept, fixedNum, altNum)
    play.Logger.debug(a.toString)
    a
  }


  /**
   * Given the textual contents of a review, mark it up with HTML
   */
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
        xml_content += courseRegex.replaceAllIn(scala.xml.Utility.escape(para), """<a href="/$1/$2$4">$0</a>""") + "</p>"
    }
    Html(xml_content);
  }

  def course_link(dept: String, num: String, offered: String, section: String) = {
    f"/$dept%s/$num%s/$offered%s/$section%s"
  }

}
