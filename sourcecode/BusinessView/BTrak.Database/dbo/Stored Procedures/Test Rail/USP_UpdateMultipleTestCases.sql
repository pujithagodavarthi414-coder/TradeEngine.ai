-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the MultipleTestCases
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the MultipleTestCases
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpdateMultipleTestCases]
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@Title ='Sprint12'
--,@SectionId = '5C3B1F5F-FC57-468C-9F26-E4A2D70B32C9'
--,@TestSuiteId='D8352F75-1152-4BCB-A896-7DFBD66FA803'
--,@TestCaseIdsXml = '<ArrayOfGuid>
--                          <guid>990F04C3-DEE6-4921-B0E6-1044FB5E39C2</guid>
--                          <guid>156BDE91-32C9-4583-AD13-28B6F032D1DF</guid>
--                          <guid>5D356CFB-BDCF-44A3-B27B-2AE116D6E498</guid>
--                          <guid>2AE9C998-29F3-4FC9-B215-470CCB602C8A</guid>
--                          <guid>748B510C-4B84-44A9-9258-496D7876B2D2</guid>
--                     </ArrayOfGuid>'
--,@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpdateMultipleTestCases]
(
	@TestSuiteId UNIQUEIDENTIFIER = NULL,
	@Title nvarchar(250) = NULL,
	@SectionId UNIQUEIDENTIFIER = NULL,
	@TemplateId UNIQUEIDENTIFIER = NULL,	
	@TypeId UNIQUEIDENTIFIER = NULL,
	@PriorityId UNIQUEIDENTIFIER = NULL,
	@Estimate NVARCHAR(250) = NULL,
	@References NVARCHAR(250) = NULL,
	@AutomationTypeId UNIQUEIDENTIFIER = NULL,
	@PreConditions NVARCHAR(500) = NULL,
	@Steps NVARCHAR(500) = NULL,
	@Mission NVARCHAR(1000) = NULL,
	@Goals NVARCHAR(1000) = NULL,
	@ExpectedResult NVARCHAR(300) = NULL,
	@IsArchived BIT = NULL,
	@IsSection BIT = NULL,
	@StatusId UNIQUEIDENTIFIER = NULL,
	@AssignToId UNIQUEIDENTIFIER = NULL,
	@TestCaseStepsXml XML = NULL,
	@TestCaseIdsXml XML= NULL,
    @TimeStamp TIMESTAMP = NULL,
    @FeatureId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @TestCase TABLE
		(
			Id INT IDENTITY(1,1),
			TestCaseId UNIQUEIDENTIFIER,
			StatusComment NVARCHAR(500),
			ResultantId UNIQUEIDENTIFIER
		)

		INSERT INTO @TestCase(TestCaseId)
				SELECT Id FROM TestCase WHERE Id IN (SELECT [Table].[Column].value('(text())[1]', 'varchar(100)')
		FROM @TestCaseIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column]))  AND InActiveDateTime IS NULL

		DECLARE @Temp INT = 1
		DECLARE @TestCaseId UNIQUEIDENTIFIER
		DECLARE @Version NVARCHAR(100)
		DECLARE @StatusComment NVARCHAR(500)
		DECLARE @Elapsed Time(7)

		WHILE(@Temp <= (SELECT COUNT(1) FROM @TestCase))
		BEGIN
			
			SELECT @TestCaseId = TestCaseId, @StatusComment = StatusComment,@Temp = @Temp + 1 
			FROM @TestCase WHERE Id = @Temp
				
			INSERT INTO @TestCase(ResultantId)
			EXEC USP_UpsertTestCase @TestCaseId,@Title,@SectionId,@TemplateId,@TypeId,@Estimate,@References,@Steps,@ExpectedResult,1,@Mission,@Goals,@PriorityId
				 ,@AutomationTypeId,@StatusComment,@StatusId,@AssignToId,@TestSuiteId,@PreConditions,@Version,@Elapsed,@TimeStamp,@FeatureId,@OperationsPerformedBy,@TestCaseStepsXml

		END

		SELECT ResultantId FROM @TestCase

		END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH
END
GO