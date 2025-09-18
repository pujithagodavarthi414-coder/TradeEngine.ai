-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-14 00:00:00.000'
-- Purpose      To Get the ProjectTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetProjectTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProjectTypes]
(
  @ProjectTypeId UNIQUEIDENTIFIER = NULL,
  @ProjectTypeName NVARCHAR(150) = NULL,
  @IsArchived BIT = 0,
  @OperationsPerformedBy UNIQUEIDENTIFIER
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
				
				IF(@ProjectTypeId = '00000000-0000-0000-0000-000000000000') SET  @ProjectTypeId = NULL
				
				IF(@ProjectTypeName = '') SET  @ProjectTypeName = NULL

				SELECT PT.Id AS ProjectTypeId,
				       PT.ProjectTypeName,
					   (SELECT COUNT(1) 
					   FROM Project P 
					   WHERE P.ProjectTypeId = PT.Id 
					         AND P.InActiveDateTime IS NULL
					   GROUP BY P.ProjectTypeId) AS ProjectsCount,
					   IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
					   PT.ArchivedDateTime,
				       PT.CompanyId,
				       PT.CreatedByUserId,
					   PT.CreatedDateTime,
					   PT.UpdatedByUserId,
					   PT.UpdatedDateTime,
					   PT.[TimeStamp],
					   CASE WHEN PT.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
				       TotalCount = COUNT(1) OVER()
				FROM  [dbo].[ProjectType] PT WITH (NOLOCK)
				WHERE PT.CompanyId = @CompanyId 
				      AND (@ProjectTypeId IS NULL OR PT.Id = @ProjectTypeId)
				      AND (@ProjectTypeName IS NULL OR PT.ProjectTypeName = @ProjectTypeName)
				      AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL)
						  OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
				ORDER BY ProjectTypeName ASC 	 
    
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