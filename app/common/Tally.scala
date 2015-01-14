package common

import play.api._
import play.api.mvc._
import play.twirl.api.Html
import scala.xml.Utility.escape
import models.Tables._
import play.api.db.slick.Config.driver.simple._
import play.api.db.slick.Config.driver.simple.{Session => DBSession}
import scala.slick.lifted.CanBeQueryCondition
import java.nio.charset.Charset

/* This is the Scala translation of common/tally.php in the old site */

object Tally {
  
  //def calculateAverages
  
  //def arrayAverage
  
  //def arrayMedian
  
  //def calculateTallyStats
  
  //def makeTallySummary
  
  //def calculateAverageNew
  
  //def calculateAveragesNew
  
  def getTally(review: CrReview2008Row)(implicit session: DBSession): Option[java.sql.Blob] = {
      val tallyList = Tallies.filter(tally => tally.edition === review(1) && tally.departmentCode === review(2) && tally.courseNum === review(3) && tally.section === review(4)).list
      if (tallyList.length < 1) {
          return None
      } else {
          return Some(tallyList.head.xmlData)
      }
  }
  
  //def setTally
  
  //def getTallyQuestionsPath
}
