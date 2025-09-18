---------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-11-12 00:00:00.000'
-- Purpose      To Upsert Files
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertFile]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@FolderName = 'test'   
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertFile]
(
   @FilesXML XML = NULL,
   @FolderId UNIQUEIDENTIFIER = NULL,
   @StoreId UNIQUEIDENTIFIER = NULL,
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsFromFeedback BIT = NULL,
   @Description NVARCHAR(800) = NULL,
   @IsTobeReviewed BIT = NULL,
   @IsDuplicatesAllowed BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			DECLARE @MaxSizeLimit BIGINT = (SELECT CAST([Value] AS BIGINT) FROM CompanySettings WHERE [Key] = 'DocumentsSizeLimit' AND CompanyId = @CompanyId AND InactiveDateTime IS NULL)
			DECLARE @CurrentSize BIGINT = (SELECT SUM(FileSize) FROM [UploadFile] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL GROUP BY CompanyId)

			IF(@CurrentSize >= (@MaxSizeLimit * 3))
			BEGIN
				RAISERROR ('MaxUploadedSizeLimitExceededForYourCompanyPleaseContactAdministrator',11, 1)
			END
			ELSE
			BEGIN
			CREATE TABLE #FileTable(
                        [FileId] UNIQUEIDENTIFIER,
                        [FileName] NVARCHAR(MAX),
                        [FileSize] BIGINT,
                        [FilePath] NVARCHAR(2000),
                        [FileExtension] NVARCHAR(50),
                        [IsArchived] BIT,
						[IsQuestionDocuments] BIT,
						[QuestionDocumentId] UNIQUEIDENTIFIER NULL
                       )
			INSERT INTO #FileTable(FileId,[FileName],FileSize,FilePath,FileExtension,IsArchived,IsQuestionDocuments,QuestionDocumentId)
			SELECT  NEWID(),
				   x.y.value('(FileName)[1]','NVARCHAR(800)'),
				   x.y.value('(FileSize)[1]','BIGINT'),
				   x.y.value('(FilePath)[1]','NVARCHAR(2000)'),
				   x.y.value('(FileExtension)[1]','NVARCHAR(50)'),
				   x.y.value('(IsArchived)[1]','BIT'),
				   x.y.value('(IsQuestionDocuments)[1]','BIT'),
				   TRY_CONVERT(UNIQUEIDENTIFIER,x.y.value('(QuestionDocumentId)[1]', 'NVARCHAR(MAX)'))
				   FROM @FilesXML.nodes('GenericListOfFileModel/ListItems/FileModel') AS x(y)

			IF(@IsDuplicatesAllowed IS NULL)
				BEGIN
					SET @IsDuplicatesAllowed = 0
				END

			IF (@IsFromFeedback = 1)
			BEGIN
				SET @CompanyId = (SELECT Id FROM [dbo].[Company] WHERE CompanyName = 'nxusworld')
		    END
			ELSE
			BEGIN
				SET @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		    END

			DECLARE @Currentdate DATETIME = GETDATE()

			IF(@IsDuplicatesAllowed = 0 AND EXISTS(SELECT [FileName] from UploadFile where FileName COLLATE SQL_Latin1_General_CP1_CI_AS IN  (SELECT FileName FROM #FileTable) AND CompanyId = @CompanyId AND FolderId = @FolderId AND InActiveDateTime IS NULL))
				BEGIN
				
				 RAISERROR(50001,16, 2, 'File')

				END
			ELSE
				BEGIN
					UPDATE [dbo].[UploadFile]
							SET [InActiveDateTime] = @Currentdate,
								[UpdatedDateTime] = @Currentdate,
								[UpdatedByUserId] = @OperationsPerformedBy 
								FROM [dbo].[UploadFile] U JOIN #FileTable F ON F.QuestionDocumentId = U.QuestionDocumentId WHERE F.QuestionDocumentId IS NOT NULL

					INSERT INTO [dbo].[UploadFile]	(
											[Id],
											[FileName],
											[FilePath],
											[FileSize],
											[FileExtension],
											[ReferenceId],
											[ReferenceTypeId],
											[FolderId],
											[StoreId],
											[IstoBeReviewed],
											[InActiveDateTime],
											[CreatedDateTime],
											[CreatedByUserId],
											[CompanyId],
											[IsQuestionDocuments],
											[QuestionDocumentId],
											[Description]
											)
								  SELECT FT.FileId,
										 FT.[FileName],
										 FT.FilePath,  
										 FT.FileSize,
										 FT.FileExtension,
										 @ReferenceId,
										 @ReferenceTypeId,
										 @FolderId,
										 @StoreId,
										 @IsTobeReviewed,
										 CASE WHEN FT.IsArchived =1 THEN @Currentdate ELSE NULL END,
										 @Currentdate,
										 @OperationsPerformedBy,
										 @CompanyId,
										 FT.IsQuestionDocuments,
										 FT.QuestionDocumentId,
										 @Description
								  FROM #FileTable AS FT

								SELECT FileId,@FolderId AS FolderId,FT.FileSize,@StoreId AS StoreId,UF.[TimeStamp]
								,FT.FilePath,FT.FileName,FT.FileSize,FT.FileExtension,FT.IsQuestionDocuments,FT.QuestionDocumentId,@ReferenceTypeId AS ReferenceTypeId FROM #FileTable FT 
								LEFT JOIN UploadFile UF ON UF.Id=FT.FileId
				END
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