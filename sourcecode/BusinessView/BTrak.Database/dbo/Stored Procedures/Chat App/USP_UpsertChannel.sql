-------------------------------------------------------------------------------
-- EXEC USP_UpsertChannel @ChannelName = 'Test',@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertChannel]
(
    @ChannelId UNIQUEIDENTIFIER = NULL,
    @ChannelName NVARCHAR(100) = NULL,
    @IsDeleted BIT = NULL,
    @ChannelImage NVARCHAR(800) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@CurrentOwnerShipId UNIQUEIDENTIFIER = NULL
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
		      --DECLARE @IsLatest BIT = (CASE WHEN @ChannelId IS NULL THEN 1 ELSE
			     --                      CASE WHEN (SELECT [TimeStamp] FROM [Channel]
								--	              WHERE Id =  @ChannelId) = @TimeStamp
        --                                          THEN 1 ELSE 0 END END)
		DECLARE @IsLatest BIT = 1
      IF(@IsLatest = 1)
		BEGIN
			IF(@ChannelName IS NULL)
			BEGIN
				RAISERROR(50011,16, 2, 'ChannelName')
			END
			ELSE
			BEGIN
				DECLARE @ChannelIdCount INT = (SELECT COUNT(1) FROM Channel WHERE Id = @ChannelId)
				DECLARE @ChannelNameCount INT
				SET @ChannelNameCount=(SELECT COUNT(1) FROM Channel WHERE ChannelName = @ChannelName AND CompanyId = @CompanyId AND(@ChannelId IS NULL OR Id <> @ChannelId))
				IF(@ChannelIdCount = 0 AND @ChannelId IS NOT NULL)
				BEGIN
					RAISERROR(50002,16, 1,'Channel')
				END
				ELSE IF(@ChannelNameCount > 0)
				BEGIN
					RAISERROR(50001,16,1,'Channel')
				END
				ELSE
			    BEGIN
					IF (@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL
					DECLARE @Currentdate DATETIME = GETDATE()
					IF(@ChannelId IS NULL)
					BEGIN
						SET @ChannelId = NEWID()
						INSERT INTO [Channel](
									[Id],
									[CompanyId],
									[ChannelName],
									[InActiveDateTime],
									[ChannelImage],
									[CreatedDateTime],
									[CreatedByUserId],
									[ProjectId])
								VALUES (@ChannelId,
										@CompanyId,
										@ChannelName,
										(CASE WHEN @IsDeleted = 1 THEN @Currentdate ELSE NULL END),
										@ChannelImage,
										@Currentdate,
										@OperationsPerformedBy,
										@ProjectId)

					END
					ELSE
					BEGIN
						UPDATE [Channel]
							SET [CompanyId]			=    @CompanyId,
                               [ChannelName]		=    @ChannelName,
                               [InActiveDateTime]	=    (CASE WHEN @IsDeleted = 1 THEN @Currentdate ELSE NULL END),
                               [ChannelImage]		=    @ChannelImage,
                               [UpdatedDateTime]	=    @Currentdate,
                               [UpdatedByUserId]	=    @OperationsPerformedBy,
							   [ProjectId]			=	 @ProjectId,
							   [CurrentOwnerShipId] =    @CurrentOwnerShipId
						WHERE Id = @ChannelId
					END
                    SELECT Id FROM [dbo].[Channel] WHERE Id = @ChannelId
				END
			END
		END
	  ELSE
		BEGIN
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
