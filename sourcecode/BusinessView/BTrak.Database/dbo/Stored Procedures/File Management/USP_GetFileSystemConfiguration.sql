CREATE PROCEDURE [dbo].[USP_GetFileSystemConfiguration]
(
	@UserId UNIQUEIDENTIFIER,
	@DeviceId NVARCHAR(500) = NULL
)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY

			DECLARE @EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
				@CompanyId UNIQUEIDENTIFIER,
				@FileSystem NVARCHAR(50),
				@LocalPath NVARCHAR(500)

			IF(@UserId = @EmptyGuid AND @DeviceId IS NOT NULL)
			BEGIN
				SET @UserId = (SELECT TOP 1 UserId FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, NULL))
			END

			SET @CompanyId = (SELECT TOP 1 CompanyId FROM [User] WHERE Id = @UserId)
			SET @FileSystem = (SELECT TOP 1 [Value] FROM CompanySettings WHERE [Key] = 'FileSystem')
			SET @LocalPath = (SELECT TOP 1 [Value] FROM CompanySettings WHERE [Key] = 'LocalFileSystemPath')

			SELECT (CASE WHEN @FileSystem = 'Azure' THEN 2
									ELSE 1 END) AS FileSystemTypeEnum,
						CASE WHEN @LocalPath IS NULL THEN 'C://Snovasys//LOCAL_STORAGE' ELSE @LocalPath END AS LocalFileBasePath,
						(SELECT TOP 1 CompanyName FROM Company WHERE Id = @CompanyId) AS CompanyName

	END TRY  
	BEGIN CATCH 
		EXEC USP_GetErrorInformation
	END CATCH
END
GO