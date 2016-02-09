Critical Review Website
=======================

This is the new website for the [Critical Review](http://http://thecriticalreview.org/).
If you are interested in helping out, you should contact the Critical Review's
technical team to get involved. The site is written in Scala using the
[Play framework](https://www.playframework.com/). Even if you don't know Scala,
there are still ways to help out and learn!

Getting Started
===============

To run, [download Activator](http://www.typesafe.com/activator/download),
extract the directory, and run:

```shell
/path/to/dir/activator compile
```

The first time this is run, it may take a while to download all of the
dependencies.

Now, we need to configure the project. There is an example configuration file
available, `conf/.application.conf.example`. Copy that to
`conf/application.conf`, and then open it up for editing. Update the following
lines to use the read-only account:

```
db.default.user="USERNAME"
db.default.password="PASSWORD"
```

If you're working on queries that modify the database, you should set up your
own copy of the database to use independently of other people.

Now that you've done that, you can port-forward the MySQL database so that you
can access it locally:

```shell
ssh -L 3306:localhost:3306 <login>@cheetham.browncr.org
```

If you're not familiar with SSH port forwarding, this forwards connections to
port 3306 on your local machine through the SSH tunnel, and connects from the
other side to localhost on port 3306. You will need to make sure you have an
account set up and have given the admin your public SSH key.

You are now ready to run the site (available by default at
[localhost:9000](http://localhost:9000/)):

```shell
/path/to/dir/activator run
```

Current Status
==============

The current goal is to reach feature parity for non-logged in users
(Milestone 2), and then reach feature parity for logged in users (Milestone 4).
These efforts should basically be to replicate current site functionality using
the current database schema. Once that is done, and the site can be rolled out
to replace the current one (which should be possible for the default site after
Milestone 2), then larger changes can be made (such as data normalization).

- [Milestone 1](https://github.com/browncr/cr-www/milestones/Milestone%201):
  Achieve basic feature parity with current site
- [Milestone 2](https://github.com/browncr/cr-www/milestones/Milestone%202):
  Perform everything outside of Staff functions on the current site
- [Milestone 3](https://github.com/browncr/cr-www/milestones/Milestone%203):
  Implement basic login and account management
- [Milestone 4](https://github.com/browncr/cr-www/milestones/Milestone%204):
  Support editing reviews
- [Milestone 5](https://github.com/browncr/cr-www/milestones/Milestone%205):
  Easy improvements and cleanup
- [Milestone 6](https://github.com/browncr/cr-www/milestones/Milestone%206):
  Investigate large improvements: switch to Postgres, use LDAP, etc.
