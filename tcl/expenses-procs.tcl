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

ad_proc list_expense_codes {
	{-id:required }
} {
	HAM (hamilton.chua@gmail.com)
	Return comma separated list of expense codes given an expense id
} {
	set expense_codes ""
	# Get category tree id of expense code
	set package_id [expenses::get_package_id]
	set tree_list [category_tree::get_mapped_trees $package_id]
	foreach tree $tree_list {
		if { [lindex $tree 1] == "Expense Codes"} {
			set tree_id [lindex $tree 0]
		}
	}
	if { [exists_and_not_null tree_id] } {
		set categories [category::get_mapped_categories -tree_id $tree_id $id]
		foreach category_id $categories {
			append expense_codes "[category::get_name $category_id]"
		}
		return [join $expense_codes ", "]
	} else {
		return ""
	}
}

ad_proc list_expense_types {
	{-id:required }
} {
	HAM (hamilton.chua@gmail.com)
	Return comma separated list of expense types given an expense id
} {
	set expense_types ""
	# Get category tree id of expense type
	set package_id [expenses::get_package_id]
	set tree_list [category_tree::get_mapped_trees $package_id]
	foreach tree $tree_list {
		if { [lindex $tree 1] == "Expense Types"} {
			set tree_id [lindex $tree 0]
		}
	}	
	if { [exists_and_not_null tree_id] } {
		set categories [category::get_mapped_categories -tree_id $tree_id $id]
		foreach category_id $categories {
			append expense_types "[category::get_name $category_id]"
		}
		return [join $expense_types ", "]
	} else {
		return ""
	}
}

ad_proc list_terms {
	{-id:required }
} {
	HAM (hamilton.chua@gmail.com)
	Return comma separated list of TERMS (e.g Fall, Winter)
	of the section that this expense belongs to
	Return null if section is not categorized under any term
} {
	# we got an expense id, let's get the community id of the section it belongs to
	set package_id [db_string "getpackageid" "select community_id from expenses where exp_id = :id"]

	# get the tree id of the terms category

	if { [db_0or1row "get_treeid" "select tree_id from category_tree_translations where name = 'Terms'"] } {

		set terms [list]
		set categories [category::get_mapped_categories $package_id]
		foreach category_id $categories {
			if { [category::get_tree $category_id] == $tree_id } {
				lappend terms "[category::get_name $category_id]"
			}
		}
		return [join $terms ", "]
	} else {
		return ""
	}
}


}