---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06
-- Purpose      To get the departments by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetDepartments] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived=1

CREATE PROCEDURE [dbo].[USP_GetDepartments]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@DepartmentId UNIQUEIDENTIFIER = NULL,	
	@SearchText  NVARCHAR(250) = NULL,
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
		   IF(@SearchText = '') SET @SearchText = NULL

		   SET @SearchText = '%'+ @SearchText +'%'
		   
		   IF(@DepartmentId = '00000000-0000-0000-0000-000000000000') SET @DepartmentId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT D.Id AS DepartmentId,
		   	      D.CompanyId,
		   	      D.DepartmentName,
		   	      D.InActiveDateTime,
		   	      D.CreatedDateTime ,
		   	      D.CreatedByUserId,
		   	      D.[TimeStamp],
				  (CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(*) OVER()
           FROM Department AS D		        
           WHERE D.CompanyId = @CompanyId
		        AND (@SearchText IS NULL OR (D.DepartmentName LIKE  '%'+ @SearchText +'%'))
		   	    AND (@DepartmentId IS NULL OR D.Id = @DepartmentId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND D.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND D.InActiveDateTime IS NULL))
		   	    
           ORDER BY D.DepartmentName ASC

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