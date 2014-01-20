# programatically change password for an user
# echo "username:new_password" | /usr/sbin/chpasswd

# get top 10 subfolders in current folder based on size
# du -m . --max-depth=1 | sort -n -r | head -n 10

# gziped mysqldump saved as curent date-hour-minute.sql.gz
# mysqldump -u username -p -B database_name --single-transaction | gzip > /path_to_backup_folder/`date +%F-%H-%M.sql.gz`

# one liner to check/visualize magento's DB credentials
#head -n `cat app/etc/local.xml | grep -n "</connection>" | awk -F : '{print $1;}'` app/etc/local.xml | tail -n 11

# load CSV or any other file into a table in MySQL
# LOAD DATA LOCAL INFILE '/tmp/some_file.txt' INTO TABLE entries FIELDS TERMINATED BY ' | ' LINES TERMINATED BY '\n';

# export any result set from MySql query to CSV
# select * from table_name where 1 ... into outfile '/tmp/some_file_name.csv' fields terminated by ',' enclosed by '"' lines terminated by '\n';


# bulk rename files. it may not be available under other *nix than Debian/Ubuntu based distros
# dry run
# rename -n 's/seach_this_perl_regexp/replace_with_this_perl_regexp/' *.file.filter.*
# run
# rename -v 's/seach_this_perl_regexp/replace_with_this_perl_regexp/' *.file.filter.*
