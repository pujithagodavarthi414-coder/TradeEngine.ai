-------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-02-12 00:00:00.000'
-- Purpose      To Save or Update Tag
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [dbo].USP_UpsertCustomTags  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ReferenceId = '',@Tags = 'user,Tier'
---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE USP_UpsertCustomTags
(
 @ReferenceId UNIQUEIDENTIFIER = NULL,
 @TagsXml XML = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON 
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN


		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))


			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL


			IF (@ReferenceId IS NULL)
			BEGIN

				RAISERROR(50011,11,1,'ReferenceId')

			END
			
			ELSE
			BEGIN
							
					DECLARE @Currentdate DATETIME = GETDATE()

					  declare  @Temp TABLE
						   (
						   Id UNIQUEIDENTIFIER,
						   TagId UNIQUEIDENTIFIER,
						   TagName NVARCHAR(250)
						   )
							INSERT INTO @Temp(Id,TagName,TagId)
						    SELECT Id,TagName,NEWID() FROM(
						    SELECT ISNULL(T.Id,TT.Id) Id,T.TagName FROM
						    (SELECT IIF(X.Y.value('TagId[1]', 'VARCHAR(100)') = '',NULL,X.Y.value('TagId[1]', 'UNIQUEIDENTIFIER')) Id,
						          RTRIM(LTRIM(X.Y.value('Tag[1]', 'varchar(250)'))) TagName
		                    FROM @TagsXml.nodes('/GenericListOfCustomTagsInputModel/ListItems/CustomTagsInputModel') X(Y))T 
							LEFT JOIN Tags TT ON T.TagName = TT.TagName AND TT.CompanyId = @CompanyId)Z 
							GROUP BY Z.Id,Z.TagName
						
					DELETE FROM CustomTags  WHERE ReferenceId = @ReferenceId 
					AND TagId NOT IN (SELECT Id FROM @Temp)

					 INSERT INTO [dbo].Tags(
			                    [Id],
			                    [TagName],
								[CompanyId],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
			                    )
                         SELECT T.TagId,
						        T.TagName,
							    @CompanyId,
								@Currentdate,
								@OperationsPerformedBy
							 FROM @Temp T 
							 WHERE T.Id IS NULL

			        INSERT INTO [dbo].CustomTags(
			                    [Id],
			                    [ReferenceId],
								[TagId],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
			                    )
                         SELECT NEWID(),
						        @ReferenceId,
							    ISNULL(T.Id,T.TagId),
								@Currentdate,
								@OperationsPerformedBy
							 FROM @Temp T LEFT JOIN CustomTags CT ON T.Id = CT.TagId AND CT.ReferenceId = @ReferenceId
							 WHERE CT.TagId IS NULL OR T.Id IS NULL

				SELECT @ReferenceId

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