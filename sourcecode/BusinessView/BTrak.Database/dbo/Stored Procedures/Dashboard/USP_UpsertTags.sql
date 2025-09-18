-------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2020-06-15 00:00:00.000'
-- Purpose      To Save or Update multiple tags
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [dbo].USP_UpsertTags  @OperationsPerformedBy='796C21F3-5171-4F7D-A9FD-99812A7A1FA9',

CREATE PROCEDURE USP_UpsertTags
(
 @TagId UNIQUEIDENTIFIER = NULL,
 @TagName NVARCHAR(MAX) = NULL,
 @ParentTagId UNIQUEIDENTIFIER = NULL,
 @IsForDelete BIT NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON 
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))


		IF(@HavePermission = '1')
		BEGIN


			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@TagId = '00000000-0000-0000-0000-000000000000') SET @TagId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			 DECLARE @Currentdate DATETIME = GETDATE()
			  IF(@IsForDelete = 1)
				   BEGIN
				   UPDATE [dbo].Tags 
							SET UpdatedDateTime = @Currentdate,
							    UpdatedByUserId = @OperationsPerformedBy,
								InActiveDateTime = @Currentdate
							    WHERE Id = @TagId
			END
		
				ELSE  IF(@TagId IS NULL)
				   BEGIN
							IF(EXISTS(SELECT * FROM Tags T WHERE T.TagName = @TagName AND T.CompanyId = @CompanyId AND T.InActiveDateTime IS NULL))
							BEGIN
								RAISERROR(50001,16,1,'Tag')
							END	
						ELSE
						BEGIN
					   SET @TagId = NEWID()

						INSERT INTO [dbo].Tags(
									[Id],
									[TagName],
									[ParentTagId],
									[CompanyId],
									[CreatedDateTime],
									[CreatedByUserId])
							 VALUES(@TagId,
									@TagName,
									@ParentTagId,
									@CompanyId,
									@Currentdate,
									@OperationsPerformedBy)
						END
				  END
					ELSE
					BEGIN
					IF(EXISTS(SELECT * FROM Tags T WHERE T.TagName = @TagName AND T.CompanyId = @CompanyId AND T.InActiveDateTime IS NULL AND T.Id <> @TagId))
					BEGIN
						RAISERROR(50001,16,1,'Tag')
					END	
					ELSE
					UPDATE [dbo].Tags 
								SET 
								[TagName] = @TagName,
								[ParentTagId] = @ParentTagId,
								UpdatedDateTime = @Currentdate,
							    UpdatedByUserId = @OperationsPerformedBy
							    WHERE Id = @TagId

			END

			SELECT @TagId

		END
		ELSE
			
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO