name := """critical-review"""

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.1"

libraryDependencies ++= Seq(
  jdbc,
  cache,
  ws,
  "postgresql" % "postgresql" % "9.1-901.jdbc4",
  "mysql" % "mysql-connector-java" % "5.1.21",
  "com.h2database" % "h2" % "1.3.175",
  "com.typesafe.play" %% "play-slick" % "0.8.0",
  "com.typesafe.slick" %% "slick" % "2.1.0-M2",
  "org.slf4j" % "slf4j-nop" % "1.6.4",
  "xalan" % "xalan" % "2.7.1"
)
