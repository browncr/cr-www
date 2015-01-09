<?php

require_once("../../config.php");
require_once("common/database-init.php");
require_once("common/database.php");

header("Content-Type: application/xml");
header("Cache-Control: max-age=86400, public");
print(editions_xml());

?>
