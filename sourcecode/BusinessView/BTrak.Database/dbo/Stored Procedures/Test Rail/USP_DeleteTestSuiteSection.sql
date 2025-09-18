-------------------------------------------------------------------------------
-- Author      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Delete TestSuiteSection
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--DECLARE  @TimeStamp TIMESTAMP = (SELECT [timestamp] FROM TestSuiteSection WHERE Id = '5C3B1F5F-FC57-468C-9F26-E4A2D70B32C9' and AsAtInactiveDateTime is null and InActiveDateTime is null)
--EXEC [dbo].[USP_DeleteTestCase] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TestSuiteSectionId = '5C3B1F5F-FC57-468C-9F26-E4A2D70B32C9'

CREATE PROCEDURE [dbo].[USP_DeleteTestSuiteSection]
(
    @TestSuiteSectionId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	

	 DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestSuite TS INNER JOIN TestSuiteSection TSS ON TS.Id = TSS.TestSuiteId WHERE TSS.Id = @TestSuiteSectionId)
			
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
        
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	   IF (@HavePermission = '1')
        BEGIN

			DECLARE @SectionName NVARCHAR(250)
			DECLARE @TestSuiteId UNIQUEIDENTIFIER
			DECLARE @Description NVARCHAR(3000)
			DECLARE @ParentSectionId UNIQUEIDENTIFIER
			


							DECLARE @IsLatest BIT = (CASE WHEN @TestSuiteSectionId IS NULL 
					                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
				                                                           FROM [TestSuiteSection] WHERE Id =@TestSuiteSectionId AND InActiveDateTime IS NULL) = @TimeStamp
																	THEN 1 ELSE 0 END END)
				
				    IF(@IsLatest = 1)
				    BEGIN
					
						DECLARE @TestSuiteSectionIds TABLE
						(
							TestSuiteSectionId UNIQUEIDENTIFIER
						)
						INSERT INTO @TestSuiteSectionIds(TestSuiteSectionId)
						SELECT Id FROM Ufn_GetMultiSubSections(@TestSuiteSectionId)

						DECLARE @Currentdate DATETIME = GETDATE()
						
						DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteSectionCreatedOrUpdated' AND CompanyId = @CompanyId )

						EXEC [USP_InsertTestRailAuditHistory] @TestSuiteSectionId = @TestSuiteSectionId,
													          @TestSuiteSectionIsArchived = 1,
													          @ConfigurationId = @ConfigurationId,
									                          @OperationsPerformedBy = @OperationsPerformedBy
												
				         UPDATE TestSuiteSection SET UpdatedDateTime  = @Currentdate,
						                             UpdatedByUserId  = @OperationsPerformedBy,
													 InActiveDateTime = @Currentdate
													 FROM @TestSuiteSectionIds TSS
													 WHERE Id = TSS.TestSuiteSectionId AND InActiveDateTime IS NULL
					 
				    END
				    ELSE
				    	RAISERROR (50008,11, 1)

				      SELECT Id FROM [dbo].[TestSuiteSection] WHERE Id = @TestSuiteSectionId

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