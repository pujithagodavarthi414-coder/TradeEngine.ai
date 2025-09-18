CREATE PROCEDURE [dbo].[USP_UpsertUserWebHooks]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER,
 @WebHooksXml Xml
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
​
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
​
		IF (@HavePermission = '1')
		BEGIN

			IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
​
			IF (@UserId IS NULL)
				BEGIN
​
					RAISERROR('UserIdShouldNotBeNull',11,1)
​
				END
			ELSE
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @IsAlreadyExist UNIQUEIDENTIFIER
				SET @IsAlreadyExist = (SELECT Id FROM UserWebHooks WHERE UserId = @UserId)

				IF(@IsAlreadyExist IS NULL)
					BEGIN
						INSERT INTO UserWebHooks
						(Id,UserId,WebHooksXml,CreatedByUserId,CreatedDatetime,CompanyId,InActiveDatetime)
						VALUES
						(NEWID(),@UserId,@WebHooksXml,@OperationsPerformedBy,GETDATE(),@CompanyId,NULL)
					END
				ELSE
					UPDATE UserWebHooks SET UserId=@UserId,WebHooksXml=@WebHooksXml,CreatedByUserId=@OperationsPerformedBy,CreatedDatetime=GETDATE(),CompanyId=@CompanyId WHERE Id=@IsAlreadyExist

		END
		ELSE
			RAISERROR(@HavePermission,11,1)
	END TRY
	BEGIN CATCH
​
		THROW
​
	END CATCH
END
