<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_expenses">
      <querytext>
	select exp_id, exp_expense, to_char(exp_date,'MM-DD-YYYY') as exp_date, exp_amount, exp_exported, package_id, community_id from expenses $orderby_clause
      </querytext>
</fullquery>

</queryset>