-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-11 00:00:00.000'
-- Purpose      To Get the GoalReplanTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetGoalReplanTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetGoalReplanTypes]
(
  @GoalReplanTypeId UNIQUEIDENTIFIER = NULL,
  @GoalReplanTypeName NVARCHAR(150) = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	      
		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

           IF(@HavePermission = '1')
           BEGIN

			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			   
			   IF(@GoalReplanTypeName = '') SET  @GoalReplanTypeName = NULL

			   SELECT GR.Id AS GoalReplanTypeId,
			          GR.GoalReplanTypeName,
			          GR.CompanyId,
			  	      GR.CreatedByUserId,
			  	      GR.CreatedDateTime,
			  	      GR.UpdatedByUserId,
			  	      GR.UpdatedDateTime,
					  IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
					  GR.[TimeStamp],
			          TotalCount = COUNT(1) OVER()

			   FROM [dbo].[GoalReplanType] GR WITH (NOLOCK)
			   WHERE (GR.CompanyId = @CompanyId)
			         AND (@GoalReplanTypeId IS NULL OR GR.Id = @GoalReplanTypeId)
			         AND (@GoalReplanTypeName IS NULL OR (GR.GoalReplanTypeName LIKE '%'+ @GoalReplanTypeName+'%'))
					 AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL)
					 OR  (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
			   ORDER BY GoalReplanTypeName ASC 	  

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