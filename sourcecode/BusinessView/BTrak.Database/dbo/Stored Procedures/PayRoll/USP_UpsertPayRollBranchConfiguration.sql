---------------------------------------------------------------------------------------------
--EXEC USP_UpsertPayRollBranchConfiguration @PayRollBranchConfigurationId='251C6ED1-3988-42EE-B48C-4B9F7A241F21', 
--@OperationsPerformedBy= '127133F1-4427-4149-9DD6-B02E0E036971',
--@PayRollTemplateId = 'B1286B23-1362-4C47-BC94-0549099E9393',@BranchId = '1210DB37-93F7-4347-9240-E978A270B707',
--@TimeStamp = 0x00000000000024A0
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayRollBranchConfiguration]
(
   @PayRollBranchConfigurationId UNIQUEIDENTIFIER = NULL,
   @PayRollTemplateId UNIQUEIDENTIFIER = NULL,  
   @BranchId UNIQUEIDENTIFIER = NULL,
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
                  
                  IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL 
				  
				  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				  DECLARE @Currentdate DATETIME = GETDATE()

				   IF(@IsArchived = 1 AND @PayRollBranchConfigurationId IS NOT NULL)
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
                  IF(@BranchId IS NULL)
                  BEGIN
             
                  RAISERROR(50011,16, 2, 'Branch')
          
                  END
                          
                  DECLARE @PayRollBranchConfigurationIdCount INT = (SELECT COUNT(1) FROM PayRollBranchConfiguration  WHERE Id = @PayRollBranchConfigurationId)

				  DECLARE @PayRollBranchConfigurationDuplicateCount INT = (SELECT COUNT(1) FROM PayRollBranchConfiguration WHERE [PayRollTemplateId] = @PayRollTemplateId AND [BranchId] = @BranchId AND CompanyId = @CompanyId 
																		AND (@PayRollBranchConfigurationId IS NULL OR @PayRollBranchConfigurationId <> Id))
                                      
                  IF(@PayRollBranchConfigurationIdCount = 0 AND @PayRollBranchConfigurationId IS NOT NULL)
                  BEGIN
              
                    RAISERROR(50002,16, 2,'PayRollBranchConfiguration')
          
                  END
				  IF (@PayRollBranchConfigurationDuplicateCount > 0)
		          BEGIN
		          
		          	RAISERROR(50001,11,1,'PayRollBranchConfiguration')
		          
		          END
                  ELSE
                  DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                  IF (@HavePermission = '1')
                  BEGIN
       
                          DECLARE @IsLatest BIT = (CASE WHEN @PayRollBranchConfigurationId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM PayRollBranchConfiguration WHERE Id = @PayRollBranchConfigurationId) = @TimeStamp THEN 1 ELSE 0 END END)
                    
                          IF(@IsLatest = 1)
                          BEGIN
                        
                              IF(@PayRollBranchConfigurationId IS NULL)
						      BEGIN
						      
						       SET @PayRollBranchConfigurationId = NEWID()
						      
                                      INSERT INTO [dbo].[PayRollBranchConfiguration](
                                                  [Id],
                                                  [PayRollTemplateId],
                                                  [BranchId],
                                                  [CreatedDateTime],
                                                  [CreatedByUserId],
												  [CompanyId],
												  [InActiveDateTime]
                                                  )
                                           SELECT @PayRollBranchConfigurationId,
                                                  @PayRollTemplateId,
                                                  @BranchId,
                                                  @Currentdate,
                                                  @OperationsPerformedBy,
												  @CompanyId,
												  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
                                 
						      END
						      ELSE
						      BEGIN
						      
						      UPDATE [dbo].[PayRollBranchConfiguration]
                                           SET    [PayRollTemplateId] = @PayRollTemplateId,
                                                  [BranchId] = @BranchId,
						  	   				      [UpdatedDateTime] = @Currentdate,
						  	   				      [UpdatedByUserId] = @OperationsPerformedBy,
												  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						  	   		WHERE Id = @PayRollBranchConfigurationId
						      
						      END

							  SELECT Id FROM [dbo].[PayRollBranchConfiguration] WHERE Id = @PayRollBranchConfigurationId 
                          
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