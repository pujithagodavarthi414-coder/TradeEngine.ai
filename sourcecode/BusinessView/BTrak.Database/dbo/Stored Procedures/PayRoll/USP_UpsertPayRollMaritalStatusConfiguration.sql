---------------------------------------------------------------------------------------------
--EXEC USP_UpsertPayRollMaritalStatusConfiguration @PayRollMaritalStatusConfigurationId='251C6ED1-3988-42EE-B48C-4B9F7A241F21', 
--@OperationsPerformedBy= '127133F1-4427-4149-9DD6-B02E0E036971',
--@PayRollTemplateId = 'B1286B23-1362-4C47-BC94-0549099E9393',@MaritalStatusId = '1210DB37-93F7-4347-9240-E978A270B707',
--@TimeStamp = 0x00000000000024A0
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayRollMaritalStatusConfiguration]
(
   @PayRollMaritalStatusConfigurationId UNIQUEIDENTIFIER = NULL,
   @PayRollTemplateId UNIQUEIDENTIFIER = NULL,  
   @MaritalStatusId UNIQUEIDENTIFIER = NULL,
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
                  
                  IF(@MaritalStatusId = '00000000-0000-0000-0000-000000000000') SET @MaritalStatusId = NULL 

				  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				  DECLARE @Currentdate DATETIME = GETDATE()

				  IF(@IsArchived = 1 AND @PayRollMaritalStatusConfigurationId IS NOT NULL)
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
                  IF(@MaritalStatusId IS NULL)
                  BEGIN
             
                  RAISERROR(50011,16, 2, 'MaritalStatus')
          
                  END
                          
                  DECLARE @PayRollMaritalStatusConfigurationIdCount INT = (SELECT COUNT(1) FROM PayRollMaritalStatusConfiguration  WHERE Id = @PayRollMaritalStatusConfigurationId)

				  DECLARE @PayRollMaritalStatusConfigurationDuplicateCount INT = (SELECT COUNT(1) FROM PayRollMaritalStatusConfiguration WHERE [PayRollTemplateId] = @PayRollTemplateId AND [MaritalStatusId] = @MaritalStatusId AND CompanyId = @CompanyId 
																		AND (@PayRollMaritalStatusConfigurationId IS NULL OR @PayRollMaritalStatusConfigurationId <> Id))
                                      
                  IF(@PayRollMaritalStatusConfigurationIdCount = 0 AND @PayRollMaritalStatusConfigurationId IS NOT NULL)
                  BEGIN
              
                    RAISERROR(50002,16, 2,'PayRollMaritalStatusConfiguration')
          
                  END
				  IF (@PayRollMaritalStatusConfigurationDuplicateCount > 0)
		          BEGIN
		          
		          	RAISERROR(50001,11,1,'PayRollMaritalStatusConfiguration')
		          
		          END
                  ELSE
                  DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                  IF (@HavePermission = '1')
                  BEGIN
       
                          DECLARE @IsLatest BIT = (CASE WHEN @PayRollMaritalStatusConfigurationId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM PayRollMaritalStatusConfiguration WHERE Id = @PayRollMaritalStatusConfigurationId) = @TimeStamp THEN 1 ELSE 0 END END)
                    
                          IF(@IsLatest = 1)
                          BEGIN
                  
                              IF(@PayRollMaritalStatusConfigurationId IS NULL)
						      BEGIN
						      
						       SET @PayRollMaritalStatusConfigurationId = NEWID()
						      
                                      INSERT INTO [dbo].[PayRollMaritalStatusConfiguration](
                                                  [Id],
                                                  [PayRollTemplateId],
                                                  [MaritalStatusId],
                                                  [CreatedDateTime],
                                                  [CreatedByUserId],
												  [CompanyId],
												  [InActiveDateTime]
                                                  )
                                           SELECT @PayRollMaritalStatusConfigurationId,
                                                  @PayRollTemplateId,
                                                  @MaritalStatusId,
                                                  @Currentdate,
                                                  @OperationsPerformedBy,
												  @CompanyId,
												  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
                                 
						      END
						      ELSE
						      BEGIN
						      
						      UPDATE [dbo].[PayRollMaritalStatusConfiguration]
                                           SET    [PayRollTemplateId] = @PayRollTemplateId,
                                                  [MaritalStatusId] = @MaritalStatusId,
						  	   				      [UpdatedDateTime] = @Currentdate,
						  	   				      [UpdatedByUserId] = @OperationsPerformedBy,
												  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						  	   		WHERE Id = @PayRollMaritalStatusConfigurationId
						      
						      END

							   SELECT Id FROM [dbo].[PayRollMaritalStatusConfiguration] WHERE Id = @PayRollMaritalStatusConfigurationId
                          
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
