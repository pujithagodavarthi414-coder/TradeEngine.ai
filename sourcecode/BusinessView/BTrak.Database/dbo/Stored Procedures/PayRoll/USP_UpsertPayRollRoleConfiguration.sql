---------------------------------------------------------------------------------------------
--EXEC USP_UpsertPayRollRoleConfiguration @PayRollRoleConfigurationId='251C6ED1-3988-42EE-B48C-4B9F7A241F21', 
--@OperationsPerformedBy= '127133F1-4427-4149-9DD6-B02E0E036971',
--@PayRollTemplateId = 'B1286B23-1362-4C47-BC94-0549099E9393',@RoleId = '1210DB37-93F7-4347-9240-E978A270B707',
--@TimeStamp = 0x00000000000024A0
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayRollRoleConfiguration]
(
   @PayRollRoleConfigurationId UNIQUEIDENTIFIER = NULL,
   @PayRollTemplateId UNIQUEIDENTIFIER = NULL,  
   @RoleId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY     
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

                  IF(@PayRollTemplateId = '00000000-0000-0000-0000-000000000000') SET @PayRollTemplateId = NULL   
                  
                  IF(@RoleId = '00000000-0000-0000-0000-000000000000') SET @RoleId = NULL 

				  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				  DECLARE @Currentdate DATETIME = GETDATE()

				  IF(@IsArchived = 1 AND @PayRollRoleConfigurationId IS NOT NULL)
		          BEGIN
		                 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'

	                     IF(EXISTS(SELECT Id FROM EmployeepayrollConfiguration WHERE PayrollTemplateId = @PayRollTemplateId AND (Convert(Date,ActiveTo) >= Convert(Date,@Currentdate) OR ActiveTo IS NULL) AND ActiveFrom IS NOT NULL AND InactiveDateTime IS NULL))
	                     BEGIN
	                     SET @IsEligibleToArchive = 'ThisPayRollTemplateUsedInEmployeePayRollConfigurationPleaseDeleteTheDependenciesAndTryAgain'
	                     END
		                 IF(@IsEligibleToArchive <> '1')
		                 BEGIN
		                    RAISERROR (@isEligibleToArchive,11, 1)
		                END
	              END

                  IF(@PayRollTemplateId IS NULL)
                  BEGIN
             
                  RAISERROR(50011,16, 2, 'PayRollTemplate')
          
                  END
                  IF(@RoleId IS NULL)
                  BEGIN
             
                  RAISERROR(50011,16, 2, 'Role')
          
                  END
                          
                  DECLARE @PayRollRoleConfigurationIdCount INT = (SELECT COUNT(1) FROM PayRollRoleConfiguration  WHERE Id = @PayRollRoleConfigurationId)

				  DECLARE @PayRollRoleConfigurationDuplicateCount INT = (SELECT COUNT(1) FROM PayRollRoleConfiguration WHERE [PayRollTemplateId] = @PayRollTemplateId AND [RoleId] = @RoleId AND CompanyId = @CompanyId 
																		AND (@PayRollRoleConfigurationId IS NULL OR @PayRollRoleConfigurationId <> Id))
                                      
                  IF(@PayRollRoleConfigurationIdCount = 0 AND @PayRollRoleConfigurationId IS NOT NULL)
                  BEGIN
              
                    RAISERROR(50002,16, 2,'PayRollRoleConfiguration')
          
                  END
				  IF (@PayRollRoleConfigurationDuplicateCount > 0)
		          BEGIN
		          
		          	RAISERROR(50001,11,1,'PayRollRoleConfiguration')
		          
		          END
                  ELSE
                  DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                  IF (@HavePermission = '1')
                  BEGIN
       
                          DECLARE @IsLatest BIT = (CASE WHEN @PayRollRoleConfigurationId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM PayRollRoleConfiguration WHERE Id = @PayRollRoleConfigurationId) = @TimeStamp THEN 1 ELSE 0 END END)
                    
                          IF(@IsLatest = 1)
                          BEGIN
                  
                              IF(@PayRollRoleConfigurationId IS NULL)
						      BEGIN
						      
						       SET @PayRollRoleConfigurationId = NEWID()
						      
                                      INSERT INTO [dbo].[PayRollRoleConfiguration](
                                                  [Id],
                                                  [PayRollTemplateId],
                                                  [RoleId],
                                                  [CreatedDateTime],
                                                  [CreatedByUserId],
												  [CompanyId],
												  [InActiveDateTime]
                                                  )
                                           SELECT @PayRollRoleConfigurationId,
                                                  @PayRollTemplateId,
                                                  @RoleId,
                                                  @Currentdate,
                                                  @OperationsPerformedBy ,
												  @CompanyId,
												  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
                                 
						      END
						      ELSE
						      BEGIN
						      
						      UPDATE [dbo].[PayRollRoleConfiguration]
                                           SET    [PayRollTemplateId] = @PayRollTemplateId,
                                                  [RoleId] = @RoleId,
						  	   				      [UpdatedDateTime] = @Currentdate,
						  	   				      [UpdatedByUserId] = @OperationsPerformedBy,
												  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						  	   		WHERE Id = @PayRollRoleConfigurationId
						      
						      END

							  SELECT Id FROM [dbo].[PayRollRoleConfiguration] WHERE Id = @PayRollRoleConfigurationId
                          
                          END
                    
                          ELSE
                  
                            RAISERROR (50008,11, 1)
                  
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