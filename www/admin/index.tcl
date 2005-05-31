ad_page_contract {

    List line expenses for a given class
    
    @author Hamilton Chua (hamilton.chua@gmail.com)
    @creation-date 2005-05-14
    @cvs-id $Id$

} {
	orderby:optional
}

set title "Expenses"
set context $title
set package_id [expenses::get_package_id]
set object_id $package_id

# use list template to create list of expenses

template::list::create \
    -name expenses \
    -multirow expenses \
    -key exp_id \
    -actions {
            "Export All and MARK ALL Transferred" "export-confirm?all=1&mark=1" "Export All Expenses"
    	    "Export All but DO NOT MARK Transferred" "export-confirm?all=1&mark=0" "Export Expenses"
    } -elements {
	exp_date {
		label "Date"
	}
	exp_expense {
		label "Expense"
	}
	exp_amount {
		label "Amount"
		aggregate "sum"
		aggregate_label "Total :  $"
		display_template { $ @expenses.exp_amount;noquote@ }
	}
	course {
		label "Course/Section"
	}
	exp_exported {
		label "Exported"
		display_template { 
			<if @expenses.exp_exported@ eq "t">
				Yes
			</if>
			<else>
				No
			</else>
		}
	}
    } -orderby {
	exp_date { orderby exp_date }
	exp_amount { orderby exp_amount }
    } 

# build the multirow

set orderby_clause "[template::list::orderby_clause -name expenses -orderby]"

db_multirow -extend {course} expenses get_expenses { } {
	# retrieve course/section for this expense
	db_0or1row "section_info" "select section_name, course_id from dotlrn_ecommerce_section where community_id =:community_id"
	set course_name [db_string "getcoursename" "select course_name from dotlrn_catalog where course_id = (select latest_revision from cr_items where item_id =:course_id)"]
	set course "$course_name/$section_name"
}