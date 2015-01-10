package common

import play.api.data._
import play.api.data.Forms._
import play.api.data.format._
import play.api.db.slick._
import play.api.db.slick.Config.driver.simple._
import play.api.db.slick.Config.driver.simple.{Session => DBSession}
import models.Tables._
import common.Review._

object Search {

   /**
    * booleanIntFormat is a formatter that accepts 1 and 0 as true and
    * false respectively.
    */
   def booleanIntFormat: Formatter[Boolean] = new Formatter[Boolean] {
     override val format = Some(("format.boolean", Nil))
     def bind(key: String, data: Map[String, String]) = {
       Right(data.get(key).getOrElse("false")).right.flatMap {
         case "true" | "1" => Right(true)
         case "false" | "0" => Right(false)
         case _ => Left(Seq(FormError(key, "error.boolean", Nil)))
       }
     }
     def unbind(key: String, value: Boolean) = Map(key -> value.toString)
   }

  case class SearchRequest(quickSearch: Option[String], courseCode: Option[String], professor: Option[String], departments: List[String], title: Option[String], fall: Option[Boolean], spring: Option[Boolean], recent: Option[Boolean])

  val form = Form(mapping(
    "q" -> optional(text),
    "course_code" -> optional(text),
    "professor" -> optional(text),
    "department" -> Forms.list(text),
    "title" -> optional(text),
    "fall" -> optional(of[Boolean](booleanIntFormat)),
    "spring" -> optional(of[Boolean](booleanIntFormat)),
    "attribute_recent" -> optional(of[Boolean](booleanIntFormat))
  )(SearchRequest.apply)(SearchRequest.unapply))

  def process(sr: SearchRequest)(implicit session: DBSession) = {
    val checkDept = if (sr.departments.length > 0) {
      for {
        rev <- CrReview2008
        if rev.departmentCode inSetBind sr.departments
      } yield rev
    } else CrReview2008

    val checkCode = sr.courseCode match {
      case Some(code) => checkDept.filter(_.courseNum === code)
      case None => checkDept
    }

    val checkProf = sr.professor match {
      case Some(prof) => checkCode.filter(_.professor.toLowerCase like f"%%$prof%s%%")
      case None => checkCode
    }

    val checkTitle = sr.title match {
      case Some(title) => checkProf.filter(_.title.toLowerCase like f"%%$title%s%%")
      case None => checkProf
    }

    var previousDept = ""
    var previousCNum = ""

    checkTitle.filter(rev => // Only fetch good, published reviews
      rev.revision === 0 &&
      rev.edition <= Global.current_edition
    )
    // Sorting
    // Sort first by department code and course num so reviews for the same
    // course are grouped. Then, prioritize reviews for the same course
    // as follows:
    //  1. We want actually published reviews first (sort DESC by active)
    //  2. We want reviews with sufficient information (sort ASC by insufficient)
    //  3. We want recent reviews (sort DESC by edition)
    //  4. We want reviews with lots of respondents (sort DESC by num_respondents)
    .sortBy(rev =>
        (rev.departmentCode.asc, rev.courseNum.asc, rev.active.desc, rev.insufficient.asc, rev.edition.desc, rev.numRespondents.desc)
    )
    .list
    .flatMap({ course =>
      val dept = course(2)
      val cnum = course(3)
      if (dept == previousDept && cnum == previousCNum) {
        None
      } else {
        previousDept = dept
        previousCNum = cnum
        Some(course)
      }

    })
  }

  /**
   * TODO
   */
  def getBannerCodes[A](id: A) = id

  def cleanForLike(str: String) = str.replaceAll("%", "[%]").toLowerCase

  def extractDepts(sr: SearchRequest) = {
    (sr.courseCode, sr.quickSearch) match {
      case (Some(deptRegex(depts, _)), _) =>
        val newDepts = sr.departments ++ getBannerCodes(depts.split(", "))
        sr.copy(courseCode = None, departments = newDepts)
      case (_, Some(deptRegex(depts, _))) =>
        val newDepts = sr.departments ++ getBannerCodes(depts.split(", "))
        sr.copy(quickSearch = None, departments = newDepts)
      case _ =>
        sr
    }
  }

  def extractProfs(sr: SearchRequest)(implicit session: DBSession) = {
    (sr.professor, sr.quickSearch) match {
      case (None, Some(prof)) => {
        val newProf = cleanForLike(prof)
        val matching = CrReview2008
        .filter(_.professor.toLowerCase like f"%%$newProf%s%%")
        .length
        .run
        if (matching > 0) {
          sr.copy(professor = Some(newProf), quickSearch = None)
        } else sr
      }
      case _ => sr
    }
  }

  def extractTitle(sr: SearchRequest) = {
    (sr.title, sr.quickSearch) match {
      case (Some(title), _) =>
        val newTitle = cleanForLike(title)
        sr.copy(title = Some(newTitle))
      case (None, Some(title)) =>
        val newTitle = cleanForLike(title)
        sr.copy(title = Some(newTitle), quickSearch = None)
      case _ => sr
    }
  }

  def extractAll(sr: SearchRequest)(implicit session: DBSession) =
    extractTitle(extractProfs(extractDepts(sr)))

}
