delimiter $$
create DEFINER = `billing`@`localhost` function `new_cost_voice_group`(
	pgroup_id varchar(100),
	pgroup_name varchar(100),
	pnote varchar(100),
	pUserId varchar(50),
	pUserIp	varchar(50))
returns varchar(1000) CHARSET utf8 
begin
	declare s varchar(1000);
	declare exit handler for sqlexception
	begin
		declare err varchar(500);
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		set err:=concat('Loi thuc hien, ma loi:',@p1,', ',@p2);
		call access('new_cost_voice_group|ERR',err);
		return err;
	end;
	call access('billing.cost_voice_group|NEW',concat(pgroup_id,'|',pgroup_name,'|',pnote));
	insert into billing.cost_voice_group(group_id,group_name,note)
	values(pgroup_id,pgroup_name,pnote);
	return '1';
end $$
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` procedure `search_cost_voice_group`(
	pgroup_id varchar(100),
	pgroup_name varchar(100),
	pnote varchar(100),
	pRecordPerPage varchar(50),
	pPageIndex varchar(50),
	pUserId varchar(100),
	pUserIp	varchar(100))

begin
	declare s MEDIUMTEXT;
	declare exit handler for sqlexception
	begin
		declare err varchar(500);
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		set err:=concat('Loi thuc hien, ma loi:',@p1,', ',@p2);
		call access('search_cost_voice_group|ERR',err);
		select err;
	end;
	call access('billing.cost_voice_group|SEARCH',pgroup_id,'|',pgroup_name,'|',pnote);
	set s:='select * from billing.cost_voice_group where 1=1';
 	if nullif(pgroup_id,'') is not null then 
		set s:= concat(s,' and group_id like ''',replace(pgroup_id,'*','%'),''''); 
	end if;
	if nullif(pgroup_name,'') is not null then 
		set s:= concat(s,' and group_name like ''',replace(pgroup_name,'*','%'),''''); 
	end if;
	if nullif(pnote,'') is not null then 
		set s:= concat(s,' and note like ''',replace(pnote,'*','%'),''''); 
	end if;
	set s:= concat(s,' order by id');
	set @sql_ = xuly_phantrang(s,pPageIndex,pRecordPerPage);
	PREPARE stmt from  @sql_;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
end $$ 
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` function edit_cost_voice_group(
	pgroup_id varchar(100),
	pgroup_name varchar(100),
	pnote varchar(100),
	pUserId varchar(50),
	pUserIp	varchar(50))
returns varchar(1000) charset utf8
begin
	declare exit handler for sqlexception
	begin
		declare err varchar(500);
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		set err:=concat('Loi thuc hien, ma loi:',@p1,', ',@p2);
		call access('edit_cost_voice_group|ERR',err);
		return err;
	end;
	call access('billing.cost_voice_group|EDIT',concat(pgroup_id,'|',pgroup_name,'|',pnote));
	update billing.cost_voice_group set  group_id=pgroup_id,group_name=pgroup_name,note=pnote where id=pid;
	return '1';
end $$ 
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` function del_cost_voice_group(
	pId	varchar(100),
	pUserId varchar(50),
	pUserIp	varchar(50))
returns varchar(1000) charset utf8
begin
	declare exit handler for sqlexception
	begin
		declare err varchar(500);
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		set err:=concat('Loi thuc hien, ma loi:',@p1,', ',@p2);
		call access('del_cost_voice_group|ERR',err);
		return err;
	end;
	call access('billing.cost_voice_group|DEL',pId);
	delete from billing.cost_voice_group where id=pid;
end;