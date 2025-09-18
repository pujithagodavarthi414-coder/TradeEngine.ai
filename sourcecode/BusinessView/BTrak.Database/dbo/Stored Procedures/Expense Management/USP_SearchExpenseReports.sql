---------------------------------------------------------------------------------
---- Author       Aswani Katam
---- Created      '2019-02-04 00:00:00.000'
---- Purpose      To search expense reports
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
----EXEC USP_SearchExpenseReports @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
---------------------------------------------------------------------------------
--CREATE PROCEDURE [dbo].[USP_SearchExpenseReports]
--(
--  @ExpenseReportId UNIQUEIDENTIFIER = NULL,
--  @DurationFrom DATETIME = NULL,
--  @DurationTo DATETIME = NULL,
--  @ReportStatusId UNIQUEIDENTIFIER = NULL,
--  @IsReimbursed BIT = NULL,
--  @IsApproved  BIT = NULL,
--  @SearchText NVARCHAR(500) = NULL,
--  @SortBy NVARCHAR(100) = NULL,
--  @SortDirection NVARCHAR(50)=NULL,
--  @PageSize INT = NULL,
--  @PageNumber INT = NULL,
--  @OperationsPerformedBy UNIQUEIDENTIFIER,		
--  @IsArchived BIT = NULL
--)
--AS
--BEGIN
--     SET NOCOUNT ON
--     BEGIN TRY
--     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
--		       IF(@ExpenseReportId = '00000000-0000-0000-0000-000000000000') SET @ExpenseReportId = NULL

--		       IF(@ReportStatusId = '00000000-0000-0000-0000-000000000000') SET @ReportStatusId = NULL
		   
--		       IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

--		       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

--	           IF(@SearchText = '') SET  @SearchText = NULL

--			   SET @SearchText = '%'+ @SearchText +'%'
		     
--		       IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
		     
--		       IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
		     
--		       IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [ExpenseReport])

--			   IF(@PageSize = 0) SET @PageSize = 10
		     
--		       IF(@PageNumber IS NULL) SET @PageNumber = 1
	            
--		       SELECT ER.[OriginalId] ExpenseReportId,
--					  ER.[ReportTitle],
--					  ER.[BusinessPurpose],
--					  ER.[DurationFrom],
--					  ER.[DurationTo],
--					  ER.[ReportStatusId],
--					  ER.[AdvancePayment],
--					  ER.[AmountToBeReimbursed],
--					  ER.[UndoReimbursement],
--					  ER.[IsReimbursed],
--					  ER.[IsApproved],	
--					  ER.[ReasonForApprovalOrRejection],
--					  ER.[CreatedByUserId],
--					  ER.[CreatedDateTime],
--					  ER.[SubmittedByUserId],
--					  ER.[SubmittedDateTime],
--					  ER.[ReimbursedByUserId],
--					  ER.[ReimbursedDateTime],
--					  ER.[ApprovedOrRejectedByUserId],
--					  ER.[ApprovedOrRejectedDateTime],
--					  ERS.[Name] StatusName,
--		              TotalCount = COUNT(1) OVER()
--		       FROM  [dbo].[ExpenseReport] ER WITH (NOLOCK)
--			         JOIN ExpenseReportStatus ERS WITH (NOLOCK) ON ERS.OriginalId = ER.ReportStatusId AND ERS.InActiveDateTime IS NULL AND ERS.AsAtInactiveDateTime IS NULL
--		       WHERE ERS.CompanyId = @CompanyId
--					 AND (@IsArchived IS NULL 
--					      OR (@IsArchived = 1 AND ER.InActiveDateTime IS NOT NULL)
--						  OR (@IsArchived = 0 AND ER.InActiveDateTime IS NULL))
--					 AND (ER.AsAtInactiveDateTime IS NULL) 
--				     AND (@ExpenseReportId IS NULL OR ER.OriginalId = @ExpenseReportId) 
--					 AND (@DurationFrom IS NULL OR ER.DurationFrom = CAST(@DurationFrom AS DATE))
--					 AND (@DurationTo IS NULL OR ER.DurationTo = CAST(@DurationTo AS DATE))
--					 AND (@ReportStatusId IS NULL OR ER.ReportStatusId = @ReportStatusId) 
--		             AND (@IsReimbursed IS NULL OR ER.IsReimbursed = @IsReimbursed)
--		             AND (@IsApproved IS NULL OR ER.IsApproved = @IsApproved)
--		             AND (@SearchText IS NULL 
--					      OR (ER.ReportTitle LIKE @SearchText)
--		  	  		      OR (ER.BusinessPurpose LIKE @SearchText))
--		      ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
--		  	  			CASE WHEN @SortBy = 'ReportTitle' THEN ER.ReportTitle
--		  	  			     WHEN @SortBy = 'ReportStatusId' THEN ER.ReportStatusId
--		  	  			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,ER.CreatedDateTime,121) AS sql_variant)
--							 WHEN @SortBy = 'DurationFrom' THEN CAST(CONVERT(DATETIME,ER.DurationFrom,121) AS sql_variant)
--							 WHEN @SortBy = 'DurationTo' THEN CAST(CONVERT(DATETIME,ER.DurationTo,121) AS sql_variant)
--							 WHEN @SortBy = 'DurationTo' THEN CAST(CONVERT(DATETIME,ER.DurationTo,121) AS sql_variant)
--							 WHEN @SortBy = 'AmountToBeReimbursed' THEN CAST(AmountToBeReimbursed AS sql_variant)
--		  	  			END
--		  	  	  END ASC,
--		  	  	  CASE WHEN @SortDirection = 'DESC' THEN
--		  	  			CASE WHEN @SortBy = 'ReportTitle' THEN ER.ReportTitle
--		  	  			     WHEN @SortBy = 'ReportStatusId' THEN ER.ReportStatusId
--		  	  			     WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,ER.CreatedDateTime,121) AS sql_variant)
--							 WHEN @SortBy = 'DurationFrom' THEN CAST(CONVERT(DATETIME,ER.DurationFrom,121) AS sql_variant)
--							 WHEN @SortBy = 'DurationTo' THEN CAST(CONVERT(DATETIME,ER.DurationTo,121) AS sql_variant)
--							 WHEN @SortBy = 'AmountToBeReimbursed' THEN CAST(AmountToBeReimbursed AS sql_variant)
--		  	  			END
--		  	  	  END DESC
--		     OFFSET ((@PageNumber - 1) * @PageSize) ROWS
--		     FETCH NEXT @PageSize Rows ONLY 	

--	 END TRY  
--	 BEGIN CATCH 
		
--		  EXEC [dbo].[USP_GetErrorInformation]

--	END CATCH

--END
--GO