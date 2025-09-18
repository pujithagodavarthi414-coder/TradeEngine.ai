----------------------------------------------------------------------
-- Author       Akhil Ankireddy
-- Created      '2019-11-01 00:00:00.000'
-- Purpose      To share messages
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------
--WITH @UserId
--EXEC USP_GetSharedFiles @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',
--@UserId = '0B2921A9-E930-4013-9047-670B5352F308'
--WITHOUT @UserId
--EXEC USP_GetSharedFiles @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308'
----------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetSharedFiles](
	@UserId UNIQUEIDENTIFIER = NULL,-- Selected UserId 
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @ChannelId UNIQUEIDENTIFIER = NULL -- Selected ChannelId
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy, (SELECT OBJECT_NAME(@@PROCID))))
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF(@HavePermission = '1')
			BEGIN
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

			IF(@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL

			IF(@ChannelId IS NOT NULL)
				Begin
							SELECT M.OriginalCreatedDateTime AS MessageCreatedDateTime,
							M.FilePath,
							M.SenderUserId  
							FROM [Message] M 
							LEFT JOIN [MessageReadReceipt] MRR ON MRR.MessageId = M.Id AND MRR.ReceiverUserId = @OperationsPerformedBy
							INNER JOIN [User] U ON U.Id = M.SenderUserId
							WHERE U.CompanyId = @CompanyId 
							      AND M.InActiveDateTime IS NULL 
								  AND M.FilePath IS NOT NULL
							      AND (@ChannelId IS NULL OR M.ChannelId = @ChannelId)								
							ORDER BY M.OriginalCreatedDateTime DESC

				end
            Else

				SELECT M.OriginalCreatedDateTime AS MessageCreatedDateTime,
							M.FilePath,
							M.SenderUserId  
							FROM [Message] M 
							LEFT JOIN [MessageReadReceipt] MRR ON MRR.MessageId = M.Id AND MRR.ReceiverUserId = @OperationsPerformedBy
							INNER JOIN [User] U ON U.Id = M.SenderUserId
							WHERE U.CompanyId = @CompanyId 
							      AND M.InActiveDateTime IS NULL 
								  AND M.FilePath IS NOT NULL
								  AND ((M.SenderUserId = @OperationsPerformedBy AND M.ReceiverUserId = @UserId) OR (M.SenderUserId = @UserId AND M.ReceiverUserId = @OperationsPerformedBy))
								
							ORDER BY M.OriginalCreatedDateTime DESC
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
GO