#!/bin/bash

#### Nedd to edit the above parameters

# The name of the local server that hosts your Wordpress (should be set to localhost)
readonly origin_site=localhost
# The WWW domain of the remote Wordpress server. Wordpress generates URL (links, images, etc,...) with an absolute path. This parameter is used to migrate all http://localhost/.. to http://www.monsite.com/...
readonly dest_site=www.monsite.com
# Server name of the Wordpress remote server used for SSH connexion.
readonly dest_server=myserver.domain.com
#The SSH username used to connect to the remote server
readonly adm_user=myuser
# Path of the SSH private key required for the connexion
readonly ssh_key=/Users/home/.ssh/mykey
# Root dir of the local Wordpress site
readonly wordpress_local_rootdir=/Library/WebServer/Documents/ete2018
# Root dir of the remote Wordpress site
readonly wordpress_remote_rootdir=/mnt/backup/ete2018
# The MySQL database name used by the Wordpress site
readonly database_name=ete2018
# The database password
readonly database_password=password

#########

# Name of the database dumpfile (no need to change it)
readonly wp_dump=wp_dump.sql


echo "##### Dump database wordpress"
mysqldump -u root -p$database_password --compatible=ansi --databases $database_name > "$wordpress_local_rootdir/$wp_dump"
# Optional: make SQL dump script genrated by MySQL 8.0.x compatible with MySQL 5.5.x execution.
sed -i "" "s/utf8mb4_0900_ai_ci/utf8mb4_unicode_ci/g" "$wordpress_local_rootdir/$wp_dump"
sed -i "" "s/utf8mb4_unicode_520_ci/utf8mb4_unicode_ci/g" "$wordpress_local_rootdir/$wp_dump"
# Migrate the domain server name
sed -i "" "s/http:\/\/$origin_site\//http:\/\/$dest_site\//g" "$wordpress_local_rootdir/$wp_dump"


echo "##### Files transfering"
rsync -havz --bwlimit=10000 --delete --log-format="%t %o %b %f" --progress --stats "$wordpress_local_rootdir/" -e "ssh -i $ssh_key" "$adm_user@$dest_server:$wordpress_remote_rootdir"

if test $? -gt 0; then
	currDate=$(date +"%Y/%m/%d %H:%M:%S")
	echo "$currDate !!! Files transfert error detected. Script needs to be reloaded !!!"
else
	echo "##### Connect to Internet serer to update Wordpress database"
	ssh -i $ssh_key $adm_user@$dest_server << EOF
		echo "##### Backup Comments table"
		mysqldump -u root -p$database_password $database_name wp_comments > $wordpress_remote_rootdir/comments_dump.sql
		echo "##### Reload remote database"
		mysql -u root -p$database_password $database_name < $wordpress_remote_rootdir/$wp_dump
		mysql -u root -p$database_password $database_name < $wordpress_remote_rootdir/comments_dump.sql
		exit
EOF
fi