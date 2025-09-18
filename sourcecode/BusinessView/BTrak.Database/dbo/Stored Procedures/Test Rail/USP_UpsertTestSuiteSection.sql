-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or Update TestSuiteSection
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or Update TestSuiteSection
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertTestSuiteSection] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @SectionName='Mobile Application',@Description='Test rail',@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d',@TestSuiteId = '184A1345-07B4-40AF-BE30-B262393F34D9'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTestSuiteSection]
(
    @TestSuiteSectionId UNIQUEIDENTIFIER = NULL,    
    @SectionName NVARCHAR(250) = NULL,
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
    @Description NVARCHAR(3000) = NULL, 
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @ParentSectionId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        
        IF(@TestSuiteId = '00000000-0000-0000-0000-000000000000') SET @TestSuiteId = NULL
       
	   DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestSuite WHERE Id = @TestSuiteId  AND InActiveDateTime IS NULL)
​
	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
	   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
​
       IF(@HavePermission = '1')
       BEGIN
	    IF(@SectionName = '') SET @SectionName = NULL
        
		IF(@TestSuiteId IS NULL)
        BEGIN
            
            RAISERROR(50011,16, 2, 'TestSuite')
        END
        ELSE IF(@SectionName IS NULL)
        BEGIN
            
            RAISERROR(50011,16, 2, 'SectionName')
        END
        ELSE
        BEGIN
            
			DECLARE @TestSuiteSectionIdCount INT = (SELECT COUNT(1) FROM TestSuiteSection WHERE Id = @TestSuiteSectionId)
           
		   DECLARE @SectionNamesCount INT = (SELECT COUNT(1) FROM [dbo].[TestSuiteSection] WHERE [SectionName] = @SectionName AND TestSuiteId = @TestSuiteId AND ((@ParentSectionId IS NULL AND ParentSectionId IS NULL) OR ParentSectionId = @ParentSectionId) AND (Id <> @TestSuiteSectionId OR @TestSuiteSectionId IS NULL) AND  InactiveDateTime IS NULL)
                  
            IF(@TestSuiteSectionIdCount = 0 AND @TestSuiteSectionId IS NOT NULL)
            BEGIN
            
			  RAISERROR(50002,16, 1,'TestSuiteSection')
            
			END
            
            ELSE
            BEGIN
                    
                    DECLARE @IsLatest BIT = (CASE WHEN @TestSuiteSectionId IS NULL 
                                                  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                           FROM [TestSuiteSection] WHERE Id =@TestSuiteSectionId  ) = @TimeStamp
                                                                    THEN 1 ELSE 0 END END)
                
                    IF(@IsLatest = 1)
                    BEGIN
                         
                        DECLARE @FieldName NVARCHAR(100)
                        
                        --IF(@TestSuiteSectionId IS NULL)
                        --SET @FieldName = 'TestSuiteSectionCreated'
                        --ELSE
                        --SET @FieldName = 'TestSuiteSectionUpdated'

					   DECLARE @Currentdate DATETIME = GETDATE()

					   DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteSectionCreatedOrUpdated' AND CompanyId = @CompanyId )
                       
                        IF(@TestSuiteSectionId IS NULL)
						BEGIN

						SET @TestSuiteSectionId = NEWID()

						 INSERT INTO [dbo].[TestSuiteSection](
                                     [Id],
                                     [SectionName],
                                     [TestSuiteId],
                                     [Description],
                                     [InActiveDateTime],
                                     [ParentSectionId],
                                     [CreatedDateTime],
                                     [CreatedByUserId]
									 )
                              SELECT @TestSuiteSectionId,
                                     @SectionName,
                                     @TestSuiteId,
                                     @Description,
                                     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                     @ParentSectionId,
                                     @Currentdate,
                                     @OperationsPerformedBy

							SET @FieldName = 'TestSuiteSectionCreated'

							EXEC [dbo].[USP_InsertTestCaseHistory] @OperationsPerformedBy=@OperationsPerformedBy,@FieldName= @FieldName,@NewValue = @SectionName ,@ConfigurationId = @ConfigurationId,@ReferenceId = @TestSuiteSectionId,@Description = 'TestSuiteSectionAdded'

							 END
							 ELSE
							 BEGIN

							 EXEC [USP_InsertTestRailAuditHistory] @TestSuiteSectionId = @TestSuiteSectionId,    
																   @TestSuiteSectionName = @SectionName,
																   @TestSuiteSectionTestSuiteId = @TestSuiteId,
																   @TestSuiteSectionDescription = @Description, 
																   @TestSuiteSectionIsArchived = @IsArchived,
																   @ParentTestSuiteSectionId = @ParentSectionId,
																   @ConfigurationId = @ConfigurationId, 
																   @OperationsPerformedBy = @OperationsPerformedBy

							  UPDATE [dbo].[TestSuiteSection]
                                SET  [SectionName] = @SectionName,
                                     [TestSuiteId] = @TestSuiteId,
                                     [Description] = @Description,
                                     [InActiveDateTime] =CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                     [ParentSectionId] = @ParentSectionId,
									 [UpdatedDateTime] = @Currentdate,
									 [UpdatedByUserId] = @OperationsPerformedBy
									 WHERE Id = @TestSuiteSectionId

							 END
​
                      SELECT Id FROM [dbo].[TestSuiteSection] WHERE Id = @TestSuiteSectionId
                     
					-- END
     --                ELSE
                     
					-- RAISERROR('You reached maximum level of Testsuite sections',11,1)
                    
					END
                    ELSE
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
​
    END CATCH
END
GO