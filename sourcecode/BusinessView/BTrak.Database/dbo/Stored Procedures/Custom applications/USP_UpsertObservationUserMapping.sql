
CREATE PROCEDURE [dbo].[USP_UpsertObservationUserMapping]
(
    @CustomDataFormFieldId UNIQUEIDENTIFIER = NULL,
	@CustomFormFieldId UNIQUEIDENTIFIER = NULL,
    @FormDataJson NVARCHAR(MAX) = NULL,
	@ReferenceId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy  UNIQUEIDENTIFIER
)  
AS
BEGIN
 SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
     IF (@HavePermission = '1')
     BEGIN

	 DECLARE @ComapnyId UNIQUEIDENTIFIER = (SELECT dbo.Ufn_GetCompanyIdBasedOnUserId(@OperationsPerformedBy))
	 DECLARE @IsLatest BIT = (CASE WHEN @CustomDataFormFieldId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                       FROM CustomFormFieldMapping WHERE Id = @CustomDataFormFieldId) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)

					DECLARE @ReferenceIdCount INT = (SELECT COUNT(1) FROM [dbo].[CustomFormFieldMapping] WHERE FormReferenceId = @ReferenceId AND FormId = @CustomFormFieldId)
			IF(@IsLatest = 1)
            BEGIN
			  DECLARE @Currentdate DATETIME = GETDATE()
			    IF(@ReferenceIdCount = 0)
						    BEGIN
							     SET @CustomDataFormFieldId  = NEWID()
						       INSERT INTO [dbo].[CustomFormFieldMapping](
							                            [Id],
														[FormId],
														[FormReferenceId],
														[FormDataJson],
														[CreatedDateTime],
														[CreatedByUserId]
							                                   )
												SELECT @CustomDataFormFieldId,
												       @CustomFormFieldId,
												       @ReferenceId,
													   @FormDataJson,
													   @Currentdate,
													   @OperationsPerformedBy
									INSERT INTO [dbo].[CustomFieldHistory](
									                                   [Id],
																	   [CustomFieldId],
																	   [ReferenceId],
																	   [NewValue],
																	   [Description],
																	   [CreatedDateTime],
																	   [CreatedByUserId]
									                                   )
														       SELECT  NEWID(),
															           @CustomFormFieldId,
																	   @ReferenceId,
																	   @FormDataJson,
																	   'FormDataJsonInserted',
																	   @Currentdate,
																	   @OperationsPerformedBy

						    END
						  ELSE
						  BEGIN
					DECLARE @OldFormDataJson NVARCHAR(MAX) = (SELECT FormDataJson FROM [dbo].[CustomFormFieldMapping] WHERE FormReferenceId = @ReferenceId AND FormId = @CustomFormFieldId)
						           UPDATE [dbo].[CustomFormFieldMapping]
								     SET FormId = @CustomFormFieldId,
									     FormDataJson  = @FormDataJson,
										 FormReferenceId  = @ReferenceId,
										 UpdatedDateTime = @Currentdate,
										 UpdatedByUserId = @OperationsPerformedBy
									
									WHERE FormReferenceId = @ReferenceId AND FormId = @CustomFormFieldId

									INSERT INTO [dbo].[CustomFieldHistory](
									                                   [Id],
																	   [CustomFieldId],
																	   [ReferenceId],
																	   [OldValue],
																	   [NewValue],
																	   [Description],
																	   [CreatedDateTime],
																	   [CreatedByUserId]
									                                   )
														       SELECT  NEWID(),
															           @CustomFormFieldId,
																	   @ReferenceId,
																	   @OldFormDataJson,
																	   @FormDataJson,
																	   'FormDataJsonUpdated',
																	   @Currentdate,
																	   @OperationsPerformedBy

							END
							 SELECT Id FROM CustomFormFieldMapping WHERE Id = @CustomDataFormFieldId
			 END
					ELSE
					BEGIN
					      RAISERROR (50008,11, 1)
					END
		END	    
		ELSE
        BEGIN
                
				RAISERROR (@HavePermission,11, 1)
                   
        END
    END TRY
    BEGIN CATCH
         THROW
    END CATCH
END
GO

