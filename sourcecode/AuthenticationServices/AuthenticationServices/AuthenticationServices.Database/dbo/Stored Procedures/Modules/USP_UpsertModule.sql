CREATE PROCEDURE [dbo].[USP_UpsertModule]
	@ModuleId UNIQUEIDENTIFIER = NULL,
	@ModuleDescription NVARCHAR(250) = NULL,
	@ModuleLogo NVARCHAR(250) = NULL,
	@ModuleName NVARCHAR(250) = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL,
	@Tags NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	     DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,@ProcName))
		 IF(@HavePermission = '1')
         BEGIN
		    DECLARE @IsLatest BIT = (CASE WHEN @ModuleId IS NULL
                                                   THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [Module]
                                                                         WHERE Id = @ModuleId) = @TimeStamp
                                                                          THEN 1 ELSE 0 END END)
			
			DECLARE @CurrentDate DATETIME = GETDATE()
			
			DECLARE @ModuleIdCount INT = (SELECT COUNT(1) FROM Module WHERE Id = @ModuleId)
              DECLARE @ModuleNameCount INT = (SELECT COUNT(1) FROM Module
                                               WHERE ModuleName = @ModuleName AND (@ModuleId IS NULL OR Id <> @ModuleId)
                                            )
                 IF(@ModuleNameCount > 0)
                 BEGIN
                     RAISERROR(50001,16,1,'Module')
                 END
		     IF(@IsLatest = 1)
			BEGIN
			     IF(@ModuleId IS NULL)
				 BEGIN
				      SET @ModuleId = NEWID()
                      INSERT INTO [dbo].[Module](
					                      [Id],
										  [ModuleName],
										  [ModuleDescription],
										  [ModuleLogo],
										  [CreatedDateTime],
										  [CreatedByUserId],
										  [Tags]
					  )
					  SELECT @ModuleId,
					         @ModuleName,
							 @ModuleDescription,
							 @ModuleLogo,
							 @CurrentDate,
							 @OperationsPerformedBy,
							 @Tags

					 DECLARE @CompanyModuleId UNIQUEIDENTIFIER = NEWID()
					 INSERT INTO [dbo].[CompanyModule](
					                             [Id],
												 [CompanyId],
												 [ModuleId],
												 [IsActive],
												 [IsEnabled],
												 [CreatedDateTime],
												 [CreatedByUserId]
					                         )
										SELECT @CompanyModuleId,
										       @CompanyId,
											   @ModuleId,
											   1,
											   1,
											   @CurrentDate,
											   @OperationsPerformedBy

						 INSERT INTO [dbo].[ModulePage](
					                        [Id],
											[CompanyModuleId],
											[PageName],
											[CreatedDateTime],
											[CreatedByUserId]
					            )
							SELECT NEWID(),
							       @CompanyModuleId,
								   'Default page',
								   @CurrentDate,
								   @OperationsPerformedBy
				 END
				 ELSE
				 BEGIN
				       UPDATE [dbo].[Module]
					   SET [ModuleName] = @ModuleName,
					       [ModuleDescription] = @ModuleDescription,
						   [ModuleLogo]  = @ModuleLogo,
						   [UpdatedByUserId] = @OperationsPerformedBy,
						   [UpdatedDateTime] = @CurrentDate,
						   [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
						   [Tags]            = @Tags
					   WHERE Id = @ModuleId
				 END
				    SELECT @ModuleId
			END
			ELSE
			BEGIN
			   RAISERROR (50015,11, 1)
			END
		 END
	 
	 END TRY
    BEGIN CATCH
       THROW
    END CATCH
END
