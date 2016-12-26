#!/usr/bin/env bash

cd /var/www
sed -i "s/## End - Joomla! core SEF Section./## End - Joomla! core SEF Section.\nphp_value upload_max_filesize 8M/" htaccess.txt
mv htaccess.txt .htaccess