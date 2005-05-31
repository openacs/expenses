-- drop related acs_objects

-- delete all expense item records
create function inline_0 ()
returns integer as '
declare
	exp_rec			record;
begin

	-- iterate through all entries
	for exp_rec in select exp_id from expenses loop
		perform expenses__delete( exp_rec.exp_id );
	end loop;

	return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

--  drop exepense table
drop table expenses;

-- drop functions
drop function expenses__new (
	integer, -- exp_id
	varchar, -- expense
	date, 	 -- date
	float,   -- amount
	varchar, -- class_key
	integer, -- community_id
	integer, -- user_id
	integer, -- package_id
	varchar  -- creation_ip
);

drop function expenses__update (
	integer, -- exp_id
	varchar, -- expense
	date, 	 -- date
	float,   -- amount
	varchar, -- class_key
	integer, -- community_id
	integer -- user_id
);

drop function expenses__delete (
	integer -- exp_id to delete
);

-- drop acs_object_type
select acs_object_type__drop_type ('expense_item', true);
