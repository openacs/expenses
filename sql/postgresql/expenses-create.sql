-- Create Expense Item Object

select acs_object_type__create_type (
    'expense_item',        		-- content_type
    'Expense Item',	-- pretty_name
    'Expense Items',	-- pretty_plural
    'acs_object',     -- supertype
    'expenses',   -- table_name
    'exp_id',          -- id_column
    null,             -- package_name
    'f',              -- abstract_p
    null,             -- type_extension_table
    null 	      -- name_method
);

-- create expenses table
create table expenses (
	exp_id integer constraint exp_id_pk primary key,
	exp_expense varchar,
	exp_date timestamptz,
	exp_amount numeric,
	user_id integer references users(user_id),
	class_key varchar(100) references dotlrn_classes(class_key),
	community_id integer references dotlrn_communities_all(community_id),
	package_id integer,
	exp_exported boolean default 'f'
);

-- expenses functions
create or replace function expenses__new (
	integer, -- exp_id
	varchar, -- expense
	date,	 -- date
	float,   -- amount
	varchar, -- class_key
	integer, -- community_id
	integer, -- user_id
	integer, -- package_id
	varchar  -- creation_ip
) returns integer as '
declare
	p_exp_id alias for $1;
	p_expense alias for $2;
	p_date alias for $3;
	p_amount alias for $4;
	p_class_key alias for $5;
	p_community_id alias for $6;
	p_user_id alias for $7;
	p_package_id alias for $8;
	p_creation_ip alias for $9;
	v_exp_id integer;
begin
	v_exp_id := acs_object__new(
		p_exp_id,
		''expense_item'',
		current_timestamp,
		p_user_id,
		p_creation_ip,
		p_package_id
	);

	insert into expenses (
		exp_id,
		exp_expense,
		exp_date,
		exp_amount,
		user_id,
		class_key,
		community_id,
		package_id)
	values (
		v_exp_id,
		p_expense,
		p_date,
		p_amount,
		p_user_id,
		p_class_key,
		p_community_id,
		p_package_id
	);

	PERFORM acs_permission__grant_permission (
        	v_exp_id,
	    	-1,
	    	''read''
	);

	return v_exp_id;
end;
' language 'plpgsql';

create or replace function expenses__update (
	integer, -- exp_id
	varchar, -- expense
	date, 	 -- date
	float,   -- amount
	varchar, -- class_key
	integer, -- community_id
	integer -- user_id
) returns integer as '
declare
	p_exp_id alias for $1;
	p_expense alias for $2;
	p_date alias for $3;
	p_amount alias for $4;
	p_class_key alias for $5;
	p_community_id alias for $6;
	p_user_id alias for $7;
begin

	update expenses set 
		exp_expense = p_expense,
		exp_date = p_date,
		exp_amount = p_amount,
		user_id = p_user_id,
		class_key = p_class_key,
		community_id = p_community_id
	where exp_id = p_exp_id ;

	return p_exp_id;
end;
' language 'plpgsql';

-- kb_item delete function
create or replace function expenses__delete (
	integer -- exp_id to delete
)
returns boolean as '
declare
	p_exp_id alias for $1;
begin
	delete from expenses where exp_id = p_exp_id;
	PERFORM acs_object__delete(p_exp_id);
	return true;
end;
' language 'plpgsql';





