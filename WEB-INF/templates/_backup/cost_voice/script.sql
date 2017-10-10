delimiter $$
create DEFINER = `billing`@`localhost` function `new_cost_voice`(
	pid varchar(100),
	pname varchar(100),
	pfrom_minute varchar(100),
	pto_minute varchar(100),
	pprice varchar(100),
	pgroup_id varchar(100),
	pfree varchar(100),
	pnote varchar(100),
	pfrom_date varchar(100),
	pto_date varchar(100),
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
		call access('new_cost_voice|ERR',err);
		return err;
	end;
	call access('billing.cost_voice|NEW',concat(pid,'|',pname,'|',pfrom_minute,'|',pto_minute,'|',pprice,'|',pgroup_id,'|',pfree,'|',pnote,'|',pfrom_date,'|',pto_date));
	insert into billing.cost_voice(id,name,from_minute,to_minute,price,group_id,free,note,from_date,to_date)
	values(pid,pname,pfrom_minute,pto_minute,pprice,pgroup_id,pfree,pnote,str_to_date(pfrom_date,'%d/%c/%Y'),str_to_date(pto_date,'%d/%c/%Y'));
	return '1';
end $$
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` procedure `search_cost_voice`(
	pid varchar(100),
	pname varchar(100),
	pfrom_minute varchar(100),
	pto_minute varchar(100),
	pprice varchar(100),
	pgroup_id varchar(100),
	pfree varchar(100),
	pnote varchar(100),
	pfrom_date varchar(100),
	pto_date varchar(100),
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
		call access('search_cost_voice|ERR',err);
		select err;
	end;
	call access('billing.cost_voice|SEARCH',pid,'|',pname,'|',pfrom_minute,'|',pto_minute,'|',pprice,'|',pgroup_id,'|',pfree,'|',pnote,'|',pfrom_date,'|',pto_date);
	set s:='select * from billing.cost_voice where 1=1';
 	if nullif(pid,'') is not null then 
		set s:= concat(s,' and id like ''',replace(pid,'*','%'),''''); 
	end if;
	if nullif(pname,'') is not null then 
		set s:= concat(s,' and name like ''',replace(pname,'*','%'),''''); 
	end if;
	if nullif(pfrom_minute,'') is not null then 
		set s:= concat(s,' and from_minute like ''',replace(pfrom_minute,'*','%'),''''); 
	end if;
	if nullif(pto_minute,'') is not null then 
		set s:= concat(s,' and to_minute like ''',replace(pto_minute,'*','%'),''''); 
	end if;
	if nullif(pprice,'') is not null then 
		set s:= concat(s,' and price like ''',replace(pprice,'*','%'),''''); 
	end if;
	if nullif(pgroup_id,'') is not null then 
		set s:= concat(s,' and group_id like ''',replace(pgroup_id,'*','%'),''''); 
	end if;
	if nullif(pfree,'') is not null then 
		set s:= concat(s,' and free like ''',replace(pfree,'*','%'),''''); 
	end if;
	if nullif(pnote,'') is not null then 
		set s:= concat(s,' and note like ''',replace(pnote,'*','%'),''''); 
	end if;
	if nullif(pfrom_date,'') is not null then 
		set s:= concat(s,' and from_date like ''',replace(pfrom_date,'*','%'),''''); 
	end if;
	if nullif(pto_date,'') is not null then 
		set s:= concat(s,' and to_date like ''',replace(pto_date,'*','%'),''''); 
	end if;
	set s:= concat(s,' order by id');
	set @sql_ = xuly_phantrang(s,pPageIndex,pRecordPerPage);
	PREPARE stmt from  @sql_;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
end $$ 
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` function edit_cost_voice(
	pid varchar(100),
	pname varchar(100),
	pfrom_minute varchar(100),
	pto_minute varchar(100),
	pprice varchar(100),
	pgroup_id varchar(100),
	pfree varchar(100),
	pnote varchar(100),
	pfrom_date varchar(100),
	pto_date varchar(100),
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
		call access('edit_cost_voice|ERR',err);
		return err;
	end;
	call access('billing.cost_voice|EDIT',concat(pid,'|',pname,'|',pfrom_minute,'|',pto_minute,'|',pprice,'|',pgroup_id,'|',pfree,'|',pnote,'|',pfrom_date,'|',pto_date));
	update billing.cost_voice set  id=pid,name=pname,from_minute=pfrom_minute,to_minute=pto_minute,price=pprice,group_id=pgroup_id,free=pfree,note=pnote,from_date=pfrom_date,to_date=pto_date where id=pid;
	return '1';
end $$ 
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` function del_cost_voice(
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
		call access('del_cost_voice|ERR',err);
		return err;
	end;
	call access('billing.cost_voice|DEL',pId);
	delete from billing.cost_voice where id=pid;
end;