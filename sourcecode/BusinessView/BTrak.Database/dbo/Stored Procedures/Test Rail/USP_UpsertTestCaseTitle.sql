---------------------------------------------------------------------------------
---- Author      Mahesh Musuku
---- Created      '2019-04-24 00:00:00.000'
---- Purpose      Save or Update the TestCase Tittle
---- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
----EXEC [dbo].[USP_UpsertTestCaseTitle] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
----@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d'
---------------------------------------------------------------------------------
--CREATE PROCEDURE [dbo].[USP_UpsertTestCaseTitle]
--(
--    @TestCaseId UNIQUEIDENTIFIER = NULL,
--    @FeatureId UNIQUEIDENTIFIER = NULL,
--	@TestSuiteId  UNIQUEIDENTIFIER = NULL,
--	@Title  NVARCHAR(250) = NULL,
--    @TimeStamp TIMESTAMP = NULL,
--	@SectionId UNIQUEIDENTIFIER = NULL,
--    @OperationsPerformedBy UNIQUEIDENTIFIER
--)
--AS
--BEGIN

--	SET NOCOUNT ON
--	BEGIN TRY	
--	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED		

--	       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

--           IF(@HavePermission = '1')
--           BEGIN
--			DECLARE @TemplateId UNIQUEIDENTIFIER = NULL 
--			DECLARE @TypeId UNIQUEIDENTIFIER = NULL 
--			DECLARE @Estimate  NVARCHAR (250)  = NULL 
--			DECLARE @References NVARCHAR (250)  = NULL 
--			DECLARE @Steps  NVARCHAR (MAX) = NULL 
--			DECLARE @ExpectedResult  NVARCHAR (2000)  = NULL 
--			DECLARE @Mission NVARCHAR (2000) = NULL 
--			DECLARE @Goals  NVARCHAR (2000) = NULL 
--			DECLARE @PriorityId UNIQUEIDENTIFIER = NULL 
--			DECLARE @AutomationTypeId UNIQUEIDENTIFIER = NULL 
--			DECLARE @StatusId  UNIQUEIDENTIFIER = NULL 
--			DECLARE @StatusComment NVARCHAR (500)  = NULL 
--			DECLARE @AssignToId UNIQUEIDENTIFIER = NULL 
--			DECLARE @PreConditions NVARCHAR (500)  = NULL 
--			DECLARE @Version NVARCHAR (100)  =  NULL 
--			DECLARE @Elapsed TIME (7) = NULL 
--			DECLARE @SuiteId  UNIQUEIDENTIFIER = NULL
--			DECLARE @TestCaseTitle NVARCHAR(250) = NULL
--			DECLARE @TestSectionId UNIQUEIDENTIFIER = NULL

--			IF(@TestCaseId IS NOT NULL)
--			BEGIN
--		    SELECT @Title = TC.Title
--				   ,@TestSectionId = TC.SectionId					
--				   ,@TemplateId = TC.TemplateId					  
--				   ,@TypeId = TC.TypeId
--				   ,@Estimate = TC.Estimate
--				   ,@References = TC.[References]
--				   ,@Steps = TC.Steps
--				   ,@ExpectedResult = TC.ExpectedResult
--				   ,@Mission = TC.Mission
--				   ,@Goals = TC.Goals
--				   ,@PriorityId = TC.PriorityId
--				   ,@AutomationTypeId = TC.AutomationTypeId
--				   ,@SuiteId = TC.TestSuiteId
--				   ,@PreConditions = TC.PreCondition
--			  FROM TestCase TC WHERE OriginalId = @TestCaseId AND TC.InActiveDateTime IS NULL	
			  
--			  SET @TestSuiteId = ISNULL(@TestSuiteId,@SuiteId)

--			  SET @SectionId = ISNULL(@SectionId,@TestSectionId)

--			  EXEC USP_UpsertTestCase @TestCaseId,@Title,@SectionId,@TemplateId,@TypeId,@Estimate,@References,@Steps,@ExpectedResult,1,@Mission,@Goals,@PriorityId
--								 ,@AutomationTypeId,@StatusComment,@StatusId,@AssignToId,@TestSuiteId,@PreConditions,@Version,@Elapsed,@TimeStamp,@FeatureId,@OperationsPerformedBy
							 
--			END
--			ELSE
--			BEGIN			 

--			   SET @AutomationTypeId = (SELECT Id FROM TestCaseAutomationType WHERE IsDefault = 1)

--			   SET @PriorityId  = (SELECT Id FROM TestCasePriority WHERE IsDefault = 1)

--			   SET @TypeId = (SELECT Id FROM TestCaseType  WHERE IsDefault = 1)

--			   SET @StatusId = (SELECT Id FROM TestCaseStatus WHERE IsUntested =1)

--			  EXEC USP_UpsertTestCase @TestCaseId,@Title,@SectionId,@TemplateId,@TypeId,@Estimate,@References,@Steps,@ExpectedResult,0,@Mission,@Goals,@PriorityId
--								 ,@AutomationTypeId,@StatusComment,@StatusId,@AssignToId,@TestSuiteId,@PreConditions,@Version,@Elapsed,@TimeStamp,@FeatureId,@OperationsPerformedBy
--			END
--			 END
--	       ELSE
--          BEGIN
          
--               RAISERROR (@HavePermission,10, 1)
          
--          END	
--	END TRY
--	BEGIN CATCH

--		EXEC USP_GetErrorInformation

--	END CATCH
--END
--GO
