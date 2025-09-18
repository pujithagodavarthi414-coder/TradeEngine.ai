-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get PF Monthly Statement
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_PFMonthlyStatement] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_PFMonthlyStatement]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Month DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@UserId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
			
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
			
			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
            
           	IF(@Month IS NULL) SET @Month = GETDATE()
	        
			DECLARE @RunMonth NVARCHAR(100) = (SELECT DATENAME(MONTH,@Month) + ' ' + DATENAME(YEAR,@Month))
            
			DECLARE @ResignationApprovedId UNIQUEIDENTIFIER = (SELECT Id FROM ResignationStatus RS 
			                                                   WHERE RS.IsApproved = 1 AND RS.StatusName = 'Approved'
															         AND RS.InactiveDateTime IS NULL)

			 --DECLARE @RelationShipPriority TABLE
			 --(
				--Id INT,
				--RelationShipName NVARCHAR(250)
				--,RelationShipId UNIQUEIDENTIFIER
			 --)

			 --INSERT INTO @RelationShipPriority(Id,RelationShipName)
			 --VALUES (1,'Husband')
			 --        ,(2,'Father')
			 --        ,(3,'Mother')
			 --        ,(4,'Brother')

			 --UPDATE @RelationShipPriority SET RelationShipId = RS.Id
			 --FROM @RelationShipPriority RSP INNER JOIN RelationShip RS ON RSP.RelationShipName = RS.RelationShipName
			 --     AND RS.CompanyId = @CompanyId
				--  AND RS.InActiveDateTime IS NULL

            CREATE TABLE #PFDetails 
	        (
	        	ComponentName NVARCHAR(250)
	        	,EmployeeName NVARCHAR(250)
	        	,ComponentId UNIQUEIDENTIFIER
	        	,EmployeeId UNIQUEIDENTIFIER
	        	,EmployeeSalary DECIMAL(18,2)
	        	,EmployeeContribusion DECIMAL(18,2)
	        	,EmployeerContribusion DECIMAL(18,2)
	        	,TotalContribution DECIMAL(18,2)
	        	,PayrollRunId UNIQUEIDENTIFIER
	        	,CurrencyCode NVARCHAR(250)
	         )
	        
	         INSERT INTO #PFDetails(ComponentName,EmployeeName,ComponentId,EmployeeId,EmployeeSalary,PayrollRunId,CurrencyCode)
	         SELECT PC.ComponentName
	                ,PRE.EmployeeName
	                ,PREC.ComponentId
	        		,PRE.EmployeeId
	        		,PRE.EmployeeSalary
	        		,PRE.PayrollRunId
					,CU.CurrencyCode
	         FROM PayrollRunEmployee PRE
                    INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
					           AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)				 
                               AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
                    INNER JOIN Employee E ON E.Id = PRE.EmployeeId
                    INNER JOIN [User] U ON U.Id = E.UserId
	        		INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                        	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                    INNER JOIN (SELECT PRE.EmployeeId
                                      ,MAX(RunDate) AS RunDate
                    		        ,PRInner.RunMonth
                           FROM (SELECT PR.Id,PR.RunDate,DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) AS RunMonth 
                    	      FROM PayrollRun PR
							       INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							       INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
                    		  WHERE PR.InactiveDateTime IS NULL
	        						AND DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) = @RunMonth
                    		        AND PR.CompanyId = @CompanyId
	        						) PRInner
                                INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRInner.Id
                    		            AND PRE.InactiveDateTime IS NULL
                           GROUP BY PRE.EmployeeId,PRInner.RunMonth
                            ) RE ON RE.EmployeeId = PRE.EmployeeId AND RE.RunDate = PR.RunDate
                    INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId 
                              AND PREC.PayrollRunId = PRE.PayrollRunId
	        		INNER JOIN PayrollComponent PC ON PREC.ComponentId = PC.Id
                    		AND PC.ComponentName = 'PF'
	                LEFT JOIN PayrollTemplate PT ON PT.Id = PRE.PayrollTemplateId
                    LEFT JOIN SYS_Currency CU on CU.Id = PT.CurrencyId
	        		WHERE U.CompanyId = @CompanyId
	        			   AND (@IsActiveEmployeesOnly = 0 
	        			     OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
	        			   AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
	        			   AND (@UserId IS NULL OR @UserId = U.Id)
            GROUP BY PC.ComponentName,PREC.ComponentId,PRE.EmployeeId,PRE.EmployeeSalary,PRE.PayrollRunId,PRE.EmployeeName,CU.CurrencyCode
	        
	        UPDATE #PFDetails SET EmployeeContribusion = ABS(PREC.ActualComponentAmount)
	               FROM #PFDetails ED
	        	        INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = ED.EmployeeId 
                         	            AND PREC.PayrollRunId = ED.PayrollRunId
	        							AND (PREC.ComponentName = 'Employee ' + ED.ComponentName)
	        
	        UPDATE #PFDetails SET EmployeerContribusion = ABS(PREC.ActualComponentAmount)
	               FROM #PFDetails ED
	        	        INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = ED.EmployeeId 
                         	            AND PREC.PayrollRunId = ED.PayrollRunId
	        							AND (PREC.ComponentName = 'Employeer ' + ED.ComponentName)
	        
	        UPDATE #PFDetails SET TotalContribution = ISNULL(ED.EmployeeContribusion,0) + ISNULL(ED.EmployeerContribusion,0)
	        FROM #PFDetails ED
	        
            DECLARE @RecordsCount INT = (SELECT COUNT(1) FROM #PFDetails)

			IF(@RecordsCount > 0)
            BEGIN

	           SELECT PD.EmployeeName AS [Employee Name]
	                  ,E.EmployeeNumber AS [Employee Number]
	           	   ,EAD.PFNumber AS [PF Account Number]
	           	   ,CONVERT(VARCHAR,J.JoinedDate,106) AS [Date Of Joining]
	           	   ,D.DesignationName AS [Designation Name]
	           	   --,ECD.[Contact Person Name]
	           	   ,CONVERT(VARCHAR,E.DateofBirth,106) AS [Date of Birth]
	           	   ,G.Gender AS [Gender]
		  	      ,CONVERT(VARCHAR,ER.LastDate,106) AS [Date Of Leaving Service] 
	           	   ,PD.EmployeeContribusion AS [Employee Contribution]
	           	   ,PD.EmployeerContribusion AS [Employer Contribution]
	           	   ,PD.TotalContribution AS [Total]
	           FROM #PFDetails PD
	           INNER JOIN Employee E ON E.Id = PD.EmployeeId
	           LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = E.Id
		               AND EAD.InActiveDateTime IS NULL
	           LEFT JOIN Job J ON J.EmployeeId = E.Id
		               AND J.InActiveDateTime IS NULL
	           LEFT JOIN Designation D ON D.Id = J.DesignationId
		               AND D.InActiveDateTime IS NULL
	           --LEFT JOIN  (SELECT EEC.EmployeeId,EEC.FirstName + ' ' + ISNULL(EEC.LastName,'') AS [Contact Person Name] 
		  	        --   FROM [EmployeeEmergencyContact] EEC
		  	        --   INNER JOIN (
		           --                   SELECT RSPInner.EmployeeId,RSP.RelationshipId
		  	   	    --  		     FROM @RelationShipPriority RSP
		  	   	    --  		          INNER JOIN (
		  	   	    --  		                     SELECT EEC.EmployeeId,MIN(RSP.Id) AS OrderId
		           --                                     FROM  @RelationShipPriority RSP --ON RSP.RelationShipName = RS.RelationShipName
		           --                                           INNER JOIN [EmployeeEmergencyContact] EEC ON EEC.RelationshipId = RSP.RelationShipId
		  	   	    --  								              AND EEC.InActiveDateTime IS NULL
		           --                                     GROUP BY EmployeeId
		  	   	    --  						    ) RSPInner ON RSPInner.OrderId = RSP.Id
		  	   	    --  		) EECInner ON EEC.EmployeeId = EEC.EmployeeId AND EECInner.RelationShipId = EEC.RelationshipId				
		           --                AND EEC.InActiveDateTime IS NULL) ECD ON ECD.EmployeeId = E.Id
	           LEFT JOIN Gender G ON G.Id = E.GenderId
		               AND G.InActiveDateTime IS NULL
		       LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = E.Id
                         AND ER.ResignationStastusId = @ResignationApprovedId
		  	   	  AND ER.InactiveDateTime IS NULL
             -- UNION --ALL
             -- SELECT 'Total'
			          --,NULL
			          --,NULL
			          --,NULL
			          --,NULL
			          --,NULL
			          --,NULL
			          --,NULL
             --        --,COUNT(1)
             -- 	   ,SUM(EmployeeContribusion) AS EmployeeContribusion
             -- 	   ,SUM(EmployeerContribusion) AS EmployeerContribusion
             -- 	   --,SUM(EmployeeContribusionAsESIPortal) AS EmployeeContribusionAsESIPortal
             -- 	   ,SUM(TotalContribution) AS TotalContribution
             --    FROM #PFDetails
             --    WHERE @RecordsCount > 0
            END

		END
		ELSE
		BEGIN
			RAISERROR (@HavePermission,11, 1)
		END

	END TRY
	BEGIN CATCH
		THROW
	END CATCH

END
GO
