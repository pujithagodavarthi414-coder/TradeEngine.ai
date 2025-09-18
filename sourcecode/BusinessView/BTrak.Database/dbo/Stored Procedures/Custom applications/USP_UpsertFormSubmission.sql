-------------------------------------------------------------------------------
-- Author       Anupam sai kumar vuyyuru
-- Created      '2020-02-03 00:00:00.000'
-- Purpose      To Save or Update ObservationType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertFormSubmission]
(
  @FormSubmissionId UNIQUEIDENTIFIER = NULL,
  @AssignedToUserId UNIQUEIDENTIFIER = NULL,
  @AssignedByUserId UNIQUEIDENTIFIER = NULL,
  @GenericFormId UNIQUEIDENTIFIER = NULL,
  @FormData NVARCHAR(MAX) = NULL,
  @Status NVARCHAR(50) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @GenericFormIdCount INT = (SELECT COUNT(1) FROM GenericForm WHERE Id = @GenericFormId)
            
		IF(@GenericFormIdCount = 0 AND @GenericFormId IS NOT NULL)
            BEGIN
                RAISERROR(50002,16,1,'GenericForm')
            END

		ELSE
		BEGIN

		IF (@HavePermission = '1')
		BEGIN
		IF(@FormSubmissionId IS NULL)
		BEGIN

						SET @FormSubmissionId = NEWID()
					    INSERT INTO [dbo].[FormSubmissions](
						            Id,
						            GenericFormId,
						            FormData,
									[Status],
									AssignedByUserId,
									AssignedToUserId,
						            CreatedDateTime,
						            CreatedByUserId,
									InActiveDateTime
									)
						     SELECT @FormSubmissionId,
						            @GenericFormId,
						            @FormData,
									@Status,
									@AssignedByUserId,
									@AssignedToUserId,
						            @Currentdate,
						            @OperationsPerformedBy,
									CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
					  
					END
					ELSE
					BEGIN
					
						UPDATE [dbo].FormSubmissions
							SET     FormData		 =  	 @FormData,
									AssignedByUserId = @AssignedByUserId,
									AssignedToUserId = @AssignedToUserId,
									[Status] = @Status,
						            UpdatedDateTime		 =  	 @Currentdate,
						            UpdatedByUserId		 =  	 @OperationsPerformedBy,
									InActiveDateTime	 =  	 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
								WHERE Id = @FormSubmissionId

					END
					    SELECT Id FROM [dbo].[FormSubmissions] WHERE Id = @FormSubmissionId

		END
		ELSE
		BEGIN
			        
			  RAISERROR (@HavePermission,11, 1)
			           
		END  
		END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO
