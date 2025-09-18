-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-08 00:00:00.000'
-- Purpose      To Get the Bug Priorities By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetBugPriorities]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBugPriorities]
(
    @BugPriorityId         UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@PriorityName          VARCHAR(100) =NULL,
	@Color                 VARCHAR(100)=NULL,
	@IsArchived            BIT = NULL
)
AS
BEGIN
  SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
          IF (@HavePermission = '1')
          BEGIN
	      DECLARE  @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          SELECT B.Id AS BugPriorityId,
                 B.PriorityName,
                 B.Color,
				 B.Icon,
				 B.[Order],
				 B.CompanyId,
                 B.CreatedDateTime,
                 B.CreatedByUserId,
                 B.UpdatedDateTime,                                                                   
				 B.UpdatedByUserId,
				 B.[Description],
				 B.[TimeStamp],
				 CASE WHEN B.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
				 TotalCount = COUNT(1) OVER()
          FROM  [dbo].[BugPriority] B WITH (NOLOCK) 
          WHERE (B.CompanyId = @CompanyId) 
				 AND (@BugPriorityId IS NULL OR B.Id = @BugPriorityId)
				 AND (@PriorityName IS NULL OR B.PriorityName = @PriorityName)
				 AND (@Color IS NULL OR B.Color = @Color)
				 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND InActiveDateTime IS NULL))
		 ORDER BY B.[Order]

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