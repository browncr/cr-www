package common

import scala.util.control.Exception._

object Codes {

  def toInt(str: String): Option[Int] = {
      catching(classOf[NumberFormatException]) opt str.toInt
  }

  /**
   * Given a CIS semester (e.g. 2010-Spring), return a CR edition (e.g. 2010.2011.2)
   * See comment for make_cis_semester() regarding years
   */
  def parse_cis_semester(semester: String) : Option[String] = {
    val (yearString, rest) = semester.span(_ != '-')
    val (_, season) = rest.span(_ == '-')
    toInt(yearString) flatMap { year =>
      season match {
        case "Fall" => Some((year + 1).toString + '.' + (year + 2).toString + ".1")
        case "Spring" => Some(yearString + '.' + (year + 1).toString + ".2")
        case _ => None
      }
    }
  }

  /**
   * Given a CR edition (e.g. 2010.2011.2), return a CIS semester string
   * (used in LDAP and course preview pages, e.g. 2010-Spring) Note that CIS
   * semesters represent the semester a course was OFFERED, whereas CR editions
   * represent the semester a course was REVIEWED (i.e. one year later). That's
   * why we subtract one from the year before returning.
   */
  def make_cis_semester(edition: String) = {
    edition.split('.') match {
      case Array(year1, year2, semString) =>
        toInt(semString) flatMap { sem =>
          sem match {
            case 1 => Some((year1.toInt - 1).toString + "-Fall")
            case 2 => Some((year2.toInt - 1).toString + "-Spring")
            case _ => None
          }
        }
      case _ => None
    }
  }

  /**
   * Given an edition, department, course number, and section, return a CIS
   * course code for it CIS course codes look like: ENGN:2911C:2010-Spring:S01
   * They're used in LDAP and course preview pages
   */
   def make_cis_coursecode(edition: String, dept: String, num: String, section: Int) = {
     make_cis_semester(edition) map { cis_edition =>
       f"$dept%s:$num%s:$cis_edition%s:S$section%02d"
     }
   }

  /**
   * Given an edition (e.g. 2010.2011.2), return the number of semesters that
   * have elapsed since that edition (as determined by the global value
   * current_edition).
   */
  def semesters_since_edition(edition: String) = {
    edition.split('.') match {
      case Array(compareYear, _, compareSem) =>
        Global.current_edition.split('.') match {
          case Array(currentYear, _, currentSem) =>
            val current = currentYear.toInt * 2 + currentSem.toInt - 1
            val compare = compareYear.toInt * 2 + compareSem.toInt - 1
            Some(current - compare)
          case _ => None
        }
      case _ => None
    }
  }

  /**
   * Given an edition (e.g. 2010.2011.2) return the semester: 0 for fall,
   * 1 for spring
   */
  def edition_semester(edition: String) = {
    edition.split('.') match {
      case Array(_, _, semString) =>
        toInt(semString) flatMap { sem =>
          sem match {
            case 1 => Some(0)
            case 2 => Some(1)
            case _ => None
          }
        }
      case _ => None
    }
  }

  /**
   * Given an edition (e.g. 2010.2011.2) return the Banner term (e.g. 201020)
   */
   def make_banner_term(edition: String) = {
     edition.split('.') match {
       case Array(year, _, sem) => Some(year + sem + "0")
       case _ => None
     }
   }
}
