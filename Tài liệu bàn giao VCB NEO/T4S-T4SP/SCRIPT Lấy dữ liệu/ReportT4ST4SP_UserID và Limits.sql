
USE CBSTeller_VCBVN

	SELECT DISTINCT A.BranchNumber, A.UserId,  A.TellerId AS 'Teller Number', A.Name AS 'Tên cán bộ',
       A.DepartmentCode AS 'Mã phòng', C.Description AS 'Tên phòng', 'ACTIVE' AS 'Quyền truy cập'
	   ,CASE B.OverrideAuthority 
            WHEN 1 THEN 'Supper' 
	        WHEN 2 THEN 'Officer'  
	        WHEN 0 THEN 'Teller' END  AS 'Sup/Teller' 
		,E.OnlineCreditLimit AS 'OnlineCreditLimit_CurrentAccountLimits'
		,E.OnlineDebitLimit AS 'OnlineDebitLimit_CurrentAccountLimits'
		,E.OnlineCashInLimit AS 'OnlineCashInLimit_CurrentAccountLimits'
		,E.OnlineCashOutLimit AS 'OnlineCashOutLimit_CurrentAccountLimits'
		,E.OnlineChequeInLimit AS 'OnlineChequeInLimit_CurrentAccountLimits'
		,E.OnlineChequeOutLimit AS 'OnlineChequeOutLimit_CurrentAccountLimits'

		,F.OnlineCreditLimit AS 'OnlineCreditLimit_SavingsAccountLimits'
		,F.OnlineDebitLimit AS 'OnlineDebitLimit_SavingsAccountLimits'
		,F.OnlineCashInLimit AS 'OnlineCashInLimit_SavingsAccountLimits'
		,F.OnlineCashOutLimit AS 'OnlineCashOutLimit_SavingsAccountLimits'
		,F.OnlineChequeInLimit AS 'OnlineChequeInLimit_SavingsAccountLimits'
		,F.OnlineChequeOutLimit AS 'OnlineChequeOutLimit_SavingsAccountLimits'

		,G.OnlineCreditLimit AS 'OnlineCreditLimit_TimeAccountLimits'
		,G.OnlineDebitLimit AS 'OnlineDebitLimit_TimeAccountLimits'
		,G.OnlineCashInLimit AS 'OnlineCashInLimit_TimeAccountLimits'
		,G.OnlineCashOutLimit AS 'OnlineCashOutLimit_TimeAccountLimits'
		,G.OnlineChequeInLimit AS 'OnlineChequeInLimit_TimeAccountLimits'
		,G.OnlineChequeOutLimit AS 'OnlineChequeOutLimit_TimeAccountLimits'

		,H.OnlineCreditLimit AS 'OnlineCreditLimit_LoanAccountLimits'
		,H.OnlineDebitLimit AS 'OnlineDebitLimit_LoanAccountLimits'
		,H.OnlineCashInLimit AS 'OnlineCashInLimit_LoanAccountLimits'
		,H.OnlineCashOutLimit AS 'OnlineCashOutLimit_LoanAccountLimits'
		,H.OnlineChequeInLimit AS 'OnlineChequeInLimit_LoanAccountLimits'
		,H.OnlineChequeOutLimit AS 'OnlineChequeOutLimit_LoanAccountLimits'
		,T.TillNumber
		,T.TillLimitProfileId
		

FROM  Users AS A, SecurityProfiles AS B , Departments AS C , TransactionLimits AS D,  Tills AS T,
     (SELECT DISTINCT D.*, B.ProfileId FROM SecurityProfiles AS B , TransactionLimits AS D
		   WHERE B.CurrentAccountLimits = D.TranLimitId) AS E,
	 (SELECT DISTINCT  D.*, B.ProfileId FROM SecurityProfiles AS B , TransactionLimits AS D
		   WHERE B.SavingsAccountLimits = D.TranLimitId) AS F,
	 (SELECT DISTINCT D.*, B.ProfileId FROM SecurityProfiles AS B , TransactionLimits AS D
		   WHERE B.TimeAccountLimits = D.TranLimitId) AS G,
	 (SELECT DISTINCT D.*, B.ProfileId FROM SecurityProfiles AS B , TransactionLimits AS D
		   WHERE B.LoanAccountLimits = D.TranLimitId) AS H

WHERE A.SecurityProfileId = B.ProfileId 
      AND B.OverrideAuthority IS NOT NULL 
	  AND (A.BranchNumber = C.BranchNumber AND A.DepartmentCode = C.DepartmentCode)
	  --AND C.DepartmentCode IN(98, 134, 165)
	  AND (B.ProfileId  = E.ProfileId )
	  AND (A.SecurityProfileId = F.ProfileId )
	  AND (A.SecurityProfileId = G.ProfileId )
	  AND (A.SecurityProfileId = H.ProfileId )
	  AND (A.TellerId =  T.TillNumber AND A.BranchNumber = T.BranchNumber)
