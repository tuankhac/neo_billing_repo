delimiter $$
create DEFINER = `billing`@`localhost` function `new_cost_sub_conference`(
	pid varchar(100),
	pname varchar(100),
	pfrom_amount varchar(100),
	pto_amount varchar(100),
	pprice varchar(100),
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
		call access('new_cost_sub_conference|ERR',err);
		return err;
	end;
	call access('billing.cost_sub_conference|NEW',concat(pid,'|',pname,'|',pfrom_amount,'|',pto_amount,'|',pprice,'|',pnote,'|',pfrom_date,'|',pto_date));
	insert into billing.cost_sub_conference(id,name,from_amount,to_amount,price,note,from_date,to_date)
	values(pid,pname,pfrom_amount,pto_amount,pprice,pnote,str_to_date(pfrom_date,'%d/%c/%Y'),str_to_date(pto_date,'%d/%c/%Y'));
	return '1';
end $$
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` procedure `search_cost_sub_conference`(
	pid varchar(100),
	pname varchar(100),
	pfrom_amount varchar(100),
	pto_amount varchar(100),
	pprice varchar(100),
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
		call access('search_cost_sub_conference|ERR',err);
		select err;
	end;
	call access('billing.cost_sub_conference|SEARCH',pid,'|',pname,'|',pfrom_amount,'|',pto_amount,'|',pprice,'|',pnote,'|',pfrom_date,'|',pto_date);
	set s:='select * from billing.cost_sub_conference where 1=1';
 	if nullif(pid,'') is not null then 
		set s:= concat(s,' and id like ''',replace(pid,'*','%'),''''); 
	end if;
	if nullif(pname,'') is not null then 
		set s:= concat(s,' and name like ''',replace(pname,'*','%'),''''); 
	end if;
	if nullif(pfrom_amount,'') is not null then 
		set s:= concat(s,' and from_amount like ''',replace(pfrom_amount,'*','%'),''''); 
	end if;
	if nullif(pto_amount,'') is not null then 
		set s:= concat(s,' and to_amount like ''',replace(pto_amount,'*','%'),''''); 
	end if;
	if nullif(pprice,'') is not null then 
		set s:= concat(s,' and price like ''',replace(pprice,'*','%'),''''); 
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
create DEFINER = `billing`@`localhost` function edit_cost_sub_conference(
	pid varchar(100),
	pname varchar(100),
	pfrom_amount varchar(100),
	pto_amount varchar(100),
	pprice varchar(100),
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
		call access('edit_cost_sub_conference|ERR',err);
		return err;
	end;
	call access('billing.cost_sub_conference|EDIT',concat(pid,'|',pname,'|',pfrom_amount,'|',pto_amount,'|',pprice,'|',pnote,'|',pfrom_date,'|',pto_date));
	update billing.cost_sub_conference set  id=pid,name=pname,from_amount=pfrom_amount,to_amount=pto_amount,price=pprice,note=pnote,from_date=pfrom_date,to_date=pto_date where id=pid;
	return '1';
end $$ 
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` function del_cost_sub_conference(
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
		call access('del_cost_sub_conference|ERR',err);
		return err;
	end;
	call access('billing.cost_sub_conference|DEL',pId);
	delete from billing.cost_sub_conference where id=pid;
end;