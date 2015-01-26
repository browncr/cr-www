package models

import play.api.db.slick.Config.driver
import play.api.db.slick.Config.driver.simple._

// AUTO-GENERATED Slick data model
/** Stand-alone Slick data model for immediate use */

/** Slick data model trait for extension, choice of backend or usage in the cake pattern. (Make sure to initialize this late.) */
object Tables {
  import scala.slick.model.ForeignKeyAction
  import scala.slick.collection.heterogenous._
  import scala.slick.collection.heterogenous.syntax._
  // NOTE: GetResult mappers for plain SQL are only generated for tables where Slick knows how to map the types of all columns.
  import scala.slick.jdbc.{GetResult => GR}
  
  /** DDL for all tables. Call .create to execute. */
  lazy val ddl = CrComment2005.ddl ++ CrDepartment2005.ddl ++ CrEdition2005.ddl ++ CrProfessor2008.ddl ++
    CrQuotes2005.ddl ++ CrReview2005.ddl ++ CrReview2008.ddl ++ CrReviewHasProfessor2008.ddl ++ CrReviewMessages.ddl ++
    CrSurveyCodes.ddl ++ CrSurveySubmissions.ddl ++ CrUserBios2005.ddl ++ CrUserLevel2005.ddl ++ CrUsers2005.ddl ++
    MochaCourses.ddl ++ StaffPhotos.ddl ++ StaffVotes.ddl ++ Tallies.ddl

  /** Entity class storing rows of table CrComment2005
   *  @param id Database column ID DBType(INT), AutoInc, PrimaryKey
   *  @param reviewid Database column REVIEWID DBType(INT), Default(0)
   *  @param inactive Database column INACTIVE DBType(TINYINT), Default(0)
   *  @param userid Database column USERID DBType(INT), Default(0)
   *  @param time Database column TIME DBType(INT), Default(0)
   *  @param comment Database column COMMENT DBType(TEXT), Length(65535,true) */
  case class CrComment2005Row(id: Int, reviewid: Int = 0, inactive: Byte = 0, userid: Int = 0, time: Int = 0, comment: String)
  /** GetResult implicit for fetching CrComment2005Row objects using plain SQL queries */
  implicit def GetResultCrComment2005Row(implicit e0: GR[Int], e1: GR[Byte], e2: GR[String]): GR[CrComment2005Row] = GR{
    prs => import prs._
    CrComment2005Row.tupled((<<[Int], <<[Int], <<[Byte], <<[Int], <<[Int], <<[String]))
  }
  /** Table description of table cr_comment_2005. Objects of this class serve as prototypes for rows in queries. */
  class CrComment2005(_tableTag: Tag) extends Table[CrComment2005Row](_tableTag, "cr_comment_2005") {
    def * = (id, reviewid, inactive, userid, time, comment) <> (CrComment2005Row.tupled, CrComment2005Row.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (id.?, reviewid.?, inactive.?, userid.?, time.?, comment.?).shaped.<>({r=>import r._; _1.map(_=>
      CrComment2005Row.tupled((_1.get, _2.get, _3.get, _4.get, _5.get, _6.get)))}, (_:Any) =>
      throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column ID DBType(INT), AutoInc, PrimaryKey */
    val id: Column[Int] = column[Int]("ID", O.AutoInc, O.PrimaryKey)
    /** Database column REVIEWID DBType(INT), Default(0) */
    val reviewid: Column[Int] = column[Int]("REVIEWID", O.Default(0))
    /** Database column INACTIVE DBType(TINYINT), Default(0) */
    val inactive: Column[Byte] = column[Byte]("INACTIVE", O.Default(0))
    /** Database column USERID DBType(INT), Default(0) */
    val userid: Column[Int] = column[Int]("USERID", O.Default(0))
    /** Database column TIME DBType(INT), Default(0) */
    val time: Column[Int] = column[Int]("TIME", O.Default(0))
    /** Database column COMMENT DBType(TEXT), Length(65535,true) */
    val comment: Column[String] = column[String]("COMMENT", O.Length(65535,varying=true))
  }
  /** Collection-like TableQuery object for table CrComment2005 */
  lazy val CrComment2005 = new TableQuery(tag => new CrComment2005(tag))
  
  /** Entity class storing rows of table CrDepartment2005
   *  @param shortCode Database column short_code DBType(VARCHAR), Length(2,true), Default(None)
   *  @param longCode Database column long_code DBType(VARCHAR), Length(50,true), Default()
   *  @param bannerCode Database column banner_code DBType(VARCHAR), PrimaryKey, Length(4,true)
   *  @param name Database column name DBType(VARCHAR), Length(255,true), Default()
   *  @param registrarName Database column registrar_name DBType(VARCHAR), Length(255,true) */
  case class CrDepartment2005Row(shortCode: Option[String] = None, longCode: String = "", bannerCode: String,
                                 name: String = "", registrarName: String)
  /** GetResult implicit for fetching CrDepartment2005Row objects using plain SQL queries */
  implicit def GetResultCrDepartment2005Row(implicit e0: GR[Option[String]], e1: GR[String]): GR[CrDepartment2005Row] = GR{
    prs => import prs._
    CrDepartment2005Row.tupled((<<?[String], <<[String], <<[String], <<[String], <<[String]))
  }
  /** Table description of table cr_department_2005. Objects of this class serve as prototypes for rows in queries. */
  class CrDepartment2005(_tableTag: Tag) extends Table[CrDepartment2005Row](_tableTag, "cr_department_2005") {
    def * = (shortCode, longCode, bannerCode, name, registrarName) <> (CrDepartment2005Row.tupled, CrDepartment2005Row.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (shortCode, longCode.?, bannerCode.?, name.?, registrarName.?).shaped.<>({r=>import r._; _2.map(_=>
      CrDepartment2005Row.tupled((_1, _2.get, _3.get, _4.get, _5.get)))}, (_:Any) =>
      throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column short_code DBType(VARCHAR), Length(2,true), Default(None) */
    val shortCode: Column[Option[String]] = column[Option[String]]("short_code", O.Length(2,varying=true), O.Default(None))
    /** Database column long_code DBType(VARCHAR), Length(50,true), Default() */
    val longCode: Column[String] = column[String]("long_code", O.Length(50,varying=true), O.Default(""))
    /** Database column banner_code DBType(VARCHAR), PrimaryKey, Length(4,true) */
    val bannerCode: Column[String] = column[String]("banner_code", O.PrimaryKey, O.Length(4,varying=true))
    /** Database column name DBType(VARCHAR), Length(255,true), Default() */
    val name: Column[String] = column[String]("name", O.Length(255,varying=true), O.Default(""))
    /** Database column registrar_name DBType(VARCHAR), Length(255,true) */
    val registrarName: Column[String] = column[String]("registrar_name", O.Length(255,varying=true))
    
    /** Uniqueness Index over (shortCode) (database name short_code) */
    val index1 = index("short_code", shortCode, unique=true)
  }
  /** Collection-like TableQuery object for table CrDepartment2005 */
  lazy val CrDepartment2005 = new TableQuery(tag => new CrDepartment2005(tag))
  
  /** Entity class storing rows of table CrEdition2005
   *  @param id Database column ID DBType(INT), AutoInc
   *  @param hidden Database column HIDDEN DBType(BIT), Default(false)
   *  @param edition Database column EDITION DBType(VARCHAR), Length(15,true), Default()
   *  @param mochaId Database column MOCHA_ID DBType(INT) */
  case class CrEdition2005Row(id: Int, hidden: Boolean = false, edition: String = "", mochaId: Int)
  /** GetResult implicit for fetching CrEdition2005Row objects using plain SQL queries */
  implicit def GetResultCrEdition2005Row(implicit e0: GR[Int], e1: GR[Boolean], e2: GR[String]): GR[CrEdition2005Row] = GR{
    prs => import prs._
    CrEdition2005Row.tupled((<<[Int], <<[Boolean], <<[String], <<[Int]))
  }
  /** Table description of table cr_edition_2005. Objects of this class serve as prototypes for rows in queries. */
  class CrEdition2005(_tableTag: Tag) extends Table[CrEdition2005Row](_tableTag, "cr_edition_2005") {
    def * = (id, hidden, edition, mochaId) <> (CrEdition2005Row.tupled, CrEdition2005Row.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (id.?, hidden.?, edition.?, mochaId.?).shaped.<>({r=>import r._; _1.map(_=>
      CrEdition2005Row.tupled((_1.get, _2.get, _3.get, _4.get)))}, (_:Any) =>
      throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column ID DBType(INT), AutoInc */
    val id: Column[Int] = column[Int]("ID", O.AutoInc)
    /** Database column HIDDEN DBType(BIT), Default(false) */
    val hidden: Column[Boolean] = column[Boolean]("HIDDEN", O.Default(false))
    /** Database column EDITION DBType(VARCHAR), Length(15,true), Default() */
    val edition: Column[String] = column[String]("EDITION", O.Length(15,varying=true), O.Default(""))
    /** Database column MOCHA_ID DBType(INT) */
    val mochaId: Column[Int] = column[Int]("MOCHA_ID")
    
    /** Uniqueness Index over (edition) (database name EDITION) */
    val index1 = index("EDITION", edition, unique=true)
    /** Uniqueness Index over (id) (database name ID) */
    val index2 = index("ID", id, unique=true)
  }
  /** Collection-like TableQuery object for table CrEdition2005 */
  lazy val CrEdition2005 = new TableQuery(tag => new CrEdition2005(tag))
  
  /** Entity class storing rows of table CrProfessor2008
   *  @param id Database column id DBType(INT), AutoInc, PrimaryKey
   *  @param name Database column name DBType(VARCHAR), Length(128,true)
   *  @param first Database column first DBType(VARCHAR), Length(50,true), Default(None)
   *  @param middle Database column middle DBType(VARCHAR), Length(50,true), Default(None)
   *  @param last Database column last DBType(VARCHAR), Length(50,true), Default(None)
   *  @param professorAvg Database column professor_avg DBType(FLOAT) */
  case class CrProfessor2008Row(id: Int, name: String, first: Option[String] = None, middle: Option[String] = None,
                                last: Option[String] = None, professorAvg: Float)
  /** GetResult implicit for fetching CrProfessor2008Row objects using plain SQL queries */
  implicit def GetResultCrProfessor2008Row(implicit e0: GR[Int], e1: GR[String], e2: GR[Option[String]],
                                           e3: GR[Float]): GR[CrProfessor2008Row] = GR{
    prs => import prs._
    CrProfessor2008Row.tupled((<<[Int], <<[String], <<?[String], <<?[String], <<?[String], <<[Float]))
  }
  /** Table description of table cr_professor_2008. Objects of this class serve as prototypes for rows in queries. */
  class CrProfessor2008(_tableTag: Tag) extends Table[CrProfessor2008Row](_tableTag, "cr_professor_2008") {
    def * = (id, name, first, middle, last, professorAvg) <> (CrProfessor2008Row.tupled, CrProfessor2008Row.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (id.?, name.?, first, middle, last, professorAvg.?).shaped.<>({r=>import r._; _1.map(_=>
      CrProfessor2008Row.tupled((_1.get, _2.get, _3, _4, _5, _6.get)))}, (_:Any) =>
      throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column id DBType(INT), AutoInc, PrimaryKey */
    val id: Column[Int] = column[Int]("id", O.AutoInc, O.PrimaryKey)
    /** Database column name DBType(VARCHAR), Length(128,true) */
    val name: Column[String] = column[String]("name", O.Length(128,varying=true))
    /** Database column first DBType(VARCHAR), Length(50,true), Default(None) */
    val first: Column[Option[String]] = column[Option[String]]("first", O.Length(50,varying=true), O.Default(None))
    /** Database column middle DBType(VARCHAR), Length(50,true), Default(None) */
    val middle: Column[Option[String]] = column[Option[String]]("middle", O.Length(50,varying=true), O.Default(None))
    /** Database column last DBType(VARCHAR), Length(50,true), Default(None) */
    val last: Column[Option[String]] = column[Option[String]]("last", O.Length(50,varying=true), O.Default(None))
    /** Database column professor_avg DBType(FLOAT) */
    val professorAvg: Column[Float] = column[Float]("professor_avg")
  }
  /** Collection-like TableQuery object for table CrProfessor2008 */
  lazy val CrProfessor2008 = new TableQuery(tag => new CrProfessor2008(tag))
  
  /** Entity class storing rows of table CrQuotes2005
   *  @param quoteId Database column QUOTE_ID DBType(INT), AutoInc, PrimaryKey
   *  @param edition Database column EDITION DBType(CHAR), Length(16,false)
   *  @param userId Database column USER_ID DBType(INT)
   *  @param questId Database column QUEST_ID DBType(INT)
   *  @param time Database column TIME DBType(INT)
   *  @param quote Database column QUOTE DBType(TEXT), Length(65535,true)
   *  @param published Database column PUBLISHED DBType(BIT), Default(false) */
  case class CrQuotes2005Row(quoteId: Int, edition: String, userId: Int, questId: Int, time: Int,
                             quote: String, published: Boolean = false)
  /** GetResult implicit for fetching CrQuotes2005Row objects using plain SQL queries */
  implicit def GetResultCrQuotes2005Row(implicit e0: GR[Int], e1: GR[String], e2: GR[Boolean]): GR[CrQuotes2005Row] = GR{
    prs => import prs._
    CrQuotes2005Row.tupled((<<[Int], <<[String], <<[Int], <<[Int], <<[Int], <<[String], <<[Boolean]))
  }
  /** Table description of table cr_quotes_2005. Objects of this class serve as prototypes for rows in queries. */
  class CrQuotes2005(_tableTag: Tag) extends Table[CrQuotes2005Row](_tableTag, "cr_quotes_2005") {
    def * = (quoteId, edition, userId, questId, time, quote, published) <> (CrQuotes2005Row.tupled, CrQuotes2005Row.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (quoteId.?, edition.?, userId.?, questId.?, time.?, quote.?, published.?).shaped.<>({r=>
      import r._; _1.map(_=> CrQuotes2005Row.tupled((_1.get, _2.get, _3.get, _4.get, _5.get, _6.get, _7.get)))},
    (_:Any) =>  throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column QUOTE_ID DBType(INT), AutoInc, PrimaryKey */
    val quoteId: Column[Int] = column[Int]("QUOTE_ID", O.AutoInc, O.PrimaryKey)
    /** Database column EDITION DBType(CHAR), Length(16,false) */
    val edition: Column[String] = column[String]("EDITION", O.Length(16,varying=false))
    /** Database column USER_ID DBType(INT) */
    val userId: Column[Int] = column[Int]("USER_ID")
    /** Database column QUEST_ID DBType(INT) */
    val questId: Column[Int] = column[Int]("QUEST_ID")
    /** Database column TIME DBType(INT) */
    val time: Column[Int] = column[Int]("TIME")
    /** Database column QUOTE DBType(TEXT), Length(65535,true) */
    val quote: Column[String] = column[String]("QUOTE", O.Length(65535,varying=true))
    /** Database column PUBLISHED DBType(BIT), Default(false) */
    val published: Column[Boolean] = column[Boolean]("PUBLISHED", O.Default(false))
  }
  /** Collection-like TableQuery object for table CrQuotes2005 */
  lazy val CrQuotes2005 = new TableQuery(tag => new CrQuotes2005(tag))
  
  /** Row type of table CrReview2005 */
  type CrReview2005Row = HCons[Int,HCons[String,HCons[Int,HCons[Int,HCons[Int,HCons[String,HCons[String,HCons[String,
    HCons[Short,HCons[String,HCons[String,HCons[String,HCons[String,HCons[Short,HCons[String,HCons[Short,HCons[Short,
      HCons[Short,HCons[Short,HCons[Short,HCons[Short,HCons[Short,HCons[Short,HCons[Short,HCons[String,HCons[String,
        HCons[String,HCons[String,HCons[java.sql.Blob,HCons[String,HCons[String,HNil]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
  /** Constructor for CrReview2005Row providing default values if available in the database schema. */
  def CrReview2005Row(id: Int, inactive: String = "", version: Int = 0, time: Int = 0, writerId: Int = 0,
                      edition: String = "", courseCode: String = "0", departmentCode: String = "", courseNum: Short = 0,
                      section: String = "", professor: String = "", title: String = "", department: String = "",
                      numRespondents: Short = 0, courseformat: String = "", frosh: Short = 0, soph: Short = 0,
                      jun: Short = 0, sen: Short = 0, grad: Short = 0, total: Short = 0, concs: Short = 0,
                      nonconcs: Short = 0, dunno: Short = 0, profavg: String = "", courseavg: String = "",
                      reviewContents: String, tally: String, tallyGraphic: java.sql.Blob, tallyFiletype: String = "",
                      editors: String): CrReview2005Row = {
    id :: inactive :: version :: time :: writerId :: edition :: courseCode :: departmentCode :: courseNum ::
      section :: professor :: title :: department :: numRespondents :: courseformat :: frosh :: soph :: jun :: sen ::
      grad :: total :: concs :: nonconcs :: dunno :: profavg :: courseavg :: reviewContents :: tally :: tallyGraphic ::
      tallyFiletype :: editors :: HNil
  }
  /** GetResult implicit for fetching CrReview2005Row objects using plain SQL queries */
  implicit def GetResultCrReview2005Row(implicit e0: GR[Int], e1: GR[String], e2: GR[Short],
                                        e3: GR[java.sql.Blob]): GR[CrReview2005Row] = GR{
    prs => import prs._
    <<[Int] :: <<[String] :: <<[Int] :: <<[Int] :: <<[Int] :: <<[String] :: <<[String] :: <<[String] :: <<[Short] ::
      <<[String] :: <<[String] :: <<[String] :: <<[String] :: <<[Short] :: <<[String] :: <<[Short] :: <<[Short] ::
      <<[Short] :: <<[Short] :: <<[Short] :: <<[Short] :: <<[Short] :: <<[Short] :: <<[Short] :: <<[String] ::
      <<[String] :: <<[String] :: <<[String] :: <<[java.sql.Blob] :: <<[String] :: <<[String] :: HNil
  }
  /** Table description of table cr_review_2005. Objects of this class serve as prototypes for rows in queries. */
  class CrReview2005(_tableTag: Tag) extends Table[CrReview2005Row](_tableTag, "cr_review_2005") {
    def * = id :: inactive :: version :: time :: writerId :: edition :: courseCode :: departmentCode :: courseNum ::
      section :: professor :: title :: department :: numRespondents :: courseformat :: frosh :: soph :: jun :: sen ::
      grad :: total :: concs :: nonconcs :: dunno :: profavg :: courseavg :: reviewContents :: tally :: tallyGraphic ::
      tallyFiletype :: editors :: HNil
    
    /** Database column ID DBType(INT), AutoInc */
    val id: Column[Int] = column[Int]("ID", O.AutoInc)
    /** Database column INACTIVE DBType(CHAR), Length(1,false), Default() */
    val inactive: Column[String] = column[String]("INACTIVE", O.Length(1,varying=false), O.Default(""))
    /** Database column VERSION DBType(INT), Default(0) */
    val version: Column[Int] = column[Int]("VERSION", O.Default(0))
    /** Database column TIME DBType(INT), Default(0) */
    val time: Column[Int] = column[Int]("TIME", O.Default(0))
    /** Database column WRITER_ID DBType(INT), Default(0) */
    val writerId: Column[Int] = column[Int]("WRITER_ID", O.Default(0))
    /** Database column EDITION DBType(VARCHAR), Length(15,true), Default() */
    val edition: Column[String] = column[String]("EDITION", O.Length(15,varying=true), O.Default(""))
    /** Database column COURSE_CODE DBType(VARCHAR), Length(15,true), Default(0) */
    val courseCode: Column[String] = column[String]("COURSE_CODE", O.Length(15,varying=true), O.Default("0"))
    /** Database column DEPARTMENT_CODE DBType(VARCHAR), Length(7,true), Default() */
    val departmentCode: Column[String] = column[String]("DEPARTMENT_CODE", O.Length(7,varying=true), O.Default(""))
    /** Database column COURSE_NUM DBType(SMALLINT), Default(0) */
    val courseNum: Column[Short] = column[Short]("COURSE_NUM", O.Default(0))
    /** Database column SECTION DBType(VARCHAR), Length(31,true), Default() */
    val section: Column[String] = column[String]("SECTION", O.Length(31,varying=true), O.Default(""))
    /** Database column PROFESSOR DBType(VARCHAR), Length(127,true), Default() */
    val professor: Column[String] = column[String]("PROFESSOR", O.Length(127,varying=true), O.Default(""))
    /** Database column TITLE DBType(VARCHAR), Length(127,true), Default() */
    val title: Column[String] = column[String]("TITLE", O.Length(127,varying=true), O.Default(""))
    /** Database column DEPARTMENT DBType(VARCHAR), Length(63,true), Default() */
    val department: Column[String] = column[String]("DEPARTMENT", O.Length(63,varying=true), O.Default(""))
    /** Database column NUM_RESPONDENTS DBType(SMALLINT), Default(0) */
    val numRespondents: Column[Short] = column[Short]("NUM_RESPONDENTS", O.Default(0))
    /** Database column COURSEFORMAT DBType(VARCHAR), Length(31,true), Default() */
    val courseformat: Column[String] = column[String]("COURSEFORMAT", O.Length(31,varying=true), O.Default(""))
    /** Database column FROSH DBType(SMALLINT), Default(0) */
    val frosh: Column[Short] = column[Short]("FROSH", O.Default(0))
    /** Database column SOPH DBType(SMALLINT), Default(0) */
    val soph: Column[Short] = column[Short]("SOPH", O.Default(0))
    /** Database column JUN DBType(SMALLINT), Default(0) */
    val jun: Column[Short] = column[Short]("JUN", O.Default(0))
    /** Database column SEN DBType(SMALLINT), Default(0) */
    val sen: Column[Short] = column[Short]("SEN", O.Default(0))
    /** Database column GRAD DBType(SMALLINT), Default(0) */
    val grad: Column[Short] = column[Short]("GRAD", O.Default(0))
    /** Database column TOTAL DBType(SMALLINT), Default(0) */
    val total: Column[Short] = column[Short]("TOTAL", O.Default(0))
    /** Database column CONCS DBType(SMALLINT), Default(0) */
    val concs: Column[Short] = column[Short]("CONCS", O.Default(0))
    /** Database column NONCONCS DBType(SMALLINT), Default(0) */
    val nonconcs: Column[Short] = column[Short]("NONCONCS", O.Default(0))
    /** Database column DUNNO DBType(SMALLINT), Default(0) */
    val dunno: Column[Short] = column[Short]("DUNNO", O.Default(0))
    /** Database column PROFAVG DBType(VARCHAR), Length(4,true), Default() */
    val profavg: Column[String] = column[String]("PROFAVG", O.Length(4,varying=true), O.Default(""))
    /** Database column COURSEAVG DBType(VARCHAR), Length(4,true), Default() */
    val courseavg: Column[String] = column[String]("COURSEAVG", O.Length(4,varying=true), O.Default(""))
    /** Database column REVIEW_CONTENTS DBType(TEXT), Length(65535,true) */
    val reviewContents: Column[String] = column[String]("REVIEW_CONTENTS", O.Length(65535,varying=true))
    /** Database column TALLY DBType(TEXT), Length(65535,true) */
    val tally: Column[String] = column[String]("TALLY", O.Length(65535,varying=true))
    /** Database column TALLY_GRAPHIC DBType(BLOB) */
    val tallyGraphic: Column[java.sql.Blob] = column[java.sql.Blob]("TALLY_GRAPHIC")
    /** Database column TALLY_FILETYPE DBType(VARCHAR), Length(3,true), Default() */
    val tallyFiletype: Column[String] = column[String]("TALLY_FILETYPE", O.Length(3,varying=true), O.Default(""))
    /** Database column EDITORS DBType(VARCHAR), Length(255,true) */
    val editors: Column[String] = column[String]("EDITORS", O.Length(255,varying=true))
    
    /** Index over (id) (database name ID) */
    val index1 = index("ID", id :: HNil)
    /** Index over (professor) (database name PROFESSOR) */
    val index2 = index("PROFESSOR", professor :: HNil)
    /** Index over (reviewContents) (database name REVIEW_CONTENTS) */
    val index3 = index("REVIEW_CONTENTS", reviewContents :: HNil)
    /** Index over (title) (database name TITLE) */
    val index4 = index("TITLE", title :: HNil)
  }
  /** Collection-like TableQuery object for table CrReview2005 */
  lazy val CrReview2005 = new TableQuery(tag => new CrReview2005(tag))
  
  /** Row type of table CrReview2008 */
  type CrReview2008Row = HCons[Int,HCons[String,HCons[String,HCons[String,HCons[String,HCons[Int,HCons[Int,HCons[Int,
    HCons[Int,HCons[Int,HCons[String,HCons[String,HCons[String,HCons[Int,HCons[Short,HCons[Byte,HCons[String,
      HCons[Option[Boolean],HCons[Short,HCons[Short,HCons[Short,HCons[Short,HCons[Short,HCons[Short,HCons[Short,
        HCons[Short,HCons[Short,HCons[Float,HCons[Float,HCons[Option[Float],HCons[Option[Float],HCons[Option[Float],
          HCons[Option[Float],HCons[String,HCons[String,HCons[String,HCons[String,HCons[String,HCons[java.sql.Blob,
            HCons[String,HCons[java.sql.Timestamp,HCons[Int,HCons[Int,HCons[Int,HCons[Option[Int],HCons[Boolean,
              HCons[Int,HCons[Boolean,HCons[Boolean,HCons[Boolean,HCons[Option[java.sql.Date],HCons[String,
                HCons[String,HCons[Int,HCons[String,HCons[Int,HCons[Int,HCons[String,HCons[Boolean,
                  HNil]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
  /** Constructor for CrReview2008Row providing default values if available in the database schema. */
  def CrReview2008Row(id: Int, edition: String, departmentCode: String, courseNum: String, section: String,
                      revision: Int = 0, writerId: Int = -1, editorId: Int = -1, execId1: Int = -1, execId2: Int = -1,
                      professor: String, title: String, academicDepartment: String, crn: Int, numRespondents: Short,
                      courseFormat: Byte, courseformat: String, observedReading: Option[Boolean] = None, frosh: Short,
                      soph: Short, jun: Short, sen: Short, grad: Short, total: Short, concs: Short, nonconcs: Short,
                      dunno: Short, profavg: Float, courseavg: Float, minhoursMean: Option[Float] = None,
                      minhoursMedian: Option[Float] = None, maxhoursMean: Option[Float] = None,
                      maxhoursMedian: Option[Float] = None, reviewContents: String, editors: String,
                      editorComments: String, otherCourses: String, tally: String, tallyGraphic: java.sql.Blob,
                      tallyFiletype: String, time: java.sql.Timestamp, modifier: Int = -1, editDistance: Int = 0,
                      oldid: Int, barcodeId: Option[Int] = None, active: Boolean = false, views: Int = 0,
                      insufficient: Boolean = false, flagged: Boolean = false, isOnStaffBallot: Boolean = false,
                      featuredDate: Option[java.sql.Date] = None, syllabus: String, website: String, printEditing: Int,
                      archiveBox: String, profNameStatus: Int = 2, profFixupId: Int = 0, surveyPrinter: String,
                      surveySpooled: Boolean = false): CrReview2008Row = {
    id :: edition :: departmentCode :: courseNum :: section :: revision :: writerId :: editorId :: execId1 ::
      execId2 :: professor :: title :: academicDepartment :: crn :: numRespondents :: courseFormat :: courseformat ::
      observedReading :: frosh :: soph :: jun :: sen :: grad :: total :: concs :: nonconcs :: dunno :: profavg ::
      courseavg :: minhoursMean :: minhoursMedian :: maxhoursMean :: maxhoursMedian :: reviewContents :: editors ::
      editorComments :: otherCourses :: tally :: tallyGraphic :: tallyFiletype :: time :: modifier :: editDistance ::
      oldid :: barcodeId :: active :: views :: insufficient :: flagged :: isOnStaffBallot :: featuredDate ::
      syllabus :: website :: printEditing :: archiveBox :: profNameStatus :: profFixupId :: surveyPrinter ::
      surveySpooled :: HNil
  }
  /** GetResult implicit for fetching CrReview2008Row objects using plain SQL queries */
  implicit def GetResultCrReview2008Row(implicit e0: GR[Int], e1: GR[String], e2: GR[Short], e3: GR[Byte],
                                        e4: GR[Option[Boolean]], e5: GR[Float], e6: GR[Option[Float]],
                                        e7: GR[java.sql.Blob], e8: GR[java.sql.Timestamp], e9: GR[Option[Int]],
                                        e10: GR[Boolean], e11: GR[Option[java.sql.Date]]): GR[CrReview2008Row] = GR{
    prs => import prs._
    <<[Int] :: <<[String] :: <<[String] :: <<[String] :: <<[String] :: <<[Int] :: <<[Int] :: <<[Int] :: <<[Int] ::
      <<[Int] :: <<[String] :: <<[String] :: <<[String] :: <<[Int] :: <<[Short] :: <<[Byte] :: <<[String] ::
      <<?[Boolean] :: <<[Short] :: <<[Short] :: <<[Short] :: <<[Short] :: <<[Short] :: <<[Short] :: <<[Short] ::
      <<[Short] :: <<[Short] :: <<[Float] :: <<[Float] :: <<?[Float] :: <<?[Float] :: <<?[Float] :: <<?[Float] ::
      <<[String] :: <<[String] :: <<[String] :: <<[String] :: <<[String] :: <<[java.sql.Blob] :: <<[String] ::
      <<[java.sql.Timestamp] :: <<[Int] :: <<[Int] :: <<[Int] :: <<?[Int] :: <<[Boolean] :: <<[Int] :: <<[Boolean] ::
      <<[Boolean] :: <<[Boolean] :: <<?[java.sql.Date] :: <<[String] :: <<[String] :: <<[Int] :: <<[String] ::
      <<[Int] :: <<[Int] :: <<[String] :: <<[Boolean] :: HNil
  }
  /** Table description of table cr_review_2008. Objects of this class serve as prototypes for rows in queries. */
  class CrReview2008(_tableTag: Tag) extends Table[CrReview2008Row](_tableTag, "cr_review_2008") {
    def * = id :: edition :: departmentCode :: courseNum :: section :: revision :: writerId :: editorId :: execId1 ::
      execId2 :: professor :: title :: academicDepartment :: crn :: numRespondents :: courseFormat :: courseformat ::
      observedReading :: frosh :: soph :: jun :: sen :: grad :: total :: concs :: nonconcs :: dunno :: profavg ::
      courseavg :: minhoursMean :: minhoursMedian :: maxhoursMean :: maxhoursMedian :: reviewContents :: editors ::
      editorComments :: otherCourses :: tally :: tallyGraphic :: tallyFiletype :: time :: modifier :: editDistance ::
      oldid :: barcodeId :: active :: views :: insufficient :: flagged :: isOnStaffBallot :: featuredDate :: syllabus ::
      website :: printEditing :: archiveBox :: profNameStatus :: profFixupId :: surveyPrinter :: surveySpooled :: HNil
    
    /** Database column id DBType(INT), AutoInc, PrimaryKey */
    val id: Column[Int] = column[Int]("id", O.AutoInc, O.PrimaryKey)
    /** Database column edition DBType(CHAR), Length(16,false) */
    val edition: Column[String] = column[String]("edition", O.Length(16,varying=false))
    /** Database column department_code DBType(CHAR), Length(4,false) */
    val departmentCode: Column[String] = column[String]("department_code", O.Length(4,varying=false))
    /** Database column course_num DBType(CHAR), Length(16,false) */
    val courseNum: Column[String] = column[String]("course_num", O.Length(16,varying=false))
    /** Database column section DBType(CHAR), Length(8,false) */
    val section: Column[String] = column[String]("section", O.Length(8,varying=false))
    /** Database column revision DBType(INT), Default(0) */
    val revision: Column[Int] = column[Int]("revision", O.Default(0))
    /** Database column writer_id DBType(INT), Default(-1) */
    val writerId: Column[Int] = column[Int]("writer_id", O.Default(-1))
    /** Database column editor_id DBType(INT), Default(-1) */
    val editorId: Column[Int] = column[Int]("editor_id", O.Default(-1))
    /** Database column exec_id1 DBType(INT), Default(-1) */
    val execId1: Column[Int] = column[Int]("exec_id1", O.Default(-1))
    /** Database column exec_id2 DBType(INT), Default(-1) */
    val execId2: Column[Int] = column[Int]("exec_id2", O.Default(-1))
    /** Database column professor DBType(VARCHAR), Length(128,true) */
    val professor: Column[String] = column[String]("professor", O.Length(128,varying=true))
    /** Database column title DBType(VARCHAR), Length(128,true) */
    val title: Column[String] = column[String]("title", O.Length(128,varying=true))
    /** Database column academic_department DBType(VARCHAR), Length(255,true) */
    val academicDepartment: Column[String] = column[String]("academic_department", O.Length(255,varying=true))
    /** Database column crn DBType(INT) */
    val crn: Column[Int] = column[Int]("crn")
    /** Database column num_respondents DBType(SMALLINT) */
    val numRespondents: Column[Short] = column[Short]("num_respondents")
    /** Database column course_format DBType(TINYINT) */
    val courseFormat: Column[Byte] = column[Byte]("course_format")
    /** Database column courseformat DBType(VARCHAR), Length(32,true) */
    val courseformat: Column[String] = column[String]("courseformat", O.Length(32,varying=true))
    /** Database column observed_reading DBType(BIT), Default(None) */
    val observedReading: Column[Option[Boolean]] = column[Option[Boolean]]("observed_reading", O.Default(None))
    /** Database column frosh DBType(SMALLINT) */
    val frosh: Column[Short] = column[Short]("frosh")
    /** Database column soph DBType(SMALLINT) */
    val soph: Column[Short] = column[Short]("soph")
    /** Database column jun DBType(SMALLINT) */
    val jun: Column[Short] = column[Short]("jun")
    /** Database column sen DBType(SMALLINT) */
    val sen: Column[Short] = column[Short]("sen")
    /** Database column grad DBType(SMALLINT) */
    val grad: Column[Short] = column[Short]("grad")
    /** Database column total DBType(SMALLINT) */
    val total: Column[Short] = column[Short]("total")
    /** Database column concs DBType(SMALLINT) */
    val concs: Column[Short] = column[Short]("concs")
    /** Database column nonconcs DBType(SMALLINT) */
    val nonconcs: Column[Short] = column[Short]("nonconcs")
    /** Database column dunno DBType(SMALLINT) */
    val dunno: Column[Short] = column[Short]("dunno")
    /** Database column profavg DBType(FLOAT) */
    val profavg: Column[Float] = column[Float]("profavg")
    /** Database column courseavg DBType(FLOAT) */
    val courseavg: Column[Float] = column[Float]("courseavg")
    /** Database column minhours_mean DBType(FLOAT), Default(None) */
    val minhoursMean: Column[Option[Float]] = column[Option[Float]]("minhours_mean", O.Default(None))
    /** Database column minhours_median DBType(FLOAT), Default(None) */
    val minhoursMedian: Column[Option[Float]] = column[Option[Float]]("minhours_median", O.Default(None))
    /** Database column maxhours_mean DBType(FLOAT), Default(None) */
    val maxhoursMean: Column[Option[Float]] = column[Option[Float]]("maxhours_mean", O.Default(None))
    /** Database column maxhours_median DBType(FLOAT), Default(None) */
    val maxhoursMedian: Column[Option[Float]] = column[Option[Float]]("maxhours_median", O.Default(None))
    /** Database column review_contents DBType(MEDIUMTEXT), Length(16777215,true) */
    val reviewContents: Column[String] = column[String]("review_contents", O.Length(16777215,varying=true))
    /** Database column editors DBType(VARCHAR), Length(128,true) */
    val editors: Column[String] = column[String]("editors", O.Length(128,varying=true))
    /** Database column editor_comments DBType(MEDIUMTEXT), Length(16777215,true) */
    val editorComments: Column[String] = column[String]("editor_comments", O.Length(16777215,varying=true))
    /** Database column other_courses DBType(MEDIUMTEXT), Length(16777215,true) */
    val otherCourses: Column[String] = column[String]("other_courses", O.Length(16777215,varying=true))
    /** Database column tally DBType(TEXT), Length(65535,true) */
    val tally: Column[String] = column[String]("tally", O.Length(65535,varying=true))
    /** Database column tally_graphic DBType(MEDIUMBLOB) */
    val tallyGraphic: Column[java.sql.Blob] = column[java.sql.Blob]("tally_graphic")
    /** Database column tally_filetype DBType(CHAR), Length(4,false) */
    val tallyFiletype: Column[String] = column[String]("tally_filetype", O.Length(4,varying=false))
    /** Database column time DBType(TIMESTAMP) */
    val time: Column[java.sql.Timestamp] = column[java.sql.Timestamp]("time")
    /** Database column modifier DBType(INT), Default(-1) */
    val modifier: Column[Int] = column[Int]("modifier", O.Default(-1))
    /** Database column edit_distance DBType(INT), Default(0) */
    val editDistance: Column[Int] = column[Int]("edit_distance", O.Default(0))
    /** Database column oldid DBType(INT) */
    val oldid: Column[Int] = column[Int]("oldid")
    /** Database column barcode_id DBType(INT), Default(None) */
    val barcodeId: Column[Option[Int]] = column[Option[Int]]("barcode_id", O.Default(None))
    /** Database column active DBType(BIT), Default(false) */
    val active: Column[Boolean] = column[Boolean]("active", O.Default(false))
    /** Database column views DBType(INT), Default(0) */
    val views: Column[Int] = column[Int]("views", O.Default(0))
    /** Database column insufficient DBType(BIT), Default(false) */
    val insufficient: Column[Boolean] = column[Boolean]("insufficient", O.Default(false))
    /** Database column flagged DBType(BIT), Default(false) */
    val flagged: Column[Boolean] = column[Boolean]("flagged", O.Default(false))
    /** Database column is_on_staff_ballot DBType(BIT), Default(false) */
    val isOnStaffBallot: Column[Boolean] = column[Boolean]("is_on_staff_ballot", O.Default(false))
    /** Database column featured_date DBType(DATE), Default(None) */
    val featuredDate: Column[Option[java.sql.Date]] = column[Option[java.sql.Date]]("featured_date", O.Default(None))
    /** Database column syllabus DBType(VARCHAR), Length(128,true) */
    val syllabus: Column[String] = column[String]("syllabus", O.Length(128,varying=true))
    /** Database column website DBType(VARCHAR), Length(128,true) */
    val website: Column[String] = column[String]("website", O.Length(128,varying=true))
    /** Database column print_editing DBType(INT) */
    val printEditing: Column[Int] = column[Int]("print_editing")
    /** Database column archive_box DBType(VARCHAR), Length(64,true) */
    val archiveBox: Column[String] = column[String]("archive_box", O.Length(64,varying=true))
    /** Database column prof_name_status DBType(INT), Default(2) */
    val profNameStatus: Column[Int] = column[Int]("prof_name_status", O.Default(2))
    /** Database column prof_fixup_id DBType(INT), Default(0) */
    val profFixupId: Column[Int] = column[Int]("prof_fixup_id", O.Default(0))
    /** Database column survey_printer DBType(VARCHAR), Length(63,true) */
    val surveyPrinter: Column[String] = column[String]("survey_printer", O.Length(63,varying=true))
    /** Database column survey_spooled DBType(BIT), Default(false) */
    val surveySpooled: Column[Boolean] = column[Boolean]("survey_spooled", O.Default(false))
    
    /** Index over (departmentCode,courseNum,section) (database name course) */
    val index1 = index("course", departmentCode :: courseNum :: section :: HNil)
    /** Index over (courseFormat) (database name course_format) */
    val index2 = index("course_format", courseFormat :: HNil)
    /** Index over (professor) (database name professor) */
    val index3 = index("professor", professor :: HNil)
    /** Uniqueness Index over (edition,departmentCode,courseNum,section,revision) (database name revision) */
    val index4 = index("revision", edition :: departmentCode :: courseNum :: section :: revision :: HNil, unique=true)
    /** Index over (title) (database name title) */
    val index5 = index("title", title :: HNil)
    /** Index over (title) (database name title_fulltext) */
    val index6 = index("title_fulltext", title :: HNil)
    /** Index over (writerId) (database name writer_id) */
    val index7 = index("writer_id", writerId :: HNil)
  }
  /** Collection-like TableQuery object for table CrReview2008 */
  lazy val CrReview2008 = new TableQuery(tag => new CrReview2008(tag))
  
  /** Entity class storing rows of table CrReviewHasProfessor2008
   *  @param reviewId Database column review_id DBType(INT)
   *  @param professorId Database column professor_id DBType(INT) */
  case class CrReviewHasProfessor2008Row(reviewId: Int, professorId: Int)
  /** GetResult implicit for fetching CrReviewHasProfessor2008Row objects using plain SQL queries */
  implicit def GetResultCrReviewHasProfessor2008Row(implicit e0: GR[Int]): GR[CrReviewHasProfessor2008Row] = GR{
    prs => import prs._
    CrReviewHasProfessor2008Row.tupled((<<[Int], <<[Int]))
  }
  /** Table description of table cr_review_has_professor_2008. Objects of this class serve as prototypes for rows in queries. */
  class CrReviewHasProfessor2008(_tableTag: Tag) extends Table[CrReviewHasProfessor2008Row](_tableTag, "cr_review_has_professor_2008") {
    def * = (reviewId, professorId) <> (CrReviewHasProfessor2008Row.tupled, CrReviewHasProfessor2008Row.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (reviewId.?, professorId.?).shaped.<>({r=>import r._; _1.map(_=>
      CrReviewHasProfessor2008Row.tupled((_1.get, _2.get)))}, (_:Any) =>
      throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column review_id DBType(INT) */
    val reviewId: Column[Int] = column[Int]("review_id")
    /** Database column professor_id DBType(INT) */
    val professorId: Column[Int] = column[Int]("professor_id")
    
    /** Primary key of CrReviewHasProfessor2008 (database name cr_review_has_professor_2008_PK) */
    val pk = primaryKey("cr_review_has_professor_2008_PK", (reviewId, professorId))
    
    /** Index over (professorId) (database name professor_id) */
    val index1 = index("professor_id", professorId)
    /** Index over (reviewId) (database name review_id) */
    val index2 = index("review_id", reviewId)
  }
  /** Collection-like TableQuery object for table CrReviewHasProfessor2008 */
  lazy val CrReviewHasProfessor2008 = new TableQuery(tag => new CrReviewHasProfessor2008(tag))
  
  /** Entity class storing rows of table CrReviewMessages
   *  @param id Database column id DBType(INT), AutoInc, PrimaryKey
   *  @param edition Database column edition DBType(CHAR), Length(16,false)
   *  @param departmentCode Database column department_code DBType(CHAR), Length(4,false)
   *  @param courseNum Database column course_num DBType(CHAR), Length(16,false)
   *  @param section Database column section DBType(CHAR), Length(8,false)
   *  @param messageContents Database column message_contents DBType(MEDIUMTEXT), Length(16777215,true)
   *  @param priority Database column priority DBType(INT), Default(0) */
  case class CrReviewMessagesRow(id: Int, edition: String, departmentCode: String, courseNum: String, section: String,
                                 messageContents: String, priority: Int = 0)
  /** GetResult implicit for fetching CrReviewMessagesRow objects using plain SQL queries */
  implicit def GetResultCrReviewMessagesRow(implicit e0: GR[Int], e1: GR[String]): GR[CrReviewMessagesRow] = GR{
    prs => import prs._
    CrReviewMessagesRow.tupled((<<[Int], <<[String], <<[String], <<[String], <<[String], <<[String], <<[Int]))
  }
  /** Table description of table cr_review_messages. Objects of this class serve as prototypes for rows in queries. */
  class CrReviewMessages(_tableTag: Tag) extends Table[CrReviewMessagesRow](_tableTag, "cr_review_messages") {
    def * = (id, edition, departmentCode, courseNum, section, messageContents, priority) <> (CrReviewMessagesRow.tupled,
      CrReviewMessagesRow.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (id.?, edition.?, departmentCode.?, courseNum.?, section.?, messageContents.?,
      priority.?).shaped.<>({r=>import r._; _1.map(_=> CrReviewMessagesRow.tupled((_1.get, _2.get, _3.get, _4.get,
      _5.get, _6.get, _7.get)))}, (_:Any) =>  throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column id DBType(INT), AutoInc, PrimaryKey */
    val id: Column[Int] = column[Int]("id", O.AutoInc, O.PrimaryKey)
    /** Database column edition DBType(CHAR), Length(16,false) */
    val edition: Column[String] = column[String]("edition", O.Length(16,varying=false))
    /** Database column department_code DBType(CHAR), Length(4,false) */
    val departmentCode: Column[String] = column[String]("department_code", O.Length(4,varying=false))
    /** Database column course_num DBType(CHAR), Length(16,false) */
    val courseNum: Column[String] = column[String]("course_num", O.Length(16,varying=false))
    /** Database column section DBType(CHAR), Length(8,false) */
    val section: Column[String] = column[String]("section", O.Length(8,varying=false))
    /** Database column message_contents DBType(MEDIUMTEXT), Length(16777215,true) */
    val messageContents: Column[String] = column[String]("message_contents", O.Length(16777215,varying=true))
    /** Database column priority DBType(INT), Default(0) */
    val priority: Column[Int] = column[Int]("priority", O.Default(0))
  }
  /** Collection-like TableQuery object for table CrReviewMessages */
  lazy val CrReviewMessages = new TableQuery(tag => new CrReviewMessages(tag))
  
  /** Entity class storing rows of table CrSurveyCodes
   *  @param department Database column department DBType(VARCHAR), Length(12,true)
   *  @param number Database column number DBType(VARCHAR), Length(12,true)
   *  @param section Database column section DBType(VARCHAR), Length(12,true)
   *  @param edition Database column edition DBType(VARCHAR), Length(12,true)
   *  @param code Database column code DBType(VARCHAR), Length(255,true)
   *  @param status Database column status DBType(INT), Default(None) */
  case class CrSurveyCodesRow(department: String, number: String, section: String, edition: String, code: String,
                              status: Option[Int] = None)
  /** GetResult implicit for fetching CrSurveyCodesRow objects using plain SQL queries */
  implicit def GetResultCrSurveyCodesRow(implicit e0: GR[String], e1: GR[Option[Int]]): GR[CrSurveyCodesRow] = GR{
    prs => import prs._
    CrSurveyCodesRow.tupled((<<[String], <<[String], <<[String], <<[String], <<[String], <<?[Int]))
  }
  /** Table description of table cr_survey_codes. Objects of this class serve as prototypes for rows in queries. */
  class CrSurveyCodes(_tableTag: Tag) extends Table[CrSurveyCodesRow](_tableTag, "cr_survey_codes") {
    def * = (department, number, section, edition, code, status) <> (CrSurveyCodesRow.tupled, CrSurveyCodesRow.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (department.?, number.?, section.?, edition.?, code.?, status).shaped.<>({r=>import r._; _1.map(_=>
      CrSurveyCodesRow.tupled((_1.get, _2.get, _3.get, _4.get, _5.get, _6)))}, (_:Any) =>
      throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column department DBType(VARCHAR), Length(12,true) */
    val department: Column[String] = column[String]("department", O.Length(12,varying=true))
    /** Database column number DBType(VARCHAR), Length(12,true) */
    val number: Column[String] = column[String]("number", O.Length(12,varying=true))
    /** Database column section DBType(VARCHAR), Length(12,true) */
    val section: Column[String] = column[String]("section", O.Length(12,varying=true))
    /** Database column edition DBType(VARCHAR), Length(12,true) */
    val edition: Column[String] = column[String]("edition", O.Length(12,varying=true))
    /** Database column code DBType(VARCHAR), Length(255,true) */
    val code: Column[String] = column[String]("code", O.Length(255,varying=true))
    /** Database column status DBType(INT), Default(None) */
    val status: Column[Option[Int]] = column[Option[Int]]("status", O.Default(None))
    
    /** Primary key of CrSurveyCodes (database name cr_survey_codes_PK) */
    val pk = primaryKey("cr_survey_codes_PK", (department, number, section, edition))
  }
  /** Collection-like TableQuery object for table CrSurveyCodes */
  lazy val CrSurveyCodes = new TableQuery(tag => new CrSurveyCodes(tag))
  
  /** Row type of table CrSurveySubmissions */
  type CrSurveySubmissionsRow = HCons[Int,HCons[String,HCons[String,HCons[String,HCons[String,HCons[Option[String],
    HCons[Option[String],HCons[Option[String],HCons[Option[String],HCons[Option[String],HCons[Option[String],
      HCons[Option[String],HCons[Option[String],HCons[Option[String],HCons[Option[String],HCons[Option[String],
        HCons[Option[String],HCons[Option[String],HCons[Option[String],HCons[Option[String],HCons[Option[String],
          HCons[Option[String],HCons[Option[Float],HCons[Option[Float],HCons[String,HCons[String,HCons[String,
            HCons[String,HCons[String,HCons[String,HCons[String,HCons[String,HCons[java.sql.Timestamp,
              HCons[Option[String],HCons[Option[String],HNil]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
  /** Constructor for CrSurveySubmissionsRow providing default values if available in the database schema. */
  def CrSurveySubmissionsRow(id: Int, department: String, number: String, section: String, edition: String,
                             worthwhile: Option[String] = None, difficult: Option[String] = None,
                             learned: Option[String] = None, enjoyed: Option[String] = None,
                             nonconc: Option[String] = None, presented: Option[String] = None,
                             time: Option[String] = None, encouraged: Option[String] = None,
                             passionate: Option[String] = None, receptive: Option[String] = None,
                             availablefeedback: Option[String] = None, timely: Option[String] = None,
                             policy: Option[String] = None, conc: Option[String] = None,
                             requirement: Option[String] = None, expected: Option[String] = None,
                             attended: Option[String] = None, avghours: Option[Float] = None,
                             maxhours: Option[Float] = None, background: String, assignments: String,
                             difficulty: String, effective: String, feedback: String, recommendations: String,
                             improvements: String, memorable: String, ts: java.sql.Timestamp,
                             instructors: Option[String] = None,
                             materials: Option[String] = None): CrSurveySubmissionsRow = {
    id :: department :: number :: section :: edition :: worthwhile :: difficult :: learned :: enjoyed :: nonconc ::
      presented :: time :: encouraged :: passionate :: receptive :: availablefeedback :: timely :: policy :: conc ::
      requirement :: expected :: attended :: avghours :: maxhours :: background :: assignments :: difficulty ::
      effective :: feedback :: recommendations :: improvements :: memorable :: ts :: instructors :: materials :: HNil
  }
  /** GetResult implicit for fetching CrSurveySubmissionsRow objects using plain SQL queries */
  implicit def GetResultCrSurveySubmissionsRow(implicit e0: GR[Int],
                                               e1: GR[String],
                                               e2: GR[Option[String]], e3: GR[Option[Float]],
                                               e4: GR[java.sql.Timestamp]): GR[CrSurveySubmissionsRow] = GR{
    prs => import prs._
    <<[Int] :: <<[String] :: <<[String] :: <<[String] :: <<[String] :: <<?[String] :: <<?[String] :: <<?[String] ::
      <<?[String] :: <<?[String] :: <<?[String] :: <<?[String] :: <<?[String] :: <<?[String] :: <<?[String] ::
      <<?[String] :: <<?[String] :: <<?[String] :: <<?[String] :: <<?[String] :: <<?[String] :: <<?[String] ::
      <<?[Float] :: <<?[Float] :: <<[String] :: <<[String] :: <<[String] :: <<[String] :: <<[String] :: <<[String] ::
      <<[String] :: <<[String] :: <<[java.sql.Timestamp] :: <<?[String] :: <<?[String] :: HNil
  }
  /** Table description of table cr_survey_submissions. Objects of this class serve as prototypes for rows in queries. */
  class CrSurveySubmissions(_tableTag: Tag) extends Table[CrSurveySubmissionsRow](_tableTag, "cr_survey_submissions") {
    def * = id :: department :: number :: section :: edition :: worthwhile :: difficult :: learned :: enjoyed ::
      nonconc :: presented :: time :: encouraged :: passionate :: receptive :: availablefeedback :: timely ::
      policy :: conc :: requirement :: expected :: attended :: avghours :: maxhours :: background :: assignments ::
      difficulty :: effective :: feedback :: recommendations :: improvements :: memorable :: ts :: instructors ::
      materials :: HNil
    
    /** Database column id DBType(MEDIUMINT), AutoInc, PrimaryKey */
    val id: Column[Int] = column[Int]("id", O.AutoInc, O.PrimaryKey)
    /** Database column department DBType(VARCHAR), Length(12,true) */
    val department: Column[String] = column[String]("department", O.Length(12,varying=true))
    /** Database column number DBType(VARCHAR), Length(12,true) */
    val number: Column[String] = column[String]("number", O.Length(12,varying=true))
    /** Database column section DBType(VARCHAR), Length(12,true) */
    val section: Column[String] = column[String]("section", O.Length(12,varying=true))
    /** Database column edition DBType(VARCHAR), Length(12,true) */
    val edition: Column[String] = column[String]("edition", O.Length(12,varying=true))
    /** Database column worthwhile DBType(VARCHAR), Length(12,true), Default(None) */
    val worthwhile: Column[Option[String]] = column[Option[String]]("worthwhile", O.Length(12,varying=true), O.Default(None))
    /** Database column difficult DBType(VARCHAR), Length(12,true), Default(None) */
    val difficult: Column[Option[String]] = column[Option[String]]("difficult", O.Length(12,varying=true), O.Default(None))
    /** Database column learned DBType(VARCHAR), Length(12,true), Default(None) */
    val learned: Column[Option[String]] = column[Option[String]]("learned", O.Length(12,varying=true), O.Default(None))
    /** Database column enjoyed DBType(VARCHAR), Length(12,true), Default(None) */
    val enjoyed: Column[Option[String]] = column[Option[String]]("enjoyed", O.Length(12,varying=true), O.Default(None))
    /** Database column nonconc DBType(VARCHAR), Length(12,true), Default(None) */
    val nonconc: Column[Option[String]] = column[Option[String]]("nonconc", O.Length(12,varying=true), O.Default(None))
    /** Database column presented DBType(VARCHAR), Length(12,true), Default(None) */
    val presented: Column[Option[String]] = column[Option[String]]("presented", O.Length(12,varying=true), O.Default(None))
    /** Database column time DBType(VARCHAR), Length(12,true), Default(None) */
    val time: Column[Option[String]] = column[Option[String]]("time", O.Length(12,varying=true), O.Default(None))
    /** Database column encouraged DBType(VARCHAR), Length(12,true), Default(None) */
    val encouraged: Column[Option[String]] = column[Option[String]]("encouraged", O.Length(12,varying=true), O.Default(None))
    /** Database column passionate DBType(VARCHAR), Length(12,true), Default(None) */
    val passionate: Column[Option[String]] = column[Option[String]]("passionate", O.Length(12,varying=true), O.Default(None))
    /** Database column receptive DBType(VARCHAR), Length(12,true), Default(None) */
    val receptive: Column[Option[String]] = column[Option[String]]("receptive", O.Length(12,varying=true), O.Default(None))
    /** Database column availableFeedback DBType(VARCHAR), Length(12,true), Default(None) */
    val availablefeedback: Column[Option[String]] = column[Option[String]]("availableFeedback", O.Length(12,varying=true), O.Default(None))
    /** Database column timely DBType(VARCHAR), Length(12,true), Default(None) */
    val timely: Column[Option[String]] = column[Option[String]]("timely", O.Length(12,varying=true), O.Default(None))
    /** Database column policy DBType(VARCHAR), Length(12,true), Default(None) */
    val policy: Column[Option[String]] = column[Option[String]]("policy", O.Length(12,varying=true), O.Default(None))
    /** Database column conc DBType(VARCHAR), Length(12,true), Default(None) */
    val conc: Column[Option[String]] = column[Option[String]]("conc", O.Length(12,varying=true), O.Default(None))
    /** Database column requirement DBType(VARCHAR), Length(12,true), Default(None) */
    val requirement: Column[Option[String]] = column[Option[String]]("requirement", O.Length(12,varying=true), O.Default(None))
    /** Database column expected DBType(ENUM), Length(2,false), Default(None) */
    val expected: Column[Option[String]] = column[Option[String]]("expected", O.Length(2,varying=false), O.Default(None))
    /** Database column attended DBType(VARCHAR), Length(20,true), Default(None) */
    val attended: Column[Option[String]] = column[Option[String]]("attended", O.Length(20,varying=true), O.Default(None))
    /** Database column avghours DBType(FLOAT), Default(None) */
    val avghours: Column[Option[Float]] = column[Option[Float]]("avghours", O.Default(None))
    /** Database column maxhours DBType(FLOAT), Default(None) */
    val maxhours: Column[Option[Float]] = column[Option[Float]]("maxhours", O.Default(None))
    /** Database column background DBType(TEXT), Length(65535,true) */
    val background: Column[String] = column[String]("background", O.Length(65535,varying=true))
    /** Database column assignments DBType(TEXT), Length(65535,true) */
    val assignments: Column[String] = column[String]("assignments", O.Length(65535,varying=true))
    /** Database column difficulty DBType(TEXT), Length(65535,true) */
    val difficulty: Column[String] = column[String]("difficulty", O.Length(65535,varying=true))
    /** Database column effective DBType(TEXT), Length(65535,true) */
    val effective: Column[String] = column[String]("effective", O.Length(65535,varying=true))
    /** Database column feedback DBType(TEXT), Length(65535,true) */
    val feedback: Column[String] = column[String]("feedback", O.Length(65535,varying=true))
    /** Database column recommendations DBType(TEXT), Length(65535,true) */
    val recommendations: Column[String] = column[String]("recommendations", O.Length(65535,varying=true))
    /** Database column improvements DBType(TEXT), Length(65535,true) */
    val improvements: Column[String] = column[String]("improvements", O.Length(65535,varying=true))
    /** Database column memorable DBType(TEXT), Length(65535,true) */
    val memorable: Column[String] = column[String]("memorable", O.Length(65535,varying=true))
    /** Database column ts DBType(TIMESTAMP) */
    val ts: Column[java.sql.Timestamp] = column[java.sql.Timestamp]("ts")
    /** Database column instructors DBType(TEXT), Length(65535,true), Default(None) */
    val instructors: Column[Option[String]] = column[Option[String]]("instructors", O.Length(65535,varying=true), O.Default(None))
    /** Database column materials DBType(VARCHAR), Length(12,true), Default(None) */
    val materials: Column[Option[String]] = column[Option[String]]("materials", O.Length(12,varying=true), O.Default(None))
  }
  /** Collection-like TableQuery object for table CrSurveySubmissions */
  lazy val CrSurveySubmissions = new TableQuery(tag => new CrSurveySubmissions(tag))
  
  /** Entity class storing rows of table CrUserBios2005
   *  @param bioId Database column BIO_ID DBType(INT), AutoInc, PrimaryKey
   *  @param userId Database column USER_ID DBType(INT)
   *  @param edition Database column EDITION DBType(CHAR), Length(16,false)
   *  @param time Database column TIME DBType(INT)
   *  @param bio Database column BIO DBType(TEXT), Length(65535,true)
   *  @param year Database column YEAR DBType(VARCHAR), Length(9,true)
   *  @param lev Database column LEV DBType(TINYINT)
   *  @param name Database column NAME DBType(VARCHAR), Length(127,true)
   *  @param title Database column TITLE DBType(VARCHAR), Length(64,true)
   *  @param rank Database column RANK DBType(SMALLINT)
   *  @param phone Database column PHONE DBType(VARCHAR), Length(15,true)
   *  @param mailbox Database column MAILBOX DBType(VARCHAR), Length(9,true)
   *  @param hasPhoto Database column HAS_PHOTO DBType(BIT)
   *  @param photoVersion Database column PHOTO_VERSION DBType(INT) */
  case class CrUserBios2005Row(bioId: Int, userId: Int, edition: String, time: Int, bio: String, year: String,
                               lev: Byte, name: String, title: String, rank: Short, phone: String, mailbox: String,
                               hasPhoto: Boolean, photoVersion: Int)
  /** GetResult implicit for fetching CrUserBios2005Row objects using plain SQL queries */
  implicit def GetResultCrUserBios2005Row(implicit e0: GR[Int], e1: GR[String], e2: GR[Byte], e3: GR[Short],
                                          e4: GR[Boolean]): GR[CrUserBios2005Row] = GR{
    prs => import prs._
    CrUserBios2005Row.tupled((<<[Int], <<[Int], <<[String], <<[Int], <<[String], <<[String], <<[Byte], <<[String],
      <<[String], <<[Short], <<[String], <<[String], <<[Boolean], <<[Int]))
  }
  /** Table description of table cr_user_bios_2005. Objects of this class serve as prototypes for rows in queries. */
  class CrUserBios2005(_tableTag: Tag) extends Table[CrUserBios2005Row](_tableTag, "cr_user_bios_2005") {
    def * = (bioId, userId, edition, time, bio, year, lev, name, title, rank, phone, mailbox, hasPhoto, photoVersion) <>
      (CrUserBios2005Row.tupled, CrUserBios2005Row.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (bioId.?, userId.?, edition.?, time.?, bio.?, year.?, lev.?, name.?, title.?, rank.?, phone.?, mailbox.?,
      hasPhoto.?, photoVersion.?).shaped.<>({r=>import r._; _1.map(_=>
      CrUserBios2005Row.tupled((_1.get, _2.get, _3.get, _4.get, _5.get, _6.get, _7.get, _8.get, _9.get, _10.get,
        _11.get, _12.get, _13.get, _14.get)))}, (_:Any) =>
      throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column BIO_ID DBType(INT), AutoInc, PrimaryKey */
    val bioId: Column[Int] = column[Int]("BIO_ID", O.AutoInc, O.PrimaryKey)
    /** Database column USER_ID DBType(INT) */
    val userId: Column[Int] = column[Int]("USER_ID")
    /** Database column EDITION DBType(CHAR), Length(16,false) */
    val edition: Column[String] = column[String]("EDITION", O.Length(16,varying=false))
    /** Database column TIME DBType(INT) */
    val time: Column[Int] = column[Int]("TIME")
    /** Database column BIO DBType(TEXT), Length(65535,true) */
    val bio: Column[String] = column[String]("BIO", O.Length(65535,varying=true))
    /** Database column YEAR DBType(VARCHAR), Length(9,true) */
    val year: Column[String] = column[String]("YEAR", O.Length(9,varying=true))
    /** Database column LEV DBType(TINYINT) */
    val lev: Column[Byte] = column[Byte]("LEV")
    /** Database column NAME DBType(VARCHAR), Length(127,true) */
    val name: Column[String] = column[String]("NAME", O.Length(127,varying=true))
    /** Database column TITLE DBType(VARCHAR), Length(64,true) */
    val title: Column[String] = column[String]("TITLE", O.Length(64,varying=true))
    /** Database column RANK DBType(SMALLINT) */
    val rank: Column[Short] = column[Short]("RANK")
    /** Database column PHONE DBType(VARCHAR), Length(15,true) */
    val phone: Column[String] = column[String]("PHONE", O.Length(15,varying=true))
    /** Database column MAILBOX DBType(VARCHAR), Length(9,true) */
    val mailbox: Column[String] = column[String]("MAILBOX", O.Length(9,varying=true))
    /** Database column HAS_PHOTO DBType(BIT) */
    val hasPhoto: Column[Boolean] = column[Boolean]("HAS_PHOTO")
    /** Database column PHOTO_VERSION DBType(INT) */
    val photoVersion: Column[Int] = column[Int]("PHOTO_VERSION")
    
    /** Uniqueness Index over (edition,userId) (database name edition_user_id) */
    val index1 = index("edition_user_id", (edition, userId), unique=true)
  }
  /** Collection-like TableQuery object for table CrUserBios2005 */
  lazy val CrUserBios2005 = new TableQuery(tag => new CrUserBios2005(tag))
  
  /** Entity class storing rows of table CrUserLevel2005
   *  @param levelId Database column LEVEL_ID DBType(INT), AutoInc, PrimaryKey
   *  @param userId Database column USER_ID DBType(INT)
   *  @param editionId Database column EDITION_ID DBType(INT)
   *  @param lev Database column LEV DBType(INT) */
  case class CrUserLevel2005Row(levelId: Int, userId: Int, editionId: Int, lev: Int)
  /** GetResult implicit for fetching CrUserLevel2005Row objects using plain SQL queries */
  implicit def GetResultCrUserLevel2005Row(implicit e0: GR[Int]): GR[CrUserLevel2005Row] = GR{
    prs => import prs._
    CrUserLevel2005Row.tupled((<<[Int], <<[Int], <<[Int], <<[Int]))
  }
  /** Table description of table cr_user_level_2005. Objects of this class serve as prototypes for rows in queries. */
  class CrUserLevel2005(_tableTag: Tag) extends Table[CrUserLevel2005Row](_tableTag, "cr_user_level_2005") {
    def * = (levelId, userId, editionId, lev) <> (CrUserLevel2005Row.tupled, CrUserLevel2005Row.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (levelId.?, userId.?, editionId.?, lev.?).shaped.<>({r=>import r._; _1.map(_=>
      CrUserLevel2005Row.tupled((_1.get, _2.get, _3.get, _4.get)))}, (_:Any) =>
      throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column LEVEL_ID DBType(INT), AutoInc, PrimaryKey */
    val levelId: Column[Int] = column[Int]("LEVEL_ID", O.AutoInc, O.PrimaryKey)
    /** Database column USER_ID DBType(INT) */
    val userId: Column[Int] = column[Int]("USER_ID")
    /** Database column EDITION_ID DBType(INT) */
    val editionId: Column[Int] = column[Int]("EDITION_ID")
    /** Database column LEV DBType(INT) */
    val lev: Column[Int] = column[Int]("LEV")
  }
  /** Collection-like TableQuery object for table CrUserLevel2005 */
  lazy val CrUserLevel2005 = new TableQuery(tag => new CrUserLevel2005(tag))
  
  /** Entity class storing rows of table CrUsers2005
   *  @param id Database column ID DBType(INT), AutoInc
   *  @param username Database column USERNAME DBType(VARCHAR), Length(63,true), Default()
   *  @param password Database column PASSWORD DBType(VARCHAR), Length(63,true), Default(None)
   *  @param oldPassword Database column OLD_PASSWORD DBType(VARCHAR), Length(63,true), Default(None)
   *  @param email Database column EMAIL DBType(VARCHAR), Length(63,true), Default()
   *  @param level Database column LEVEL DBType(CHAR), Length(1,false), Default()
   *  @param cookie Database column COOKIE DBType(VARCHAR), Length(63,true), Default()
   *  @param session Database column SESSION DBType(VARCHAR), Length(63,true), Default()
   *  @param ip Database column IP DBType(VARCHAR), Length(15,true), Default()
   *  @param bio1 Database column BIO1 DBType(TEXT), Length(65535,true)
   *  @param staff Database column STAFF DBType(BINARY)
   *  @param `super` Database column SUPER DBType(BIT), Default(false) */
  case class CrUsers2005Row(id: Int, username: String = "", password: Option[String] = None,
                            oldPassword: Option[String] = None, email: String = "", level: String = "",
                            cookie: String = "", session: String = "", ip: String = "", bio1: String,
                            staff: java.sql.Blob, `super`: Boolean = false)
  /** GetResult implicit for fetching CrUsers2005Row objects using plain SQL queries */
  implicit def GetResultCrUsers2005Row(implicit e0: GR[Int], e1: GR[String], e2: GR[Option[String]],
                                       e3: GR[java.sql.Blob], e4: GR[Boolean]): GR[CrUsers2005Row] = GR{
    prs => import prs._
    CrUsers2005Row.tupled((<<[Int], <<[String], <<?[String], <<?[String], <<[String], <<[String], <<[String],
      <<[String], <<[String], <<[String], <<[java.sql.Blob], <<[Boolean]))
  }
  /** Table description of table cr_users_2005. Objects of this class serve as prototypes for rows in queries.
   *  NOTE: The following names collided with Scala keywords and were escaped: super */
  class CrUsers2005(_tableTag: Tag) extends Table[CrUsers2005Row](_tableTag, "cr_users_2005") {
    def * = (id, username, password, oldPassword, email, level, cookie, session, ip, bio1, staff, `super`) <>
      (CrUsers2005Row.tupled, CrUsers2005Row.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (id.?, username.?, password, oldPassword, email.?, level.?, cookie.?, session.?, ip.?, bio1.?, staff.?,
      `super`.?).shaped.<>({r=>import r._; _1.map(_=> CrUsers2005Row.tupled((_1.get, _2.get, _3, _4, _5.get, _6.get,
      _7.get, _8.get, _9.get, _10.get, _11.get, _12.get)))}, (_:Any) =>
      throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column ID DBType(INT), AutoInc */
    val id: Column[Int] = column[Int]("ID", O.AutoInc)
    /** Database column USERNAME DBType(VARCHAR), Length(63,true), Default() */
    val username: Column[String] = column[String]("USERNAME", O.Length(63,varying=true), O.Default(""))
    /** Database column PASSWORD DBType(VARCHAR), Length(63,true), Default(None) */
    val password: Column[Option[String]] = column[Option[String]]("PASSWORD", O.Length(63,varying=true), O.Default(None))
    /** Database column OLD_PASSWORD DBType(VARCHAR), Length(63,true), Default(None) */
    val oldPassword: Column[Option[String]] = column[Option[String]]("OLD_PASSWORD", O.Length(63,varying=true), O.Default(None))
    /** Database column EMAIL DBType(VARCHAR), Length(63,true), Default() */
    val email: Column[String] = column[String]("EMAIL", O.Length(63,varying=true), O.Default(""))
    /** Database column LEVEL DBType(CHAR), Length(1,false), Default() */
    val level: Column[String] = column[String]("LEVEL", O.Length(1,varying=false), O.Default(""))
    /** Database column COOKIE DBType(VARCHAR), Length(63,true), Default() */
    val cookie: Column[String] = column[String]("COOKIE", O.Length(63,varying=true), O.Default(""))
    /** Database column SESSION DBType(VARCHAR), Length(63,true), Default() */
    val session: Column[String] = column[String]("SESSION", O.Length(63,varying=true), O.Default(""))
    /** Database column IP DBType(VARCHAR), Length(15,true), Default() */
    val ip: Column[String] = column[String]("IP", O.Length(15,varying=true), O.Default(""))
    /** Database column BIO1 DBType(TEXT), Length(65535,true) */
    val bio1: Column[String] = column[String]("BIO1", O.Length(65535,varying=true))
    /** Database column STAFF DBType(BINARY) */
    val staff: Column[java.sql.Blob] = column[java.sql.Blob]("STAFF")
    /** Database column SUPER DBType(BIT), Default(false)
     *  NOTE: The name was escaped because it collided with a Scala keyword. */
    val `super`: Column[Boolean] = column[Boolean]("SUPER", O.Default(false))
    
    /** Uniqueness Index over (email) (database name EMAIL) */
    val index1 = index("EMAIL", email, unique=true)
    /** Index over (id) (database name ID) */
    val index2 = index("ID", id)
    /** Uniqueness Index over (username) (database name USERNAME) */
    val index3 = index("USERNAME", username, unique=true)
  }
  /** Collection-like TableQuery object for table CrUsers2005 */
  lazy val CrUsers2005 = new TableQuery(tag => new CrUsers2005(tag))
  
  /** Entity class storing rows of table MochaCourses
   *  @param mcUid Database column mc_uid DBType(INT)
   *  @param mcBooks Database column mc_books DBType(VARCHAR), Length(127,true)
   *  @param mcDepartmentCode Database column mc_department_code DBType(VARCHAR), Length(4,true)
   *  @param mcCourseNum Database column mc_course_num DBType(VARCHAR), Length(11,true)
   *  @param mcSection Database column mc_section DBType(INT)
   *  @param mcProfessor Database column mc_professor DBType(VARCHAR), Length(63,true)
   *  @param mcTitle Database column mc_title DBType(VARCHAR), Length(127,true)
   *  @param mcSemestertext Database column mc_semesterText DBType(VARCHAR), Length(31,true)
   *  @param mcDisplaytime Database column mc_displayTime DBType(VARCHAR), Length(63,true)
   *  @param mcCourseregistrationnumber Database column mc_courseRegistrationNumber DBType(INT)
   *  @param mcRealtime Database column mc_realTime DBType(VARCHAR), Length(63,true) */
  case class MochaCoursesRow(mcUid: Int, mcBooks: String, mcDepartmentCode: String, mcCourseNum: String,
                             mcSection: Int, mcProfessor: String, mcTitle: String, mcSemestertext: String,
                             mcDisplaytime: String, mcCourseregistrationnumber: Int, mcRealtime: String)
  /** GetResult implicit for fetching MochaCoursesRow objects using plain SQL queries */
  implicit def GetResultMochaCoursesRow(implicit e0: GR[Int], e1: GR[String]): GR[MochaCoursesRow] = GR{
    prs => import prs._
    MochaCoursesRow.tupled((<<[Int], <<[String], <<[String], <<[String], <<[Int], <<[String], <<[String], <<[String],
      <<[String], <<[Int], <<[String]))
  }
  /** Table description of table mocha_courses. Objects of this class serve as prototypes for rows in queries. */
  class MochaCourses(_tableTag: Tag) extends Table[MochaCoursesRow](_tableTag, "mocha_courses") {
    def * = (mcUid, mcBooks, mcDepartmentCode, mcCourseNum, mcSection, mcProfessor, mcTitle, mcSemestertext,
      mcDisplaytime, mcCourseregistrationnumber, mcRealtime) <> (MochaCoursesRow.tupled, MochaCoursesRow.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (mcUid.?, mcBooks.?, mcDepartmentCode.?, mcCourseNum.?, mcSection.?, mcProfessor.?, mcTitle.?,
      mcSemestertext.?, mcDisplaytime.?, mcCourseregistrationnumber.?, mcRealtime.?).shaped.<>({r=>import r._;
      _1.map(_=> MochaCoursesRow.tupled((_1.get, _2.get, _3.get, _4.get, _5.get, _6.get, _7.get, _8.get, _9.get,
        _10.get, _11.get)))}, (_:Any) =>  throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column mc_uid DBType(INT) */
    val mcUid: Column[Int] = column[Int]("mc_uid")
    /** Database column mc_books DBType(VARCHAR), Length(127,true) */
    val mcBooks: Column[String] = column[String]("mc_books", O.Length(127,varying=true))
    /** Database column mc_department_code DBType(VARCHAR), Length(4,true) */
    val mcDepartmentCode: Column[String] = column[String]("mc_department_code", O.Length(4,varying=true))
    /** Database column mc_course_num DBType(VARCHAR), Length(11,true) */
    val mcCourseNum: Column[String] = column[String]("mc_course_num", O.Length(11,varying=true))
    /** Database column mc_section DBType(INT) */
    val mcSection: Column[Int] = column[Int]("mc_section")
    /** Database column mc_professor DBType(VARCHAR), Length(63,true) */
    val mcProfessor: Column[String] = column[String]("mc_professor", O.Length(63,varying=true))
    /** Database column mc_title DBType(VARCHAR), Length(127,true) */
    val mcTitle: Column[String] = column[String]("mc_title", O.Length(127,varying=true))
    /** Database column mc_semesterText DBType(VARCHAR), Length(31,true) */
    val mcSemestertext: Column[String] = column[String]("mc_semesterText", O.Length(31,varying=true))
    /** Database column mc_displayTime DBType(VARCHAR), Length(63,true) */
    val mcDisplaytime: Column[String] = column[String]("mc_displayTime", O.Length(63,varying=true))
    /** Database column mc_courseRegistrationNumber DBType(INT) */
    val mcCourseregistrationnumber: Column[Int] = column[Int]("mc_courseRegistrationNumber")
    /** Database column mc_realTime DBType(VARCHAR), Length(63,true) */
    val mcRealtime: Column[String] = column[String]("mc_realTime", O.Length(63,varying=true))
  }
  /** Collection-like TableQuery object for table MochaCourses */
  lazy val MochaCourses = new TableQuery(tag => new MochaCourses(tag))
  
  /** Entity class storing rows of table StaffPhotos
   *  @param edition Database column edition DBType(VARCHAR), Length(15,true)
   *  @param userId Database column user_id DBType(INT)
   *  @param data Database column data DBType(BLOB) */
  case class StaffPhotosRow(edition: String, userId: Int, data: java.sql.Blob)
  /** GetResult implicit for fetching StaffPhotosRow objects using plain SQL queries */
  implicit def GetResultStaffPhotosRow(implicit e0: GR[String], e1: GR[Int], e2: GR[java.sql.Blob]):
  GR[StaffPhotosRow] = GR{
    prs => import prs._
    StaffPhotosRow.tupled((<<[String], <<[Int], <<[java.sql.Blob]))
  }
  /** Table description of table staff_photos. Objects of this class serve as prototypes for rows in queries. */
  class StaffPhotos(_tableTag: Tag) extends Table[StaffPhotosRow](_tableTag, "staff_photos") {
    def * = (edition, userId, data) <> (StaffPhotosRow.tupled, StaffPhotosRow.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (edition.?, userId.?, data.?).shaped.<>({r=>import r._; _1.map(_=> StaffPhotosRow.tupled((_1.get, _2.get,
      _3.get)))}, (_:Any) =>  throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column edition DBType(VARCHAR), Length(15,true) */
    val edition: Column[String] = column[String]("edition", O.Length(15,varying=true))
    /** Database column user_id DBType(INT) */
    val userId: Column[Int] = column[Int]("user_id")
    /** Database column data DBType(BLOB) */
    val data: Column[java.sql.Blob] = column[java.sql.Blob]("data")
    
    /** Primary key of StaffPhotos (database name staff_photos_PK) */
    val pk = primaryKey("staff_photos_PK", (edition, userId))
  }
  /** Collection-like TableQuery object for table StaffPhotos */
  lazy val StaffPhotos = new TableQuery(tag => new StaffPhotos(tag))
  
  /** Entity class storing rows of table StaffVotes
   *  @param voteId Database column vote_id DBType(INT), AutoInc, PrimaryKey
   *  @param userId Database column user_id DBType(INT)
   *  @param edition Database column edition DBType(CHAR), Length(16,false)
   *  @param departmentCode Database column department_code DBType(CHAR), Length(4,false)
   *  @param courseNum Database column course_num DBType(CHAR), Length(16,false)
   *  @param section Database column section DBType(CHAR), Length(8,false) */
  case class StaffVotesRow(voteId: Int, userId: Int, edition: String, departmentCode: String, courseNum: String, section: String)
  /** GetResult implicit for fetching StaffVotesRow objects using plain SQL queries */
  implicit def GetResultStaffVotesRow(implicit e0: GR[Int], e1: GR[String]): GR[StaffVotesRow] = GR{
    prs => import prs._
    StaffVotesRow.tupled((<<[Int], <<[Int], <<[String], <<[String], <<[String], <<[String]))
  }
  /** Table description of table staff_votes. Objects of this class serve as prototypes for rows in queries. */
  class StaffVotes(_tableTag: Tag) extends Table[StaffVotesRow](_tableTag, "staff_votes") {
    def * = (voteId, userId, edition, departmentCode, courseNum, section) <> (StaffVotesRow.tupled, StaffVotesRow.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (voteId.?, userId.?, edition.?, departmentCode.?, courseNum.?, section.?).shaped.<>({r=>
      import r._; _1.map(_=> StaffVotesRow.tupled((_1.get, _2.get, _3.get, _4.get, _5.get, _6.get)))},
    (_:Any) =>  throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column vote_id DBType(INT), AutoInc, PrimaryKey */
    val voteId: Column[Int] = column[Int]("vote_id", O.AutoInc, O.PrimaryKey)
    /** Database column user_id DBType(INT) */
    val userId: Column[Int] = column[Int]("user_id")
    /** Database column edition DBType(CHAR), Length(16,false) */
    val edition: Column[String] = column[String]("edition", O.Length(16,varying=false))
    /** Database column department_code DBType(CHAR), Length(4,false) */
    val departmentCode: Column[String] = column[String]("department_code", O.Length(4,varying=false))
    /** Database column course_num DBType(CHAR), Length(16,false) */
    val courseNum: Column[String] = column[String]("course_num", O.Length(16,varying=false))
    /** Database column section DBType(CHAR), Length(8,false) */
    val section: Column[String] = column[String]("section", O.Length(8,varying=false))
    
    /** Index over (edition,departmentCode,courseNum,section) (database name course) */
    val index1 = index("course", (edition, departmentCode, courseNum, section))
    /** Index over (userId,edition) (database name user) */
    val index2 = index("user", (userId, edition))
  }
  /** Collection-like TableQuery object for table StaffVotes */
  lazy val StaffVotes = new TableQuery(tag => new StaffVotes(tag))
  
  /** Entity class storing rows of table Tallies
   *  @param edition Database column edition DBType(CHAR), Length(16,false)
   *  @param departmentCode Database column department_code DBType(CHAR), Length(4,false)
   *  @param courseNum Database column course_num DBType(CHAR), Length(16,false)
   *  @param section Database column section DBType(CHAR), Length(8,false)
   *  @param xmlData Database column xml_data DBType(BLOB) */
  case class TalliesRow(edition: String, departmentCode: String, courseNum: String, section: String, xmlData: java.sql.Blob)
  /** GetResult implicit for fetching TalliesRow objects using plain SQL queries */
  implicit def GetResultTalliesRow(implicit e0: GR[String], e1: GR[java.sql.Blob]): GR[TalliesRow] = GR{
    prs => import prs._
    TalliesRow.tupled((<<[String], <<[String], <<[String], <<[String], <<[java.sql.Blob]))
  }
  /** Table description of table tallies. Objects of this class serve as prototypes for rows in queries. */
  class Tallies(_tableTag: Tag) extends Table[TalliesRow](_tableTag, "tallies") {
    def * = (edition, departmentCode, courseNum, section, xmlData) <> (TalliesRow.tupled, TalliesRow.unapply)
    /** Maps whole row to an option. Useful for outer joins. */
    def ? = (edition.?, departmentCode.?, courseNum.?, section.?, xmlData.?).shaped.<>({r=>
      import r._; _1.map(_=> TalliesRow.tupled((_1.get, _2.get, _3.get, _4.get, _5.get)))},
    (_:Any) =>  throw new Exception("Inserting into ? projection not supported."))
    
    /** Database column edition DBType(CHAR), Length(16,false) */
    val edition: Column[String] = column[String]("edition", O.Length(16,varying=false))
    /** Database column department_code DBType(CHAR), Length(4,false) */
    val departmentCode: Column[String] = column[String]("department_code", O.Length(4,varying=false))
    /** Database column course_num DBType(CHAR), Length(16,false) */
    val courseNum: Column[String] = column[String]("course_num", O.Length(16,varying=false))
    /** Database column section DBType(CHAR), Length(8,false) */
    val section: Column[String] = column[String]("section", O.Length(8,varying=false))
    /** Database column xml_data DBType(BLOB) */
    val xmlData: Column[java.sql.Blob] = column[java.sql.Blob]("xml_data")
    
    /** Primary key of Tallies (database name tallies_PK) */
    val pk = primaryKey("tallies_PK", (edition, departmentCode, courseNum, section))
  }
  /** Collection-like TableQuery object for table Tallies */
  lazy val Tallies = new TableQuery(tag => new Tallies(tag))
}
