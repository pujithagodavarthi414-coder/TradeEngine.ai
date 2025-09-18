-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get PayGrades
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetPayGrades] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayGrades]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@PayGradeId UNIQUEIDENTIFIER = NULL,	
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

		   IF(@PayGradeId = '00000000-0000-0000-0000-000000000000') SET @PayGradeId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT P.Id AS PayGradeId,
		   	      P.CompanyId,
		   	      P.PayGradeName,
		   	      P.InActiveDateTime,
		   	      P.CreatedDateTime,
		   	      P.CreatedByUserId,
		   	      P.[TimeStamp],
				  CASE WHEN P.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM PayGrade AS P		        
           WHERE P.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (P.PayGradeName LIKE @SearchText))
		   	   AND (@PayGradeId IS NULL OR P.Id = @PayGradeId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND P.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND P.InActiveDateTime IS NULL))
           ORDER BY P.PayGradeName ASC

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