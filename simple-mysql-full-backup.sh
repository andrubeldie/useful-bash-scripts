#!/bin/bash

# this script requires that in console there is no need to insert username and password
# to get this all you have to do is to set in ~/.my.cnf
# [client]
# pass="y_o_u_r_p_a_s_s_w_o_r_d"
# user=y_o_u_r_u_s_e_r_n_a_m_e

#please note the quotes for password

PATH_FOR_BACKUP=/var/backups/mysql

/usr/bin/mysqldump --all-databases --single-transaction | /bin/gzip > $PATH_FOR_BACKUP/all-databases-`date +%F-%H-%M`.sql.gz
