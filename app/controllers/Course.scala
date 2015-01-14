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

  def showReview(course: List[CrReview2008Row], offerings: List[(String, List[String])], messages: List[String]) = {
    course match {
      case course::rest => Ok(views.html.course(course, offerings, messages))
      case Nil => NotFound(<h1>No such course</h1>)
    }
  }

  def twoTupleReview(dept: String, num: String, tab: String) = DBAction { implicit request =>
    val offerings = getOfferings(dept, num)
    val messages = getMessages(dept, num).list.map(message => message.messageContents)
    showReview(Search.getCourse(dept, num).list, offerings, messages)
  }

  def threeTupleReview(dept: String, num: String, offering: String, tab: String) = DBAction { implicit request =>
    parse_cis_semester(offering) match {
      case Some(edition) =>
        val offerings = getOfferings(dept, num)
        val messages = getMessages(dept, num, offering).list.map(message => message.messageContents)
        showReview(Search.getCourseByEdition(dept, num, edition).list, offerings, messages)
      case None =>
        NotFound(<h1>Bad semester: {offering}</h1>)
    }
  }

  def fourTupleReview(dept : String, num : String, offering : String, section : String, tab: String) = DBAction { implicit request =>
    parse_cis_semester(offering) match {
      case Some(edition) =>
        val offerings = getOfferings(dept, num)
        val messages = getMessages(dept, num, offering, section).list.map(message => message.messageContents)
        showReview(Search.getSpecificCourse(dept, num, edition, section).list, offerings, messages)
      case None =>
        NotFound(<h1>Bad semester: {offering}</h1>)
    }
  }
  
  // Code for displaying demographics graphs. Currently nonfunctional
  /*
  def getXMLFilePath(name: String, edition: String) : Option[Path] = {
    if (Files.exists(Play.getFile("/app/assets/xml/" + edition + "/" + name).toPath())) {
      play.Logger.debug("Found in /app/assets/xml/" + edition + "/" + name)
      return Some(Play.getFile("/app/assets/xml/" + edition + "/" + name).toPath());
    } else if (Files.exists(Play.getFile("/app/assets/xml/all/" + name).toPath())) {
      play.Logger.debug("Found in /app/assets/xml/all/" + name)
      return Some(Play.getFile("/app/assets/xml/all/" + name).toPath());
    } else {
      play.Logger.debug("Not Found")
      return None
    }
  }
  
  def graph(id: Int, graph_type: String, pie_radius: Option[Int], width: Option[Int], height: Option[Int]) = DBAction { implicit request =>
    
    val review = CrReview2008.filter(rev => rev.id === id).list.head
    val tally_xml = getTally(review)
    if (tally_xml.isEmpty) {
      play.Logger.debug("XML not found")
    }
    val xsltPath = getXMLFilePath("graph_xslt/graphs/standalone.xslt", review(1));
    play.Logger.debug(xsltPath.toString)
    val graphLayoutPath = getXMLFilePath("graphs/" + graph_type + ".xml", review(1));
    val tallyColorsPath = getXMLFilePath("tally_colors.xml", review(1));
    
    val outputByteStream = new ByteArrayOutputStream()
    val outputStreamResult = new StreamResult(outputByteStream)
    
    var xsltOptions: Option[String] = pie_radius match {
      case Some(radius) => Some(radius.toString)
      case None => None
    }
    /*
    var rsvgOptions: Option[String] = (width, height) match {
      case (Some(w), Some(h)) => Some(" - w " + w.toString + " - h " + h.toString)
      case (_, _) => None
    }*/
    
    val tFactory = TransformerFactory.newInstance();
    val transformer = tFactory.newTransformer(new StreamSource(xsltPath.get.toString()));
    
    /*
    val documentBuilderFactory = DocumentBuilderFactory.newInstance()
    val documentBuilder = documentBuilderFactory.newDocumentBuilder()
    val xpathFactory = XPathFactory.newInstance()
    val xpath = xpathFactory.newXPath()
    val expressionA = xpath.compile("/")
    val expressionB = xpath.compile("/tally-colors")*/
    
    graphLayoutPath match {
      case(Some(path)) => {
        //val document = documentBuilder.parse(path.toFile())
        //transformer.setParameter("graph-layout", expressionA.evaluate(document, XPathConstants.NODESET) /*"document(\'" + path + "\')/tally-colors"*/)
        transformer.setParameter("graph-layout", /*document.getChildNodes()*/ "document(\'" + path + "\')")
      }
      case(None) =>
    }
    tallyColorsPath match {
      case(Some(path)) => {
        //val document = documentBuilder.parse(path.toFile())
        //transformer.setParameter("tally-colors", expressionB.evaluate(document, XPathConstants.NODESET) /*"document(\'" + path + "\')/tally-colors"*/)
        transformer.setParameter("graph-layout", "document(\'" + path + "\')/tally-colors")
      }
      case(None) =>
    }
    val tallyLength = tally_xml.get.length().toInt
    val tallyStream = new ByteArrayInputStream(tally_xml.get.getBytes(1, tallyLength))
    val outputFile = Paths.get("C:\\Critical Review\\tallyXML.xml")
    Files.write(outputFile, tally_xml.get.getBytes(1, tallyLength))
    //play.Logger.debug(new String(tally_xml.get.getBytes(1, tallyLength)))
    transformer.transform(new StreamSource(tallyStream), outputStreamResult);
    
    Ok(outputByteStream.toByteArray()).as("image/svg+xml")
  }
  */
}

