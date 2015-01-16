ALTER TABLE `m_loan_disbursement_detail`
	ADD COLUMN  `disbursal_order` INT(2) NOT NULL AFTER `approved_principal`;
	
update m_loan_disbursement_detail dd
inner join
(select a.id,a.rownum from
(select dd.id,dd.lid,
        @disbOrd:=if(@loanId=dd.lid,@disbOrd,0) + 1 as rownum,
        @loanId:=dd.lid from
(select ld.id,loan_id lid,ld.expected_disburse_date name
     from m_loan_disbursement_detail ld
     order by 2,3) dd) a) sl on sl.id=dd.id
     set disbursal_order=sl.rownum where sl.id=dd.id;