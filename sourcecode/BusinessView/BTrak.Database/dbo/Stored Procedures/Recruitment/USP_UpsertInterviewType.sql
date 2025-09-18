--EXEC [dbo].[USP_UpsertInterviewType] @InterviewTypeId='8BF68FBE-E784-419A-9156-CE8B72BE2515',@InterviewTypeName='ze1',@OperationsPerformedBy='078A5803-6C65-46CD-A0AF-516FE07958C0',@Color='red',@TimeStamp=0x0000000000039223

CREATE PROCEDURE [dbo].[USP_UpsertInterviewType]
(
   @InterviewTypeId UNIQUEIDENTIFIER = NULL,
   @InterviewTypeName NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @Color NVARCHAR(50),
   @IsVideo BIT = NULL,
   @IsPhone BIT = NULL,
   @InterviewTypeRoleCofigurationId UNIQUEIDENTIFIER = NULL,
   @RoleIds XML = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@InterviewTypeName IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'InterviewType')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @InterviewTypeIdCount INT = (SELECT COUNT(1) FROM InterviewType  WHERE Id = @InterviewTypeId)

			DECLARE @InterviewTypeCount INT = (SELECT COUNT(1) FROM InterviewType WHERE InterviewTypeName = @InterviewTypeName AND CompanyId = @CompanyId AND (@InterviewTypeId IS NULL OR @InterviewTypeId <> Id))
       
			DECLARE @IsInUse INT = (select COUNT(1) from InterviewProcessTypeConfiguration IPC
									INNER JOIN InterviewType IT ON IT.Id = IPC.InterviewTypeId
											WHERE IT.CompanyId=@CompanyId AND IPC.InterviewTypeId = @InterviewTypeId
											)
       
			IF(@IsInUse > 0 AND @IsArchived IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'InterviewTypeUse')

			END
			IF(@InterviewTypeIdCount = 0 AND @InterviewTypeId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'InterviewType')

			END
			IF (@InterviewTypeCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'InterviewType')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @InterviewTypeId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [InterviewType] WHERE Id = @InterviewTypeId  AND CompanyId = @CompanyId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@InterviewTypeId IS NULL)
					  BEGIN

						 SET @InterviewTypeId = NEWID()

						 INSERT INTO [dbo].[InterviewType]([Id],
														  [CompanyId],
								                          InterviewTypeName,
								                          Color,
														  IsVideoCalling,
														  IsPhoneCalling,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @InterviewTypeId,
								                          @CompanyId,
								                          @InterviewTypeName,
														  @Color,
														  @IsVideo,
														  @IsPhone,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		

						EXEC [dbo].[USP_UpsertInterviewTypeRoleCofiguration]
						@RoleId  = @RoleIds,
						@InterviewTypeId  = @InterviewTypeId,
						@OperationsPerformedBy =@OperationsPerformedBy

							         
					END
					ELSE
					BEGIN

						UPDATE [InterviewType] SET CompanyId = @CompanyId,
								                  InterviewTypeName = @InterviewTypeName,
									              IsVideoCalling = @IsVideo,
												  IsPhoneCalling = @IsPhone,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @InterviewTypeId

						--DECLARE @TimeStampInner TIMESTAMP = (SELECT [TimeStamp] FROM [InterviewTypeRoleCofiguration] WHERE Id = @InterviewTypeRoleCofigurationId)
				    IF(@IsArchived IS NULL)
					BEGIN
						EXEC [dbo].[USP_UpsertInterviewTypeRoleCofiguration]
						@InterviewTypeRoleCofigurationId = @InterviewTypeRoleCofigurationId,
						@RoleId = @RoleIds,
						@InterviewTypeId = @InterviewTypeId,
						@OperationsPerformedBy =@OperationsPerformedBy
						--,@TimeStamp=@TimeStampInner
						END
					END
				            
				    SELECT Id FROM [dbo].[InterviewType] WHERE Id = @InterviewTypeId
				                   
				  END
				  ELSE
				     
				      RAISERROR (50008,11, 1)
				     
				END
				ELSE
				BEGIN
				     
					RAISERROR (@HavePermission,11, 1)
				     		
			    END

			END
	END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO