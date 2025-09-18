-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-23 00:00:00.000'
-- Purpose      To Get the Branches By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--   EXEC [dbo].[USP_GetBranches] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetBranches]
(
   @BranchId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @IsArchived BIT = NULL,
   @BranchName NVARCHAR(250) = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN


             IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL

             IF(@BranchName = '') SET @BranchName = NULL

             IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

             SELECT B.Id AS BranchId,
                    B.BranchName,
                    B.CompanyId,
                    B.CreatedByUserId,
                    B.CreatedDateTime,
				    (CASE WHEN B.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived,
                    TotalCount = Count(1) OVER()
              FROM  [dbo].[Branch]B WITH (NOLOCK)
              WHERE B.CompanyId = @CompanyId 
              AND (@BranchId IS NULL OR B.Id = @BranchId)
			  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND B.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND B.InActiveDateTime IS NULL)) 
              AND (@BranchName IS NULL OR B.BranchName LIKE '%'+ @BranchName +'%')
			  ORDER BY BranchName ASC
              

	    END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
     END TRY  
     BEGIN CATCH 
        
          EXEC USP_GetErrorInformation

    END CATCH
END