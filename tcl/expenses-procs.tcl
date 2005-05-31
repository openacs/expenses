ad_library {

    	Expenses procs

	@author Hamilton Chua (hamilton.chua@gmail.com)
	@creation-date 2005-05-14
	@cvs-id $Id$
}

namespace eval expenses {

ad_proc get_package_id {

} {
	HAM (hamilton.chua@gmail.com)
	Return package_id of expenses package
} {
	return [apm_package_id_from_key expenses]
}

ad_proc mark_exported {
	{-id:required }
} {
	HAM (hamilton.chua@gmail.com)
	Mark the expense record as exported
} {
	db_dml "mark_exported" "update expenses set exp_exported = 't' where exp_id =:id"
}

ad_proc mark_all_exported {
	
} {
	HAM (hamilton.chua@gmail.com)
	Mark all expense records as exported
} {
	db_dml "mark_exported" "update expenses set exp_exported = 't'"
}

}