delimiter $$
create DEFINER = `billing`@`localhost` function `new_company_information`(
	pcompany_id varchar(100),
	pcompany_name varchar(100),
	pmvpn_users varchar(100),
	pmpbx_users varchar(100),
	pconference_users varchar(100),
	pmpbx_main_numbers varchar(100),
	pbilling_cycle_day varchar(100),
	pcreated varchar(100),
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
		call access('new_company_information|ERR',err);
		return err;
	end;
	call access('billing.company_information|NEW',concat(pcompany_id,'|',pcompany_name,'|',pmvpn_users,'|',pmpbx_users,'|',pconference_users,'|',pmpbx_main_numbers,'|',pbilling_cycle_day,'|',pcreated));
	insert into billing.company_information(company_id,company_name,mvpn_users,mpbx_users,conference_users,mpbx_main_numbers,billing_cycle_day,created)
	values(pcompany_id,pcompany_name,pmvpn_users,pmpbx_users,pconference_users,pmpbx_main_numbers,pbilling_cycle_day,pcreated);
	return '1';
end $$
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` procedure `search_company_information`(
	pcompany_id varchar(100),
	pcompany_name varchar(100),
	pmvpn_users varchar(100),
	pmpbx_users varchar(100),
	pconference_users varchar(100),
	pmpbx_main_numbers varchar(100),
	pbilling_cycle_day varchar(100),
	pcreated varchar(100),
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
		call access('search_company_information|ERR',err);
		select err;
	end;
	call access('billing.company_information|SEARCH',pcompany_id,'|',pcompany_name,'|',pmvpn_users,'|',pmpbx_users,'|',pconference_users,'|',pmpbx_main_numbers,'|',pbilling_cycle_day,'|',pcreated);
	set s:='select * from billing.company_information where 1=1';
 	if nullif(pcompany_id,'') is not null then 
		set s:= concat(s,' and company_id like ''',replace(pcompany_id,'*','%'),''''); 
	end if;
	if nullif(pcompany_name,'') is not null then 
		set s:= concat(s,' and company_name like ''',replace(pcompany_name,'*','%'),''''); 
	end if;
	if nullif(pmvpn_users,'') is not null then 
		set s:= concat(s,' and mvpn_users like ''',replace(pmvpn_users,'*','%'),''''); 
	end if;
	if nullif(pmpbx_users,'') is not null then 
		set s:= concat(s,' and mpbx_users like ''',replace(pmpbx_users,'*','%'),''''); 
	end if;
	if nullif(pconference_users,'') is not null then 
		set s:= concat(s,' and conference_users like ''',replace(pconference_users,'*','%'),''''); 
	end if;
	if nullif(pmpbx_main_numbers,'') is not null then 
		set s:= concat(s,' and mpbx_main_numbers like ''',replace(pmpbx_main_numbers,'*','%'),''''); 
	end if;
	if nullif(pbilling_cycle_day,'') is not null then 
		set s:= concat(s,' and billing_cycle_day like ''',replace(pbilling_cycle_day,'*','%'),''''); 
	end if;
	if nullif(pcreated,'') is not null then 
		set s:= concat(s,' and created like ''',replace(pcreated,'*','%'),''''); 
	end if;
	set s:= concat(s,' order by id');
	set @sql_ = xuly_phantrang(s,pPageIndex,pRecordPerPage);
	PREPARE stmt from  @sql_;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
end $$ 
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` function edit_company_information(
	pcompany_id varchar(100),
	pcompany_name varchar(100),
	pmvpn_users varchar(100),
	pmpbx_users varchar(100),
	pconference_users varchar(100),
	pmpbx_main_numbers varchar(100),
	pbilling_cycle_day varchar(100),
	pcreated varchar(100),
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
		call access('edit_company_information|ERR',err);
		return err;
	end;
	call access('billing.company_information|EDIT',concat(pcompany_id,'|',pcompany_name,'|',pmvpn_users,'|',pmpbx_users,'|',pconference_users,'|',pmpbx_main_numbers,'|',pbilling_cycle_day,'|',pcreated));
	update billing.company_information set  company_id=pcompany_id,company_name=pcompany_name,mvpn_users=pmvpn_users,mpbx_users=pmpbx_users,conference_users=pconference_users,mpbx_main_numbers=pmpbx_main_numbers,billing_cycle_day=pbilling_cycle_day,created=pcreated where id=pid;
	return '1';
end $$ 
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` function del_company_information(
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
		call access('del_company_information|ERR',err);
		return err;
	end;
	call access('billing.company_information|DEL',pId);
	delete from billing.company_information where id=pid;
end;