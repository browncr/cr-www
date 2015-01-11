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

  def searchDepartment(dept: String, sort: String) = DBAction { implicit request =>
    val revs = Search.searchByDepartment(dept).list
    val filtered = Search.filterDups(revs)
    Ok(views.html.search(filtered))
  }

  def showReview(course: List[CrReview2008Row], offerings: List[(String, List[String])]) = {
    course match {
      case course::rest => Ok(views.html.course(course, offerings))
      case Nil => NotFound(<h1>No such course</h1>)
    }
  }

  def twoTupleReview(dept: String, num: String, tab: String) = DBAction { implicit request =>
    val offerings = getOfferings(dept, num)
    showReview(Search.getCourse(dept, num).list, offerings)
  }

  def threeTupleReview(dept: String, num: String, offering: String, tab: String) = DBAction { implicit request =>
    parse_cis_semester(offering) match {
      case Some(edition) =>
        val offerings = getOfferings(dept, num)
        showReview(Search.getCourseByEdition(dept, num, edition).list, offerings)
      case None =>
        NotFound(<h1>Bad semester: {offering}</h1>)
    }
  }

  def fourTupleReview(dept : String, num : String, offering : String, section : String, tab: String) = DBAction { implicit request =>
    parse_cis_semester(offering) match {
      case Some(edition) =>
        val offerings = getOfferings(dept, num)
        showReview(Search.getSpecificCourse(dept, num, edition, section).list, offerings)
      case None =>
        NotFound(<h1>Bad semester: {offering}</h1>)
    }
  }

}

