-------------------------------------------------------------------------------
-- Author       SUSHMITHA KANDAPU
-- Created      '2019-02-20 00:00:00.000'
-- Purpose      To Save or Update the UserStorySpentTime
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserStorySpentTime] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId='A69A1636-9EE6-4BC3-8F73-04CF0DC56C3D',@SpentTime='20',
--@Comment='TEST',@DateFrom='2019-03-12',@DateTo='2019-03-13',@RemainingEstimateTypeId='8008E5E4-9060-41AF-80EC-BCB5BAF7C22C'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserSpentTimeReason]
(
    @UserSpentTimeReasonId  UNIQUEIDENTIFIER = NULL,
    @Comment NVARCHAR(MAX) = NULL,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
         DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
		 IF(@HavePermission = '1')
         BEGIN
			 
				
					DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
          
					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          
					DECLARE @UserInputValue INT = 0
          
					DECLARE @SetToTypeId  UNIQUEIDENTIFIER = (SELECT Id FROM LogTimeOption WHERE IsSetTo = 1)
          
					DECLARE @UseExistingEstimateHoursTypeId  UNIQUEIDENTIFIER = (SELECT Id FROM LogTimeOption WHERE IsUseExistingEstimateHours = 1)
          
					DECLARE @AdjustAutomaticallyTypeId  UNIQUEIDENTIFIER = (SELECT Id FROM LogTimeOption WHERE IsAdjustAutomatically = 1 )
          
					DECLARE @ReduceByTypeId  UNIQUEIDENTIFIER = (SELECT Id FROM LogTimeOption WHERE IsReduceBy = 1)
          
					DECLARE @RemainingTimeInMin FLOAT = 0
           
				
          
					  DECLARE @IsLatest BIT = (CASE WHEN @UserSpentTimeReasonId IS NULL 
														  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																				   FROM UserSpentTimeReason WHERE Id = @UserSpentTimeReasonId) = @TimeStamp
																			THEN 1 ELSE 0 END END)
            
						IF(@IsLatest = 1)
						BEGIN
							IF(@UserSpentTimeReasonId IS NULL)
							BEGIN
								SET @UserSpentTimeReasonId = NEWID()
								INSERT INTO [dbo].[UserSpentTimeReason](
											   [Id],
											   [Comment],
											   [UserId],
											   [CreatedDateTime],
											   [CreatedByUserId],
											   [InActiveDateTime] 
											   )
										SELECT @UserSpentTimeReasonId,
											   @Comment,
											   @OperationsPerformedBy,
											   @Currentdate,
											   @OperationsPerformedBy,
											   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
											  
                            
							END
							ELSE IF (@UserSpentTimeReasonId IS NOT NULL)
							BEGIN

							UPDATE [dbo].[UserSpentTimeReason]
								SET 
									   [Comment]			   =  	    @Comment,
									   [UserId]				   =  	    @OperationsPerformedBy,
									   [InActiveDateTime]      =        CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									   [updatedByUserId]	   =  	    @OperationsPerformedBy
								WHERE Id = @UserSpentTimeReasonId

        END
        END
        ELSE
​
            RAISERROR(@HavePermission,11,1)
			END
END TRY
BEGIN CATCH
    
    THROW
​
END CATCH
END
GO