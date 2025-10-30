USE CBSTeller_VCBVN

DECLARE @FROMDATE VARCHAR(10);
DECLARE @TODATE VARCHAR(10);
DECLARE @Branch INT;
SET @FROMDATE = '2020-04-26';
SET @TODATE = '2020-04-26';
SET @Branch = 0

IF @Branch <> 0
    SELECT B.Teller , C.UserId, A.* 
    FROM [CBSTeller_VCBVN].[dbo].[J_Tran] AS A , 
          [CBSTeller_VCBVN].[dbo].[ProcessingDay] AS B,
    	  [CBSTeller_VCBVN].[dbo].Users AS C
    WHERE 
             A.BranchNumber = @Branch
    	AND  A.Tran_Status in (1,6) 
    	AND  (A.Transaction_Amount <> 0.0 OR A.Net_Transaction_Amount <> 0.0 OR A.Cash_In <> 0.0 OR
		      A.Carried_Cash_In <> 0.0 OR A.Cheques_In <> 0.0 OR A.Cheques_In_No_Float <> 0.0 OR
			  A.Cheques_In_Float_1 <> 0.0 OR A.Cheques_In_Float_2 <> 0.0 OR A.Cheques_In_Float_3 <> 0.0 OR
			  A.Cheques_In_Float_4 <> 0.0 OR A.Cheques_Out <> 0.0 OR A.Cash_Back <> 0.0
			  ) 
    	AND  (convert(varchar(10),A.Posting_Date, 120) BETWEEN @FROMDATE and @TODATE) 
    	AND  (A.Header_Id = B.Pday_Id AND B.BranchNumber = A.BranchNumber) 
    	AND  (B.Teller = C.TellerId AND B.BranchNumber = C.BranchNumber)
    ORDER By 
           A.Posting_Date DESC, A.ReenterTime DESC 
ELSE
    SELECT B.Teller , C.UserId, A.* 
    FROM [CBSTeller_VCBVN].[dbo].[J_Tran] AS A , 
              [CBSTeller_VCBVN].[dbo].[ProcessingDay] AS B,
        	  [CBSTeller_VCBVN].[dbo].Users AS C
    WHERE 
             A.BranchNumber IN (SELECT BranchNumber FROM BranchOptions WHERE BranchNumber != 1) 
        AND  A.Tran_Status in (1,6)  
        AND  (A.Transaction_Amount <> 0.0 OR A.Net_Transaction_Amount <> 0.0 OR A.Cash_In <> 0.0 OR
		      A.Carried_Cash_In <> 0.0 OR A.Cheques_In <> 0.0 OR A.Cheques_In_No_Float <> 0.0 OR
			  A.Cheques_In_Float_1 <> 0.0 OR A.Cheques_In_Float_2 <> 0.0 OR A.Cheques_In_Float_3 <> 0.0 OR
			  A.Cheques_In_Float_4 <> 0.0 OR A.Cheques_Out <> 0.0 OR A.Cash_Back <> 0.0
			  ) 
        AND  (convert(varchar(10),A.Posting_Date, 120) BETWEEN @FROMDATE and @TODATE) 
        AND  (A.Header_Id = B.Pday_Id AND B.BranchNumber = A.BranchNumber) 
        AND  (B.Teller = C.TellerId AND B.BranchNumber = C.BranchNumber)
    ORDER By 
            A.Posting_Date DESC, A.ReenterTime DESC 
