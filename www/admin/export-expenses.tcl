ad_page_contract {

    Generate a CSV of the given exp_id
    
    @author Hamilton Chua (hamilton.chua@gmail.com)
    @creation-date 2005-05-14
    @cvs-id $Id$

}  {
   {exp_id:integer,multiple,optional}
   {all 0}
   {mark 0}
}

set title "Export Expenses"
set context $title

# generate list of exp_item_id's for export
if { [exists_and_not_null exp_id] } {
	for {set i 0} {$i < [llength $exp_id]} {incr i} {
    		set id_$i [lindex $exp_id $i]
    		lappend bind_id_list ":id_$i"
	}
}

# use list template to create list of expenses

template::list::create \
    -name expenses \
    -multirow expenses \
    -key exp_id \
    -selected_format csv \
    -formats {
        csv { output csv }
    } -elements {
	exp_date {
		label "Date"
	}
	exp_expense {
		label "Expense"
	}
	exp_amount {
		label "Amount"
		display_template { $ @expenses.exp_amount;noquote@ }
	}
	community_id {
		label "Community"
	}
	expense_codes {
		label "Expense Codes"
	}
	expense_types {
		label "Expense Types"
	}
    } 

# build the multirow

set query "select exp_id, exp_amount, exp_date, exp_expense, user_id, community_id from expenses where exp_exported = false"

# Save for Later in case we want 
# to bring back selective exports

#if { $all == 0 } {		
#	set items_for_export [join $bind_id_list ","]
#	append query " and exp_id in ( $items_for_export )"
	# mark id's as exported only if $mark ==1
#	if { $mark == 1 } {
#		foreach id $exp_id {
#			expenses::mark_exported -id $id
#		}
#	}
#} else {
#}


db_multirow -extend {expense_codes expense_types} expenses get_expenses $query {
	set expense_codes [expenses::list_expense_codes -id $exp_id]
	set expense_types [expenses::list_expense_types -id $exp_id]
}

if { $mark == 1 } {
	expenses::mark_all_exported
}

# change headers to output csv
set outputheaders [ns_conn outputheaders]
ns_set cput $outputheaders "Content-Disposition" "attachment; filename=expenses.csv"
template::list::write_output -name expenses
