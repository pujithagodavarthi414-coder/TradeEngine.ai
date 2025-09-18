-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2020-07-30 00:00:00.000'
-- Purpose      To Get the expense stautses for the filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
---EXEC  [dbo].[USP_GetExpenseStatuses] @OperationsPerformedBy = '06E9783D-84FE-4CC3-8443-8BE22B994768'

CREATE PROCEDURE [dbo].[USP_GetExpenseStatuses]
(
	@ExpenseStatusId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
	@SearchText  NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
       SET NOCOUNT ON
       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                    
        IF (@HavePermission = '1')
        BEGIN
			  
			  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			  
			  IF(@IsArchived IS NULL) SET @IsArchived = 0
			  
			  IF (@ExpenseStatusId = '00000000-0000-0000-0000-000000000000') SET @ExpenseStatusId = NULL
			  
			  IF (@SearchText = '') SET @SearchText = NULL

			  SELECT ES.Id AS ExpenseStatusId,
					 ES.[Name] AS [ExpenseStatusName],
					 ES.CreatedDatetime,
					 ES.[Description],
					 ES.CreatedByUserId,
					 ES.[TimeStamp],
					 TotalCount = COUNT(1) OVER()
			  FROM  [dbo].[ExpenseStatus] ES WITH (NOLOCK)
			  WHERE   (@ExpenseStatusId IS NULL OR ES.Id = @ExpenseStatusId) 
					AND (@SearchText IS NULL OR [Name] LIKE '%' + @SearchText + '%')
			  ORDER BY [Name] 	


	    END
	    ELSE
	       RAISERROR(@HavePermission,11,1)
	    
	    END TRY  
	    BEGIN CATCH 
	    
	        THROW
	    
        END CATCH
END
GO