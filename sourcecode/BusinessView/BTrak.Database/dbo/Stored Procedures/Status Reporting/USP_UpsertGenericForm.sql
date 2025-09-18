-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-07-20 00:00:00.000'
-- Purpose      To Update or Save GenericForms
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertGenericForm] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@FormTypeId = 'D3238916-4958-4C61-9F53-1C67F9B793AA' , @FormName = 'Test Form',@FormJson = 'Test'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertGenericForm]
(
    @GenericFormId UNIQUEIDENTIFIER = NULL,
    @FormTypeId UNIQUEIDENTIFIER,
    @DataSourceId UNIQUEIDENTIFIER,
    @FormName NVARCHAR(250),
	@WorkflowTrigger NVARCHAR(1000),
    @FormJson NVARCHAR(MAX),
    @OperationsPerformedBy  UNIQUEIDENTIFIER,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @FormKeys NVARCHAR(MAX),
	@IsAbleToLogin BIT = NULL,
	@IsAbleToComment BIT = NULL,
	@IsAbleToPay BIT = NULL,
	@IsAbleToCall BIT = NULL,
	@RoleForCall NVARCHAR(MAX) = NULL,
	@RoleForComment NVARCHAR(MAX) = NULL,
	@RoleForPay NVARCHAR(MAX) = NULL,
	@CompanyModuleId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
     DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
     IF (@HavePermission = '1')
     BEGIN

      DECLARE @ComapnyId UNIQUEIDENTIFIER = (SELECT dbo.Ufn_GetCompanyIdBasedOnUserId(@OperationsPerformedBy))
      
	  IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
      
	  IF (@FormTypeId = '00000000-0000-0000-0000-000000000000') SET @FormTypeId = NULL
      
	  IF (@FormName = '') SET @FormName = NULL
      
	  IF (@FormJson = '') SET @FormJson = NULL
      
	  IF(@FormName IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'FormTypeName')
      END
      ELSE IF(@FormJson IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'Formjson')
      END
      ELSE 
      BEGIN
            IF(@GenericFormId = '00000000-0000-0000-0000-000000000000') SET @GenericFormId = NULL
            
			DECLARE @GenericFormIdCount INT = (SELECT COUNT(1) FROM GenericForm WHERE Id = @GenericFormId)
            
			DECLARE @GenericFormNameCount INT = (SELECT COUNT(1) FROM GenericForm WHERE FormName = @FormName AND (@GenericFormId IS NULL OR (Id <> @GenericFormId)) AND InActiveDateTime IS NULL AND (SELECT [dbo].Ufn_GetCompanyIdBasedOnUserId(CreatedByUserId)) = @ComapnyId)
            
			IF(@GenericFormIdCount = 0 AND @GenericFormId IS NOT NULL)
            BEGIN
                RAISERROR(50002,16,1,'GenericForm')
            END
            ELSE IF(@GenericFormNameCount > 0)
            BEGIN
                RAISERROR(50001,16,1,'GenericForm')
            END
            ELSE
            BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @GenericFormId IS NULL THEN 1 ELSE CASE WHEN(SELECT [TimeStamp] FROM GenericForm WHERE Id = @GenericFormId ) = @TimeStamp THEN 1 ELSE 0 END END )
				
				IF(@IsLatest = 1)
					BEGIN
						IF(@IsArchived = 1 AND @GenericFormId IS NOT NULL)
				    BEGIN
				        DECLARE @StatusConfigurationsCount INT = CASE WHEN EXISTS(SELECT 1 FROM StatusReportingConfiguration_New WHERE GenericFormId = @GenericFormId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END
				        IF(@StatusConfigurationsCount = 1)
				            BEGIN
				                RAISERROR ('ThisFormUsedInStatusReportConfigurationPleaseDeleteTheDependenciesAndTryAgain',11, 1)
				            END
				    END

						    DECLARE @Currentdate DATETIME = GETDATE()

						IF (@GenericFormId IS NULL)
							BEGIN
							    SET @GenericFormId = NEWID()
							        
								INSERT INTO [dbo].[GenericForm](
                                [Id],
								[DataSourceId],
                                [FormTypeId],
                                [FormName],
								[WorkflowTrigger],
                                [FormJson],
                                [CreatedDateTime],
                                [CreatedByUserId],
                                [InActiveDateTime],
								[CompanyModuleId]
                                )
								SELECT @GenericFormId,
								@DataSourceId,
                                @FormTypeId,
                                @FormName,
								@WorkflowTrigger,
                                @FormJson,
                                @Currentdate,
                                @OperationsPerformedBy,
                                CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								@CompanyModuleId

							    
							END
						ELSE
							BEGIN
								UPDATE  [dbo].[GenericForm]
								    SET [FormTypeId]                  =   @FormTypeId,
											[DataSourceId]			  =	  @DataSourceId,
								            [FormName]                =   @FormName,
											[WorkflowTrigger]		  =   @WorkflowTrigger,
								            [FormJson]                =   @FormJson,
								            [UpdatedDateTime]         =   @Currentdate,
								            [UpdatedByUserId]         =   @OperationsPerformedBy,
											[CompanyModuleId]         =   @CompanyModuleId,
								            [InActiveDateTime]        =   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
								        WHERE Id = @GenericFormId
								
							END    

						DECLARE @FormAccessibilityId UNIQUEIDENTIFIER = (SELECT Id FROM FormAccessibility WHERE FormId = @GenericFormId)

						IF(@FormAccessibilityId IS NULL)
						BEGIN
						
								INSERT INTO [dbo].[FormAccessibility](
                                [Id],
                                [FormId],
                                [IsAbleToLogin],
                                [IsAbleToPay],
                                [IsAbleToCall],
                                [IsAbleToComment],
                                [CreatedDateTime],
                                [CreatedByUserId],
                                [InActiveDateTime]
                                )
							SELECT NEWID(),
                                @GenericFormId,
                                @IsAbleToLogin,
                                @IsAbleToPay,
                                @IsAbleToCall,
                                @IsAbleToComment,
                                @Currentdate,
                                @OperationsPerformedBy,
                                CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

						END
						ELSE
						BEGIN
							UPDATE  [dbo].[FormAccessibility]
								SET		[IsAbleToLogin]         =   @IsAbleToLogin,
										[IsAbleToPay]           =   @IsAbleToPay,
										[IsAbleToCall]          =   @IsAbleToCall,
										[IsAbleToComment]       =   @IsAbleToComment,
								        [UpdatedDateTime]       =   @Currentdate,
								        [UpdatedByUserId]       =   @OperationsPerformedBy,
								        [InActiveDateTime]      =   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
								    WHERE FormId = @GenericFormId


						END

							IF(@IsAbleToCall = 1)
							BEGIN
								IF(@RoleForCall IS NOT NULL)
								BEGIN
									UPDATE [FormAccessibilityRoleMapping]  SET InActiveDatetime = GETDATE() WHERE FormId = @GenericFormId AND MapType = 'CALL' AND (RoleId NOT IN (SELECT CONVERT(UNIQUEIDENTIFIER, [VALUE]) FROM DBO.Ufn_StringSplit(@RoleForCall, ','))  OR RoleId IS NULL)

									INSERT INTO [FormAccessibilityRoleMapping] (Id, FormId, RoleId, MapType, CreatedDateTime, CreatedByUserId)
									SELECT NEWID(), @GenericFormId, CONVERT(UNIQUEIDENTIFIER, [VALUE]), 'CALL', GETDATE(), @OperationsPerformedBy FROM DBO.Ufn_StringSplit(@RoleForCall, ',') WHERE CONVERT(UNIQUEIDENTIFIER, [VALUE]) NOT IN (SELECT RoleId FROM [FormAccessibilityRoleMapping] WHERE FormId = @GenericFormId AND MapType = 'CALL'  AND InactiveDatetime IS NULL AND RoleId IS NOT NULL)
								END
								ELSE
								BEGIN
									UPDATE [FormAccessibilityRoleMapping]  SET InActiveDatetime = GETDATE() WHERE FormId = @GenericFormId AND MapType = 'CALL';

									INSERT INTO [FormAccessibilityRoleMapping] (Id, FormId, RoleId, MapType, CreatedDateTime, CreatedByUserId)
									SELECT NEWID(), @GenericFormId, NULL, 'CALL', GETDATE(), @OperationsPerformedBy
								END
							END
							ELSE
							BEGIN
								UPDATE [FormAccessibilityRoleMapping]  SET InActiveDatetime = GETDATE() WHERE FormId = @GenericFormId AND MapType = 'CALL';
							END
							IF(@IsAbleToComment = 1)
							BEGIN
								IF(@RoleForComment IS NOT NULL)
								BEGIN
									UPDATE [FormAccessibilityRoleMapping]  SET InActiveDatetime = GETDATE() WHERE FormId = @GenericFormId AND MapType = 'COMMENT' AND (RoleId NOT IN (SELECT CONVERT(UNIQUEIDENTIFIER, [VALUE]) FROM DBO.Ufn_StringSplit(@RoleForComment, ','))  OR RoleId IS NULL)

									INSERT INTO [FormAccessibilityRoleMapping] (Id, FormId, RoleId, MapType, CreatedDateTime, CreatedByUserId)
									SELECT NEWID(), @GenericFormId, CONVERT(UNIQUEIDENTIFIER, [VALUE]), 'COMMENT', GETDATE(), @OperationsPerformedBy FROM DBO.Ufn_StringSplit(@RoleForComment, ',') WHERE CONVERT(UNIQUEIDENTIFIER, [VALUE]) NOT IN (SELECT RoleId FROM [FormAccessibilityRoleMapping] WHERE FormId = @GenericFormId AND MapType = 'COMMENT' AND InactiveDatetime IS NULL AND RoleId IS NOT NULL )
								END
								ELSE
								BEGIN
									UPDATE [FormAccessibilityRoleMapping]  SET InActiveDatetime = GETDATE() WHERE FormId = @GenericFormId AND MapType = 'COMMENT';

									INSERT INTO [FormAccessibilityRoleMapping] (Id, FormId, RoleId, MapType, CreatedDateTime, CreatedByUserId)
									SELECT NEWID(), @GenericFormId, NULL, 'COMMENT', GETDATE(), @OperationsPerformedBy
								END
							END
							ELSE
							BEGIN
								UPDATE [FormAccessibilityRoleMapping]  SET InActiveDatetime = GETDATE() WHERE FormId = @GenericFormId AND MapType = 'COMMENT';
							END
							
							IF(@IsAbleToPay = 1)
							BEGIN
								IF(@RoleForPay IS NOT NULL)
								BEGIN
									UPDATE [FormAccessibilityRoleMapping]  SET InActiveDatetime = GETDATE() WHERE FormId = @GenericFormId AND MapType = 'PAY' AND ( RoleId NOT IN (SELECT CONVERT(UNIQUEIDENTIFIER, [VALUE]) FROM DBO.Ufn_StringSplit(@RoleForPay, ',')) OR RoleId IS NULL)

									INSERT INTO [FormAccessibilityRoleMapping] (Id, FormId, RoleId, MapType, CreatedDateTime, CreatedByUserId)
									SELECT NEWID(), @GenericFormId, CONVERT(UNIQUEIDENTIFIER, [VALUE]), 'PAY', GETDATE(), @OperationsPerformedBy FROM DBO.Ufn_StringSplit(@RoleForPay, ',')  WHERE CONVERT(UNIQUEIDENTIFIER, [VALUE]) NOT IN (SELECT RoleId FROM [FormAccessibilityRoleMapping] WHERE FormId = @GenericFormId AND MapType = 'PAY' AND InactiveDatetime IS NULL  AND RoleId IS NOT NULL)
								END
								ELSE
								BEGIN
									UPDATE [FormAccessibilityRoleMapping]  SET InActiveDatetime = GETDATE() WHERE FormId = @GenericFormId AND MapType = 'PAY';

									INSERT INTO [FormAccessibilityRoleMapping] (Id, FormId, RoleId, MapType, CreatedDateTime, CreatedByUserId)
									SELECT NEWID(), @GenericFormId, NULL, 'PAY', GETDATE(), @OperationsPerformedBy
								END
							END
							ELSE
							BEGIN
								UPDATE [FormAccessibilityRoleMapping]  SET InActiveDatetime = GETDATE() WHERE FormId = @GenericFormId AND MapType = 'PAY';
							END

						UPDATE GenericFormKey SET InActiveDateTime = GETDATE() WHERE GenericFormId = @GenericFormId
						    
						INSERT INTO GenericFormKey(
                            Id
                            ,GenericFormId
                            ,[Key]
							,[Label]
							,[DataType]
                            ,CreatedByUserId
                            ,CreatedDateTime
                            )
                 SELECT NEWID()
                        ,@GenericFormId
                        ,JSON_VALUE(value,'$.key')
						,JSON_VALUE(value,'$.label')
						,JSON_VALUE(value,'$.type')    
                        ,@OperationsPerformedBy
                        ,@Currentdate
                 FROM OPENJSON(@FormKeys)
						    
						SELECT Id FROM GenericForm WHERE Id = @GenericFormId
					END
				ELSE
				   
				   RAISERROR(50008,11,1)
				END
      END
	END
    END TRY
    BEGIN CATCH
         THROW
    END CATCH
END