-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-06-27 00:00:00.000'
-- Purpose      To save or update signature
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpsertSignature] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [USP_UpsertSignature]
(
 @SignatureId UNIQUEIDENTIFIER = NULL,
 @ReferenceId UNIQUEIDENTIFIER = NULL,
 @InviteeId UNIQUEIDENTIFIER = NULL,
 @SignatureUrl NVARCHAR(600) = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @SignatureCount INT = (SELECT COUNT(1) FROM [Signature] WHERE Id = @SignatureId AND CompanyId = @CompanyId )
			
			DECLARE @InviteesCount INT = (SELECT COUNT(1) FROM [Signature] WHERE ReferenceId = @ReferenceId AND InviteeId = @InviteeId AND InActiveDateTime IS NULL) 

			IF (@InviteesCount > 0 AND @SignatureId IS NULL)
			BEGIN
				    
					RAISERROR(50001,16,1,'Invitee')

		    END

			DECLARE @CurrentDate DATETIME = GETDATE()

			IF (@SignatureCount = 0) 
			BEGIN

				SET @SignatureId = NEWID()
				INSERT INTO [Signature](Id,
							ReferenceId,
							SignatureUrl,
							CompanyId,
							InviteeId,
							CreatedDateTime,
							CreatedByUserId,
							InactiveDateTime)
					SELECT  @SignatureId,
							@ReferenceId,
							@SignatureUrl,
							@CompanyId,
							@InviteeId,
							@CurrentDate,
							@OperationsPerformedBy,
							CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
		              
			END
			ELSE
			BEGIN

				UPDATE [Signature]
				  SET SignatureUrl = @SignatureUrl,
					  InviteeId = @InviteeId,
					  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
					  UpdatedDateTime = @CurrentDate,
					  UpdatedByUserId = @OperationsPerformedBy
					 WHERE Id = @SignatureId

			END

			SELECT Id FROM [Signature] WHERE Id = @SignatureId
		
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO