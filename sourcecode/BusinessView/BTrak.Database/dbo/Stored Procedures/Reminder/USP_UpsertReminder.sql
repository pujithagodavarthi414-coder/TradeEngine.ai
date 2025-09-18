-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-05-14 00:00:00.000'
-- Purpose      To save or update Reminder
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpsertReminder] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [USP_UpsertReminder]
(
	@ReminderId UNIQUEIDENTIFIER = NULL, 
    @RemindOn DATE = NULL,
	@OfUser UNIQUEIDENTIFIER = NULL,
    @NotificationType INT = NULL, 
    @ReferenceTypeId UNIQUEIDENTIFIER = NULL, 
    @ReferenceId UNIQUEIDENTIFIER = NULL, 
    @AdditionalInfo NVARCHAR(650) = NULL, 
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @RemindersCount INT = (SELECT COUNT(1) FROM Reminder WHERE Id = @ReminderId) 
			
			IF(@ReminderId IS NOT NULL AND @RemindersCount = 0)
			BEGIN
				
					RAISERROR(50001,16,1,'Reminder')

				END
			ELSE
			BEGIN
				
				    DECLARE @CurrentDate DATETIME = GETDATE()	
					IF (@ReminderId IS NULL) 
					BEGIN

						SET @ReminderId = NEWID()

						  INSERT INTO Reminder(Id,
											RemindOn,
											OfUser,
							    			NotificationType,
											ReferenceTypeId,
											ReferenceId,
											AdditionalInfo,
											CompanyId,
											[Status],
							    			CreatedDateTime,
							    			CreatedByUserId,
							    			InactiveDateTime
							    		   )
							    	SELECT  @ReminderId,
											@RemindOn,
											@OfUser,
											@NotificationType,
											@ReferenceTypeId,
											@ReferenceId,
											@AdditionalInfo,
											@CompanyId,
											'New',
							    			@CurrentDate,
							    			@OperationsPerformedBy,
										    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
		              
					   END
					ELSE
					BEGIN

					   UPDATE [Reminder]
					     SET  RemindOn = @RemindOn,
							  OfUser = @OfUser,
							  NotificationType = @NotificationType,
							  ReferenceTypeId = @ReferenceTypeId,
							  ReferenceId = @ReferenceId,
							  AdditionalInfo = @AdditionalInfo,
							  [Status] = 'New',
							  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							  UpdatedDateTime = @CurrentDate
							 WHERE Id = @ReminderId


						SELECT Id FROM Reminder WHERE Id = @ReminderId
					END
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
