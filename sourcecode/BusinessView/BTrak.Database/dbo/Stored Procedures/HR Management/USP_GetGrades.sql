-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-05-20 00:00:00.000'
-- Purpose      To Get Grades
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetGrades] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetGrades]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@GradeId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL	
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

		   IF(@GradeId = '00000000-0000-0000-0000-000000000000') SET @GradeId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT G.Id AS GradeId,
		   	      --G.CompanyId,
		   	      G.GradeName,
				  G.GradeOrder,
		   	      G.InActiveDateTime,
		   	      G.CreatedDateTime,
		   	      G.CreatedByUserId,
		   	      G.[TimeStamp],
				  CASE WHEN G.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM Grade AS G		        
           WHERE G.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (G.GradeName LIKE @SearchText))
		   	   AND (@GradeId IS NULL OR G.Id = @GradeId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND G.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND G.InActiveDateTime IS NULL))
           ORDER BY G.GradeOrder ASC

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