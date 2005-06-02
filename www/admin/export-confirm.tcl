ad_page_contract {
	Confirmation page to export and mark exported

	@author Hamilton Chua (hamilton.chua@gmail.com)
	@creation-date 2005-05-16
	@cvs-id $Id$

}  {
	{ exp_id:integer,multiple,optional }
	{ all 0 }
	{ mark 0 }
}

set title "Export"
set package_id [ad_conn package_id]
set package_url [apm_package_url_from_id $package_id]
set qstring ""
set content ""

#if { $all == 1 } {
#	set qstring "all=1&"
#} else {
#	if { [exists_and_not_null exp_id] } {
#		set exp_id_string [join $exp_id "&exp_id="]
#		append qstring "exp_id=$exp_id_string"
#	} else {
#		ad_return_complaint 1 "You must choose the expenses you wish to export."
#	}
#}

# let's check first if there are unmarked items for export
if { [db_string "count_transferred" "select count(*) from expenses where exp_exported = false"] > 0  } {
	append content "<p>Click the download link to start downloading the exported records in CSV format.</p>"
	set qstring "all=$all&mark=$mark"
	
	if { [exists_and_not_null exp_id] } {
		set exp_id_string [join $exp_id "&exp_id="]
		append qstring "&exp_id=$exp_id_string"
	}
	append content "<br /><a href=\"export-expenses?$qstring\">Download CSV.</a>"
} else {
	append content "<br />Sorry, but all expense records have been MARKED transferred.<br /> There are no expense records for transfer."
}
append content "<br /><a href=\"$package_url/admin\">Go back to Expense Tracking Administration.</a>"