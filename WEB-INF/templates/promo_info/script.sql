insert into promo_info(ten_htkm,kmht_id,started_date,end_date,loai_tb,noimang,phi_dichvu,
			time_promo,time_promo_period,sms_promo,data_promo,ngay_tao,nguoi_tao,may_tao)
			
delimiter $$
create DEFINER = `billing`@`localhost` function `new_promo_info`(
	pkmht_id varchar(100),
	ppromo_id varchar(100),
	pten_htkm varchar(100),
	ploaiht_id varchar(100),
	pstarted_date varchar(100),
	pend_date varchar(100),
	ploai_tb varchar(100),
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
		call access('new_promo_info|ERR',err);
		return err;
	end;
	call access('billing.promo_info|NEW',concat(pkmht_id,'|',ppromo_id,'|',pten_htkm,'|',
		ploaiht_id,'|',pstarted_date,'|',pend_date,'|',ploai_tb));
	insert into billing.promo_info(kmht_id,promo_id,ten_htkm,kmcv_id,loaiht_id,camket_sdlt,tinhtao_ds,ghichu,nguoi_tao,ngay_tao,nguoi_cn,ngay_cn,may_tao,km_pttb_id,so_cv,phi_dichvu,chk_hm,hanmuc,is_upload,started_date,end_date,noimang,time_promo,time_promo_period,enable,loai_tb,sms_promo,data_promo,id_company)
	values(pkmht_id,ppromo_id,pten_htkm,pkmcv_id,ploaiht_id,pcamket_sdlt,ptinhtao_ds,pghichu,pnguoi_tao,str_to_date(pngay_tao,'%d/%c/%Y'),pnguoi_cn,str_to_date(pngay_cn,'%d/%c/%Y'),pmay_tao,pkm_pttb_id,pso_cv,pphi_dichvu,pchk_hm,phanmuc,pis_upload,str_to_date(pstarted_date,'%d/%c/%Y'),str_to_date(pend_date,'%d/%c/%Y'),pnoimang,ptime_promo,ptime_promo_period,penable,ploai_tb,psms_promo,pdata_promo,pid_company);
	return '1';
end $$
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` procedure `search_promo_info`(
	pkmht_id varchar(100),
	ppromo_id varchar(100),
	pten_htkm varchar(100),
	ploaiht_id varchar(100),
	pstarted_date varchar(100),
	pnoi_namg varchar(100),
	pend_date varchar(100),
	ploai_tb varchar(100),
	pUserId varchar(50),
	pUserIp	varchar(50))
begin
	declare s MEDIUMTEXT;
	declare exit handler for sqlexception
	begin
		declare err varchar(500);
		GET DIAGNOSTICS CONDITION 1
		@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		set err:=concat('Loi thuc hien, ma loi:',@p1,', ',@p2);
		call access('search_promo_info|ERR',err);
		select err;
	end;
	call access('billing.promo_info|NEW',concat(pkmht_id,'|',ppromo_id,'|',pten_htkm,'|',
		ploaiht_id,'|',pstarted_date,'|',pend_date,'|',ploai_tb,'|',pnoi_namg));
		
	set s:='select * from billing.promo_info where 1=1';
 	if nullif(pkmht_id,'') is not null then 
		set s:= concat(s,' and kmht_id like ''',replace(pkmht_id,'*','%'),''''); 
	end if;
	if nullif(ppromo_id,'') is not null then 
		set s:= concat(s,' and promo_id like ''',replace(ppromo_id,'*','%'),''''); 
	end if;
	if nullif(pten_htkm,'') is not null then 
		set s:= concat(s,' and ten_htkm like ''',replace(pten_htkm,'*','%'),''''); 
	end if;
	if nullif(ploaiht_id,'') is not null then 
		set s:= concat(s,' and loaiht_id like ''',replace(ploaiht_id,'*','%'),''''); 
	end if;
	if nullif(pstarted_date,'') is not null then 
		set s:= concat(s,' and started_date like ''',replace(pstarted_date,'*','%'),''''); 
	end if;
	if nullif(pend_date,'') is not null then 
		set s:= concat(s,' and end_date like ''',replace(pend_date,'*','%'),''''); 
	end if;
	if nullif(pnoi_namg,'') is not null then 
		set s:= concat(s,' and noimang like ''',replace(pnoi_namg,'*','%'),''''); 
	end if;
	set s:= concat(s,' order by promo_id');
	set @sql_ = xuly_phantrang(s,pPageIndex,pRecordPerPage);
	PREPARE stmt from  @sql_;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
end $$ 
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` function edit_promo_info(
	pkmht_id varchar(100),
	ppromo_id varchar(100),
	pten_htkm varchar(100),
	ploaiht_id varchar(100),
	pphi_dichvu varchar(100),
	pstarted_date varchar(100),
	pnoi_namg varchar(100),
	pend_date varchar(100),
	ploai_tb varchar(100),
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
		call access('edit_promo_info|ERR',err);
		return err;
	end;
	call access('billing.promo_info|NEW',concat(pkmht_id,'|',ppromo_id,'|',pten_htkm,'|',
		ploaiht_id,'|',pstarted_date,'|',pend_date,'|',ploai_tb,'|',pnoi_namg));
	update billing.promo_info set  kmht_id=pkmht_id,ten_htkm=pten_htkm,
		loaiht_id=ploaiht_id,phi_dichvu=pphi_dichvu,
		started_date=pstarted_date,end_date=pend_date,noimang=pnoimang,
		time_promo=ptime_promo,time_promo_period=ptime_promo_period,loai_tb=ploai_tb,
		sms_promo=psms_promo,data_promo=pdata_promo where promo_id=ppromo_id;
	return '1';
end $$ 
delimiter;
delimiter $$
create DEFINER = `billing`@`localhost` function del_promo_info(
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
		call access('del_promo_info|ERR',err);
		return err;
	end;
	call access('billing.promo_info|DEL',pId);
	delete from billing.promo_info where kmht_id=pid;
end;