ad_library {
    
    APM Callbacks for Expenses
    
    @author Hamilton Chua (hamilton.chua@gmail.com)
    @creation-date 2005-05-26
    @cvs-id $Id$
}

namespace eval expenses { }

ad_proc -private expenses::after_install {
} {
    create the categories for expenses
    
} {
    set package_id [expenses::get_package_id]
    set tree_id [category_tree::add -name "Expense Codes"]
    category_tree::map -tree_id $tree_id -object_id $package_id
    set tree_id [category_tree::add -name "Expense Types"]
    category_tree::map -tree_id $tree_id -object_id $package_id
}
