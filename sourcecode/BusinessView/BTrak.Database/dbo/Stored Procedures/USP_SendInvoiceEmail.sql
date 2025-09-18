----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-11 00:00:00.000'
-- Purpose      To Send Invoice by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_SendInvoiceEmail] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @InvoiceId = 'AF174770-2AD0-4AA5-97B6-7CAB514EA9B4', @SendTo = 'srihari@snovasys.com'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SendInvoiceEmail]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @InvoiceId UNIQUEIDENTIFIER = NULL,
   @SendTo NVARCHAR(MAX) = NULL,
   @Subject NVARCHAR(150) = NULL,
   @Message NVARCHAR(MAX) = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	   	   	  		  
			DECLARE @InvoiceEmailId UNIQUEIDENTIFIER = NEWID()
		 
			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					DECLARE @Currentdate DATETIME = GETDATE()

					INSERT INTO [dbo].[InvoiceEmail](
								[Id],
								[InvoiceId],
								[SendTo],
								[Subject],
								[Message],
								[CreatedDateTime],
			   	         		[CreatedByUserId]
			   	         		)
							SELECT @InvoiceEmailId,
								   @InvoiceId,
								   @SendTo,
								   @Subject,
								   @Message,	
								   SYSDATETIMEOFFSET(),
			   	         		   @OperationsPerformedBy	

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