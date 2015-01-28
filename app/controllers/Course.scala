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

  def searchCourseCode(deptRaw: String, numRaw: String, letterRaw: String, sort: String)(implicit session: DBSession) = {
    matchCourseCode(deptRaw, numRaw, letterRaw) match {
      case (Some(dept), num, None) =>
        Redirect(routes.Course.twoTupleReview(dept, num, "content"))
      case (Some(dept), num, Some(altNum)) =>
        val revs = Search.sortSearch(Search.searchCourses.filter(rev =>
          rev.departmentCode === dept &&
          (rev.courseNum === num || rev.courseNum === altNum)
        )).list
        val filtered = Search.filterDups(revs)
        Ok(views.html.search(filtered))
      case (None, _, _) =>
        NotFound(<h1>There is no department named {deptRaw}</h1>)
    }
  }

  def search(sort: String) = DBAction { implicit request =>
    Search.form.bindFromRequest.fold(
      formWithErrors => BadRequest(<h1>Your search was bad: {formWithErrors}</h1>),
      { values =>
        // The first two cases check to see if the user gave a specific
        // course code. Since this is the most specific way to search for a
        // course, redirect them if the course exists. Otherwise, error out.
        (values.courseCode, values.quickSearch) match {
          case (Some(courseSearchRegex(dept, num, letter)), _) =>
            searchCourseCode(dept, num, letter, sort)
          case (_, Some(courseSearchRegex(dept, num, letter))) =>
            searchCourseCode(dept, num, letter, sort)
          case _ =>
            Search.extractAll(values) match {
              case Search.SearchRequest(_, None, None, List(), None, _, _, _) =>
                Ok(views.html.search_detailed())
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

  def showReview(course: List[CrReview2008Row], offerings: List[(String, List[String])])(implicit session: DBSession) = {
    course match {
      case course::rest =>
        val dept = course(2)
        val edition = course(1)
        val section = course(4)
        val num = course(3)
        val messages = getMessages(dept, num, edition, section).list
        Ok(views.html.course(course, offerings, messages))
      case Nil => NotFound(<h1>No such course</h1>)
    }
  }

  def twoTupleReview(dept: String, num: String, tab: String) = DBAction { implicit request =>
    val offerings = getOfferings(dept, num)
    val edition = Global.current_edition
    val section = "1"
    val messages = getMessages(dept, num, edition, section).list
    showReview(Search.getCourse(dept, num).list, offerings, messages)
  }

  def threeTupleReview(dept: String, num: String, offering: String, tab: String) = DBAction { implicit request =>
    parse_cis_semester(offering) match {
      case Some(edition) =>
        val offerings = getOfferings(dept, num)
        val section = "1"
        val messages = getMessages(dept, num, offering, section).list
        showReview(Search.getCourseByEdition(dept, num, edition).list, offerings, messages)
      case None =>
        NotFound(<h1>Bad semester: {offering}</h1>)
    }
  }

  def fourTupleReview(dept : String, num : String, offering : String, section : String, tab: String) = DBAction { implicit request =>
    parse_cis_semester(offering) match {
      case Some(edition) =>
        val offerings = getOfferings(dept, num)
        val messages = getMessages(dept, num, offering, section).list
        showReview(Search.getSpecificCourse(dept, num, edition, section).list, offerings, messages)
      case None =>
        NotFound(<h1>Bad semester: {offering}</h1>)
    }
  }
}

