CREATE PROCEDURE [dbo].[USP_UpsertModulePages]
	@ModulePageId UNIQUEIDENTIFIER = NULL,
	@ModuleId UNIQUEIDENTIFIER = NULL,
	@PageName NVARCHAR(250) = NULL,
	@IsDefault BIT = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL,
	@IsNameEdit BIT = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,@ProcName))
			IF(@HavePermission = '1')
            BEGIN
			 DECLARE @IsLatest BIT = (CASE WHEN @ModulePageId IS NULL
                                                   THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [ModulePage]
                                                                         WHERE Id = @ModulePageId) = @TimeStamp
                                                                          THEN 1 ELSE 0 END END)
            
			DECLARE @UniqueNumber INT

                        SELECT @UniqueNumber
                            = MAX(CAST(SUBSTRING(
                                                    PageName,
                                                    CHARINDEX('-', PageName) + 1,
                                                    LEN(PageName)
                                                ) AS INT)
                                 )
                        FROM ModulePage MP
                            INNER JOIN CompanyModule CM
                                ON CM.Id = MP.CompanyModuleId 
						  INNER JOIN Module M ON M.Id = CM.ModuleId
                        WHERE CM.Id = @ModuleId AND CM.CompanyId = @CompanyId
						AND MP.InActiveDateTime IS NULL AND (MP.IsNameEdit = 0 OR MP.IsNameEdit IS NULL)
						AND MP.PageName <> 'Default page'

			  IF(@PageName IS NULL) SET  @PageName  = ('Page-' + CAST(ISNULL(@UniqueNumber, 0) + 1 AS NVARCHAR(250)))

			  DECLARE @CurrentDate DATETIME = GETDATE()
			  DECLARE @ModuleNameCount INT = (SELECT COUNT(1) FROM ModulePage
                                               WHERE PageName = @PageName AND CompanyModuleId = @ModuleId AND InActiveDateTime IS NULL AND (@ModulePageId IS NULL OR Id <> @ModulePageId)
                                            )
                 IF(@ModuleNameCount > 0)
                 BEGIN
                     RAISERROR(50001,16,1,'ModulePage')
                 END
				 ELSE
				 BEGIN
				    IF(@IsLatest = 1)
			     BEGIN
				         IF(@ModulePageId IS NULL)
						 BEGIN
						        SET @ModulePageId = NEWID()
								INSERT INTO [dbo].[ModulePage](
								                     [Id],
													 [CompanyModuleId],
													 [PageName],
													 [IsDefault],
													 [CreatedDateTime],
													 [CreatedByUserId]
								                   )
										SELECT @ModulePageId,
										       @ModuleId,
											   @PageName,
											   @IsDefault,
											   @CurrentDate,
											   @OperationsPerformedBy
						 END
						 ELSE
						 BEGIN
						            UPDATE [dbo].[ModulePage]
									SET [CompanyModuleId]  = @ModuleId,
									    [PageName]  = @PageName,
										[IsDefault] = @IsDefault,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[UpdatedDateTime] = @CurrentDate,
										[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
										[IsNameEdit] = @IsNameEdit
								   WHERE Id= @ModulePageId
						 END
						SELECT @ModulePageId
			     END
				 ELSE
			     BEGIN
			         RAISERROR (50015,11, 1)
			END
				 END

				 
			END
			 ELSE
	   BEGIN
	     RAISERROR(@HavePermission,11,1)
	   END
	 END TRY
    BEGIN CATCH
       THROW
    END CATCH
END

