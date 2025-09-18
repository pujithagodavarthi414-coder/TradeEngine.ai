-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-31 00:00:00.000'
-- Purpose      To Get The TransitionDeadlines By Applying DifferenT Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTransitionDeadlines] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTransitionDeadlines]
(
	@TransitionDeadlineId  UNIQUEIDENTIFIER = NULL,
    @DeadLineName  NVARCHAR(800)=NULL,           
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
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

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF (@TransitionDeadlineId = '00000000-0000-0000-0000-000000000000') SET @TransitionDeadlineId = NULL

	      IF (@DeadLineName = '') SET @DeadLineName = NULL

          SELECT TD.Id AS TransitionDeadlineId,
				 TD.Deadline,
				 TD.CompanyId,
                 TD.CreatedDateTime,
                 TD.CreatedByUserId,
				 TD.UpdatedDateTime,
                 TD.UpdatedByUserId,
				 TD.[TimeStamp],
				 CASE WHEN TD.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS  IsArchived,
                 TotalCount = COUNT(1) OVER()
          FROM  [dbo].[TransitionDeadline] TD WITH (NOLOCK)
          WHERE TD.CompanyId = @CompanyId
				AND (@TransitionDeadlineId IS NULL OR TD.Id = @TransitionDeadlineId)	  
				AND (@DeadLineName IS NULL OR TD.Deadline = @DeadLineName)	  
				AND (@IsArchived IS NULL 
				    OR (TD.InActiveDateTime IS NULL AND @IsArchived = 0) 
				    OR (TD.InActiveDateTime IS NOT NULL AND @IsArchived = 1))
	    END
	    ELSE
	    
		RAISERROR(@HavePermission,11,1)

     END TRY
     BEGIN CATCH
        
        THROW

    END CATCH
END