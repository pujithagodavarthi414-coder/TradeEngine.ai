CREATE PROCEDURE [dbo].[USP_UpsertModuleLayout]
	@ModuleLayoutId UNIQUEIDENTIFIER = NULL,
	@ModulePageId UNIQUEIDENTIFIER = NULL,
	@LayoutName NVARCHAR(250) = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@IsNameEdit BIT = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,@ProcName))
			IF(@HavePermission = '1')
            BEGIN
			 DECLARE @IsLatest BIT = (CASE WHEN @ModuleLayoutId IS NULL
                                                   THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [ModuleLayout]
                                                                         WHERE Id = @ModuleLayoutId) = @TimeStamp
                                                                          THEN 1 ELSE 0 END END)
            
			DECLARE @UniqueNumber INT

                        SELECT @UniqueNumber
                            = MAX(CAST(SUBSTRING(
                                                    LayoutName,
                                                    CHARINDEX('-', LayoutName) + 1,
                                                    LEN(LayoutName)
                                                ) AS INT)
                                 )
                        FROM ModuleLayout ML
						    INNER JOIN ModulePage MP ON MP.Id = ML.ModulePageId
                            INNER JOIN CompanyModule CM
                                ON CM.Id = MP.CompanyModuleId 
						  INNER JOIN Module M ON M.Id = CM.ModuleId
                        WHERE MP.Id = @ModulePageId AND CM.CompanyId = @CompanyId
						AND (ML.IsNameEdit = 0 OR ML.IsNameEdit IS NULL)

			  IF(@LayoutName IS NULL) SET  @LayoutName  = ('Layout-' + CAST(ISNULL(@UniqueNumber, 0) + 1 AS NVARCHAR(250)))

			  DECLARE @CurrentDate DATETIME = GETDATE()
			  DECLARE @ModuleNameCount INT = (SELECT COUNT(1) FROM ModuleLayout
                                               WHERE LayoutName = @LayoutName AND ModulePageId = @ModulePageId AND (@ModuleLayoutId IS NULL OR Id <> @ModuleLayoutId)
                                            )
                 IF(@ModuleNameCount > 0)
                 BEGIN
                     RAISERROR(50001,16,1,'ModuleLayout')
                 END
				 IF(@IsLatest = 1)
			     BEGIN
				         IF(@ModuleLayoutId IS NULL)
						 BEGIN
						        SET @ModuleLayoutId = NEWID()
								INSERT INTO [dbo].[ModuleLayout](
								                     [Id],
													 [ModulePageId],
													 [LayoutName],
													 [CreatedDateTime],
													 [CreatedByUserId]
								                   )
										SELECT @ModuleLayoutId,
										       @ModulePageId,
											   @LayoutName,
											   @CurrentDate,
											   @OperationsPerformedBy
						 END
						 ELSE
						 BEGIN
						            UPDATE [dbo].[ModuleLayout]
									SET [ModulePageId]  = @ModulePageId,
									    [LayoutName]  = @LayoutName,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[UpdatedDateTime] = @CurrentDate,
										[IsNameEdit] = @IsNameEdit
								   WHERE Id= @ModuleLayoutId
						 END
						SELECT @ModuleLayoutId
			     END
				 ELSE
			     BEGIN
			         RAISERROR (50015,11, 1)
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

