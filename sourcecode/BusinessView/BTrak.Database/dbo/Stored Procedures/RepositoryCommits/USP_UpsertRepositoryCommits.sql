-------------------------------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-11-12 00:00:00.000'
-- Purpose      Add or update repository commits
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertRepositoryCommits]
(
	@FromSource NVARCHAR(50) NULL,
	@CommitMessage NVARCHAR(2000) NULL,
	@CommiterEmail NVARCHAR(50) NULL,
	@CommiterName NVARCHAR(100) NULL,
	@FilesModifiedXml NVARCHAR(MAX) NULL,
	@FiledAddedXml NVARCHAR(MAX) NULL,
	@FilesRemovedXml NVARCHAR(MAX) NULL,
	@RepositoryName NVARCHAR(250) NULL,
	@CommitReferenceUrl NVARCHAR(600) NULL,
	@CompanyId UNIQUEIDENTIFIER NULL,
	@CommitedDateTime DATETIME NULL,
	@CommitedByUserId UNIQUEIDENTIFIER NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @RepositoryId UNIQUEIDENTIFIER = NEWID()
           
        DECLARE @Currentdate DATETIME
		
		SET @Currentdate =  CASE WHEN (@CommitedDateTime IS NOT NULL) THEN  @CommitedDateTime ELSE GETDATE() END

        INSERT INTO [dbo].[RepositoryCommits](
                    [Id],
                    [CompanyId],
                    [CommiterEmail],
					[CommiterName],
					[CommitMessage],
					[CommitReferenceUrl],
					[CreatedDateTime],
					[FiledAdded],
					[FilesModified],
					[FilesRemoved],
					[FromSource],
					[RepositoryName],
					[CommitedByUserId]
				   )
             SELECT NEWID(),
                    @CompanyId,
                    @CommiterEmail,
                    @CommiterName,
					@CommitMessage,
					@CommitReferenceUrl,
					@Currentdate,
					@FiledAddedXml,
					@FilesModifiedXml,
					@FilesRemovedXml,
					@FromSource,
					@RepositoryName,
					@CommitedByUserId
		     
          SELECT Id FROM [dbo].[RepositoryCommits] WHERE Id = @RepositoryId
	
	END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO