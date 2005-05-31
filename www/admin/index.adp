<master>
<property name="title">@title@</property>

<a href="/categories/cadmin/one-object?object_id=@object_id@">Administer Expense Codes</a><br /><br />

<if @expenses:rowcount@ ne 0>
	<listtemplate name="expenses"></listtemplate>
</if>
<else>
	<p> No expenses have been recorded.
</else>

