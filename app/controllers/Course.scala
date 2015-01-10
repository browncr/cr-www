package controllers

import play.api._
import play.api.mvc._
import models.Tables._
import play.api.db.slick._
import play.api.db.slick.Config.driver.simple._
import play.api.db.slick.Config.driver.simple.{Session => DBSession}
import scala.slick.lifted.CanBeQueryCondition
import common.Codes._
import common.Review._
import common._


object Course extends Controller {

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def search(sort: String) = DBAction { implicit request =>
    Search.form.bindFromRequest.fold(
      formWithErrors => BadRequest(<h1>Your search was bad: {formWithErrors}</h1>),
      { values =>
        (values.courseCode, values.quickSearch) match {
          case (Some(courseRegex(dept, num, _, letter, _, section)), _) =>
            val cnum = if (letter == null) num else (num + letter)
            Redirect(routes.Course.twoTupleReview(dept, cnum, "content"))
          case (_, Some(courseRegex(dept, num, _, letter, _, section))) =>
            val cnum = if (letter == null) num else (num + letter)
            Redirect(routes.Course.twoTupleReview(dept, cnum, "content"))
          case _ =>
            Search.extractAll(values) match {
              case Search.SearchRequest(_, None, None, List(), None, _, _, _) =>
                Ok(views.html.search_detailed(CrDepartment2005.list))
              case sr =>
                Ok(views.html.search(Search.process(sr)))
            }
        }
      })
  }

  def showReview[T  <: scala.slick.lifted.Column[_]](f: CrReview2008 => T, offerings: List[(String, List[String])])
    (implicit session: DBSession, wt: CanBeQueryCondition[T]) = {
    CrReview2008
    .filter(f)
    .filter(rev => // Only fetch good, published reviews
      rev.revision === 0 &&
      rev.edition <= Global.current_edition
    )
    .sortBy(r =>
      (r.active.desc, r.insufficient.asc, r.edition.desc, r.numRespondents.desc)
    )
    .take(1)
    .list match {
      case course::rest => Ok(views.html.course(course, offerings))
      case Nil => NotFound(<h1>No such course</h1>)
    }
  }

  def twoTupleReview(dept: String, num: String, tab: String) = DBAction { implicit request =>
    val offerings = getOfferings(dept, num)
    showReview(rev => rev.departmentCode === dept && rev.courseNum === num, offerings)
  }

  def threeTupleReview(dept: String, num: String, offering: String, tab: String) = DBAction { implicit request =>
    parse_cis_semester(offering) match {
      case Some(edition) =>
        val offerings = getOfferings(dept, num)
        showReview(rev =>
          rev.departmentCode === dept &&
          rev.courseNum === num &&
          rev.edition === edition, offerings)
      case None =>
        NotFound(<h1>Bad semester: {offering}</h1>)
    }
  }

  def fourTupleReview(dept : String, num : String, offering : String, section : String, tab: String) = DBAction { implicit request =>
    parse_cis_semester(offering) match {
      case Some(edition) =>
        val offerings = getOfferings(dept, num)
        showReview(rev =>
          rev.departmentCode === dept &&
          rev.courseNum === num &&
          rev.edition === edition &&
          rev.section === section, offerings)
      case None =>
        NotFound(<h1>Bad semester: {offering}</h1>)
    }
  }

}

