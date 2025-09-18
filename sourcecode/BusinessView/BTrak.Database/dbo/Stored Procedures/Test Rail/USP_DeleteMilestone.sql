-------------------------------------------------------------------------------
-- Author      Mahesh Musuku
-- Created      '2019-06-10 00:00:00.000'
-- Purpose      To Delete the Milestone
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_DeleteMilestone] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@MilestoneId ='987FB2BC-D536-4126-A65F-3AC82BBF3C86',@TimeStamp=0x0000000000001DDC

CREATE PROCEDURE [dbo].[USP_DeleteMilestone]
(
    @MilestoneId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
			DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM Milestone WHERE Id = @MilestoneId)
			
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
        
            IF (@HavePermission = '1')
            BEGIN
               DECLARE @IsLatest BIT = (CASE WHEN @MilestoneId IS NULL 
                                                   THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                             FROM [Milestone] WHERE Id = @MilestoneId AND InActiveDateTime IS NULL ) = @TimeStamp
                                                                     THEN 1 ELSE 0 END END)
                  
            IF(@IsLatest = 1)
            BEGIN      
			
					     DECLARE @Currentdate DATETIME = GETDATE()
					     
						UPDATE Milestone SET InActiveDateTime = @Currentdate,
						                     UpdatedDateTime = @Currentdate,
											 UpdatedByUserId = @OperationsPerformedBy
											 WHERE Id = @MilestoneId
					     
					            SELECT Id FROM [dbo].[Milestone] where Id = @MilestoneId
		       END
               ELSE
             
                RAISERROR (50008,11, 1)
             
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