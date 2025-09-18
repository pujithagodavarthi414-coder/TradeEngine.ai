CREATE PROCEDURE [dbo].[USP_UpsertCustomField]
(
	@CustomFormFieldId UNIQUEIDENTIFIER = NULL,
    @FormName NVARCHAR(100) = NULL,
    @FormJson NVARCHAR(MAX) = NULL,
	@FormKeys NVARCHAR(MAX) = NULL,
	@IsArchived BIT = NULL,
	@ModuleTypeId INT = NULL,
	@ReferenceId UNIQUEIDENTIFIER = NULL,
	@ReferenceTypeId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy  UNIQUEIDENTIFIER,
	@TimeZone NVARCHAR(250) = NULL
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
	 DECLARE @FormNameCount INT = (SELECT COUNT(1) FROM CustomField WHERE FieldName = @FormName AND CompanyId=@ComapnyId AND ModuleTypeId = @ModuleTypeId AND ReferenceTypeId = @ReferenceTypeId AND InactiveDateTime IS NULL AND (Id <> @CustomFormFieldId OR @CustomFormFieldId IS NULL))
	 IF (@FormName = '') SET @FormName = NULL
     IF (@FormJson = '') SET @FormJson = NULL
	 IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL
     IF(@ReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @ReferenceTypeId = NULL


      IF(@FormName IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'FormName')
      END
      ELSE IF(@FormJson IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'CustomFieldjson')
      END
	  ELSE IF(@ModuleTypeId IS NULL)
	  BEGIN
           
           RAISERROR(50011,16, 2, 'ModuleTypeId')
      END
	  ELSE IF(@ReferenceId IS NULL)
	  BEGIN
           
           RAISERROR(50011,16, 2, 'ReferenceId')
      END
	  ELSE IF(@ReferenceTypeId IS NULL)
	  BEGIN
           
           RAISERROR(50011,16, 2, 'ReferenceTypeId')
      END
	  ELSE IF(@FormNameCount > 0)
      BEGIN
           RAISERROR(50001,16,1,'CustomField')
      END

	  ELSE
	   BEGIN
	          DECLARE @IsLatest BIT = (CASE WHEN @CustomFormFieldId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                       FROM CustomField WHERE Id = @CustomFormFieldId) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

		           IF(@IsLatest = 1)
                     BEGIN
					      DECLARE @Currentdate DATETIME = GETDATE()
						  DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
					   SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
                       DECLARE @Currentdatetime DATETIMEOFFSET =   dbo.Ufn_GetCurrentTime(@Offset)  
						  IF(@CustomFormFieldId IS NULL)
						    BEGIN
							  SET @CustomFormFieldId  = NEWID()
						       INSERT INTO [dbo].[CustomField](
							                            [Id],
														[FieldName],
														[FormJson],
														[FormKeys],
														[ModuleTypeId],
														[ReferenceId],
														[ReferenceTypeId],
														[CreatedDateTime],
														[CreatedByUserId],
														[CompanyId]
							                                   )
												SELECT @CustomFormFieldId,
												       @FormName,
													   @FormJson,
													   @FormKeys,
													   @ModuleTypeId,
													   @ReferenceId,
													   @ReferenceTypeId,
													   @Currentdate,
													   @OperationsPerformedBy,
													   @CompanyId


													   	INSERT INTO [dbo].[CustomFieldHistory](
									                                   [Id],
																	   [CustomFieldId],
																	   [ReferenceId],
																	   [ReferenceTypeId],
																	   [NewValue],
																	   [Description],
																	   [CreatedDateTime],
																	   [CreatedByUserId],
																	   [CreatedDateTimeZoneId]
									                                   )
														       SELECT  NEWID(),
															           @CustomFormFieldId,
																	   @ReferenceId,
																	   @ReferenceTypeId,
																	   @FormJson,
																	   'FormDataJsonCreated',
																	   @Currentdatetime,
																	   @OperationsPerformedBy,
																	   @TimeZoneId

						    if(@ReferenceTypeId='21455f5f-26d2-433c-80c7-a227948763ec')
							BEGIN
							UPDATE [EmployeeFormKeys] SET InActiveDateTime = GETDATE() WHERE CustomFieldsId = @ReferenceTypeId
							INSERT INTO [EmployeeFormKeys](
                            Id
                            ,CustomFieldsId
                            ,[Key]
							,[Label]
                            ,CreatedByUserId
                            ,CreatedDateTime
                            )
						SELECT NEWID()
                        ,@ReferenceTypeId
                        ,JSON_VALUE(value,'$.key')
						,JSON_VALUE(value,'$.label')
                        ,@OperationsPerformedBy
                        ,@Currentdate
						FROM OPENJSON(@FormKeys)
							END


													

						    END
						  ELSE
						  BEGIN

							DECLARE @OldFormDataJson NVARCHAR(MAX) = (SELECT FormJson FROM [dbo].[CustomField] WHERE ReferenceId = @ReferenceId AND ReferenceTypeId = @ReferenceTypeId AND Id = @CustomFormFieldId )
							DECLARE @OldFormName NVARCHAR(MAX) = (SELECT FieldName FROM [dbo].[CustomField] WHERE ReferenceId = @ReferenceId AND ReferenceTypeId = @ReferenceTypeId AND Id = @CustomFormFieldId )

						           UPDATE [dbo].[CustomField]
								     SET FieldName = @FormName,
									     FormJson  = @FormJson,
										 FormKeys  = @FormKeys,
										 ModuleTypeId = @ModuleTypeId,
										 ReferenceId = @ReferenceId,
										 ReferenceTypeId = @ReferenceTypeId,
										 UpdatedDateTime = @Currentdate,
										 UpdatedByUserId = @OperationsPerformedBy,
										 InactiveDateTime = Case When @IsArchived = 1 THEN @Currentdate ELSE NULL END
									WHERE Id = @CustomFormFieldId
									if(@ReferenceTypeId='21455f5f-26d2-433c-80c7-a227948763ec')
							BEGIN
							UPDATE [EmployeeFormKeys] SET InActiveDateTime = GETDATE() WHERE CustomFieldsId = @ReferenceTypeId
							INSERT INTO [EmployeeFormKeys](
                            Id
                            ,CustomFieldsId
                            ,[Key]
							,[Label]
                            ,CreatedByUserId
                            ,CreatedDateTime
                            )
						SELECT NEWID()
                        ,@ReferenceTypeId
                        ,JSON_VALUE(value,'$.key')
						,JSON_VALUE(value,'$.label')
                        ,@OperationsPerformedBy
                        ,@Currentdate
						FROM OPENJSON(@FormKeys)
						END

									IF(@OldFormDataJson IS NOT NULL AND @OldFormDataJson <> @FormJson )
									BEGIN

										INSERT INTO [dbo].[CustomFieldHistory](
									                                   [Id],
																	   [CustomFieldId],
																	   [ReferenceId],
																	   [ReferenceTypeId],
																	   [OldValue],
																	   [NewValue],
																	   [Description],
																	   [CreatedDateTime],
																	   [CreatedByUserId],
																	   [CreatedDateTimeZoneId]
									                                   )
														       SELECT  NEWID(),
															           @CustomFormFieldId,
																	   @ReferenceId,
																	   @ReferenceTypeId,
																	   @OldFormDataJson,
																	   @FormJson,
																	   'FormJsonUpdated',
																	   @Currentdatetime,
																	   @OperationsPerformedBy,
																	   @TimeZoneId
									END

									IF(@OldFormName IS NOT NULL AND @OldFormName <> @FormName )
									BEGIN

										INSERT INTO [dbo].[CustomFieldHistory](
									                                   [Id],
																	   [CustomFieldId],
																	   [ReferenceId],
																	   [ReferenceTypeId],
																	   [OldValue],
																	   [NewValue],
																	   [Description],
																	   [CreatedDateTime],
																	   [CreatedByUserId]
									                                   )
														       SELECT  NEWID(),
															           @CustomFormFieldId,
																	   @ReferenceId,
																	   @ReferenceTypeId,
																	   @OldFormName,
																	   @FormName,
																	   'FormNameUpdated',
																	   @Currentdate,
																	   @OperationsPerformedBy
									END

										IF(@IsArchived  = 1)
									BEGIN

										INSERT INTO [dbo].[CustomFieldHistory](
									                                   [Id],
																	   [CustomFieldId],
																	   [ReferenceId],
																	   [ReferenceTypeId],																	 
																	   [NewValue],
																	   [Description],
																	   [CreatedDateTime],
																	   [CreatedByUserId],
																	   [CreatedDateTimeZoneId]
									                                   )
														       SELECT  NEWID(),
															           @CustomFormFieldId,
																	   @ReferenceId,
																	   @ReferenceTypeId,																	  
																	   @FormName,
																	   'FormDeleted',
																	   @Currentdatetime,
																	   @OperationsPerformedBy,
																	   @TimeZoneId
									END


									 UPDATE CustomFormFieldKeys SET InActiveDateTime = GETDATE() WHERE CustomFieldId = @CustomFormFieldId
                INSERT INTO CustomFormFieldKeys(
                            Id
                            ,CustomFieldId
                            ,[Key]
							,[Label]
                            ,CreatedByUserId
                            ,CreatedDateTime
                            )
                 SELECT NEWID()
                        ,@CustomFormFieldId
                        ,JSON_VALUE(value,'$.key')
						,JSON_VALUE(value,'$.label')
                        ,@OperationsPerformedBy
                        ,@Currentdate
                 FROM OPENJSON(@FormKeys)
						  END 
						  SELECT Id FROM CustomField WHERE Id = @CustomFormFieldId
					 END
					ELSE
					BEGIN
					      RAISERROR (50008,11, 1)
					END
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
