---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get the Branches by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetBranches_New] @OperationsPerformedBy = 'FFB8384E-64E8-4C71-9DDE-307757651BF0'

CREATE PROCEDURE [dbo].[USP_GetBranches_New]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(250)  = NULL,
	--@RegionId UNIQUEIDENTIFIER = NULL,
	@BranchId UNIQUEIDENTIFIER = NULL,		
	@IsArchived BIT= NULL	
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
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
		   DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE InActiveDateTime IS NULL AND UserId = (@OperationsPerformedBy))
       	   
           SELECT B.Id AS BranchId,
		   	      B.CompanyId,
				  B.BranchName,
		   	      B.InActiveDateTime,
		   	      B.CreatedDateTime ,
		   	      B.CreatedByUserId,
		   	      B.[TimeStamp],
				  B.IsHeadOffice,
				  B.Address,
				  B.TimeZoneId,
				  TZ.TimeZoneName,
				  (CASE WHEN B.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM [dbo].[Branch] AS B	
				LEFT JOIN [TimeZone] TZ ON TZ.Id = B.TimeZoneId AND TZ.InactiveDateTime IS NULL
           WHERE B.CompanyId = @CompanyId
		        AND B.Id IN (SELECT BranchId FROM EmployeeEntityBranch WHERE InactiveDateTime IS NULL AND EmployeeId = @EmployeeId)
				AND (@BranchId IS NULL OR B.Id = @BranchId)
				AND (@SearchText IS NULL OR B.BranchName LIKE  '%'+ @SearchText +'%' OR [Address] LIKE  '%'+ @SearchText +'%'
				OR TZ.TimeZoneName LIKE '%'+ @SearchText +'%' 
				OR (JSON_VALUE(address,'$.Street') +',' +' ' 
				     + JSON_VALUE(address,'$.City') + ',' +' ' 
					 + JSON_VALUE(address,'$.PostalCode') + ',' +' '
					 + JSON_VALUE(address,'$.State'))  like '%' + @SearchText + '%'  )
				AND (@IsArchived IS NULL 
				    OR (@IsArchived = 1 AND B.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND B.InActiveDateTime IS NULL))
           ORDER BY B.BranchName ASC

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