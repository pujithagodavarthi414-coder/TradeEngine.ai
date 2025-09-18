-------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Save or Update the LeaveSession
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertLeaveSession] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@LeaveSessionName='Test'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertLeaveSession]
(
@LeaveSessionId UNIQUEIDENTIFIER = NULL,
@LeaveSessionName NVARCHAR(800) = NULL,
@IsArchived BIT = NULL,
@TimeStamp TIMESTAMP = NULL,
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
			
		  IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		  IF (@LeaveSessionName = '') SET @LeaveSessionName = NULL

		  DECLARE @Currentdate DATETIME = GETDATE()

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		  
		  DECLARE @LeaveSessionIdCount INT = (SELECT COUNT(1) FROM LeaveSession WHERE Id = @LeaveSessionId AND CompanyId = @CompanyId)
		  
		  DECLARE @LeaveSessionNameCount INT = (SELECT COUNT(1) FROM LeaveSession WHERE LeaveSessionName = @LeaveSessionName AND CompanyId = @CompanyId AND (@LeaveSessionId IS NULL OR Id <> @LeaveSessionId))

		  IF(@LeaveSessionName IS NULL)
		  BEGIN
			   
			   RAISERROR(50011,16, 2, 'LeaveSessionName')

		  END

		  ELSE IF(@LeaveSessionIdCount = 0 AND @LeaveSessionId IS NOT NULL)
		  BEGIN
		  
		  		RAISERROR(50002,16, 1,'LeaveSession')
		  
		  END
		  
		  ELSE IF(@LeaveSessionNameCount > 0)
		  BEGIN
		  
		  		RAISERROR(50001,16,1,'LeaveSession')
		  
		  END

		  ELSE 
		  BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @LeaveSessionId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM LeaveSession WHERE Id = @LeaveSessionId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

			IF(@LeaveSessionId IS NULL)
			BEGIN
		
				SET @LeaveSessionId = NEWID()
					INSERT INTO [dbo].[LeaveSession](
				                 [Id],
								 [CompanyId],
								 [LeaveSessionName],
								 [InActiveDateTime],
								 [CreatedDateTime],
								 [CreatedByUserId]
								 )
				          SELECT @LeaveSessionId,
								 @CompanyId,
								 @LeaveSessionName,
								 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								 @Currentdate,
								 @OperationsPerformedBy
		
			END
			ELSE
			BEGIN
			
			UPDATE [dbo].[LeaveSession]
							 SET [CompanyId]					=		   @CompanyId,
								 [LeaveSessionName]				=		   @LeaveSessionName,
								 [InActiveDateTime]				=		   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								 [UpdatedDateTime]				=		   @Currentdate,
								 [UpdatedByUserId]				=		   @OperationsPerformedBy
							WHERE Id = @LeaveSessionId
			
			END

					SELECT Id FROM [dbo].[LeaveSession] where Id = @LeaveSessionId

				END	

				ELSE

			  		RAISERROR (50008,11, 1)
		    
			END
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