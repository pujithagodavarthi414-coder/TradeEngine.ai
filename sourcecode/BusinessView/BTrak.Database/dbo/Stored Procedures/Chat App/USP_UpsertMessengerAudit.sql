--EXEC [dbo].[USP_UpsertMessengerAudit] @OperationsPerformedBy = 'D6F686AC-91D2-456A-B3F5-5D9CA54A23F2',@UserId = 'D6F686AC-91D2-456A-B3F5-5D9CA54A23F2'
--,@PlatformId = 'C164DCA6-EEA1-48BF-A6A2-3781E5CD7F82',@StatusId = '39C16949-1B0F-40E3-8C4A-4733A0653E4A',@IpAddress = '106.76.209.229'

CREATE PROCEDURE [dbo].[USP_UpsertMessengerAudit]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @PlatformId UNIQUEIDENTIFIER = NULL,
 @StatusId UNIQUEIDENTIFIER = NULL,
 @IpAddress NVARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF (@HavePermission = '1')
		BEGIN			
			IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF (@UserId IS NULL AND @UserId IS NULL)
			BEGIN

					RAISERROR('UserIdShouldNotBeNull',11,1)

			END
	        ELSE
				
				DECLARE @CurrentDate DATETIME = GETDATE()

				DECLARE @LatestStatusDate DATETIME = NULL,@LatestStatusId UNIQUEIDENTIFIER = NULL

				SELECT @LatestStatusDate = [CreatedDateTime],@LatestStatusId = StatusId  
				FROM [UserActiveStatus] WHERE UserId = @UserId AND CompanyId = @CompanyId

			   INSERT INTO MessengerAudit
			   (Id,UserId,StatusId,PlatformId,CreatedByUserId,CreatedDateTime,CompanyId,IpAddress)
			   VALUES
			   (NEWID(),@UserId,@StatusId,@PlatformId,@OperationsPerformedBy,@CurrentDate,@CompanyId,@IpAddress)

			   IF(@LatestStatusDate IS NULL)
			   BEGIN
				
					INSERT INTO [UserActiveStatus] (Id,UserId,StatusId,PlatformId,CreatedByUserId,CreatedDateTime,CompanyId,IpAddress)
			        VALUES (NEWID(),@UserId,@StatusId,@PlatformId,@OperationsPerformedBy,@CurrentDate,@CompanyId,@IpAddress)

			   END
			   ELSE IF(@LatestStatusId <> @StatusId)
			   BEGIN

					IF(@StatusId IN ('AD591598-9D5D-4F13-BCB7-EBB66D52A9CE','D5A18E5B-FA73-47CB-95BD-73D7581A8FF9')) --Offline,Inactive
					BEGIN
						
						IF(DATEDIFF(MINUTE,@LatestStatusDate,@CurrentDate) > 3)
					    BEGIN
					    	
					    	UPDATE [UserActiveStatus] 
					    	       SET StatusId = @StatusId
					    		       ,PlatformId = @PlatformId
					    			   ,CreatedByUserId = @OperationsPerformedBy
					    			   ,CreatedDateTime = @CurrentDate
					    			   ,IpAddress = @IpAddress
					    	      WHERE CompanyId = @CompanyId AND UserId = @UserId

					    END

					END
					ELSE
					BEGIN
						
						UPDATE [UserActiveStatus] 
					    	       SET StatusId = @StatusId
					    		       ,PlatformId = @PlatformId
					    			   ,CreatedByUserId = @OperationsPerformedBy
					    			   ,CreatedDateTime = @CurrentDate
					    			   ,IpAddress = @IpAddress
					    	      WHERE CompanyId = @CompanyId AND UserId = @UserId

					END

					
			   END
		END
		ELSE
			RAISERROR(@HavePermission,11,1)
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
GO