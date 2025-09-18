----select * from Ufn_GetCaseDetailsById('12BFF6C7-FEAE-47D3-AE83-7D1C79BFF89B','F9A979A2-5BDF-4C97-BAA7-B32EADFDD2DA')

--CREATE FUNCTION Ufn_GetCaseDetailsById
--(
--    @TestCaseId UNIQUEIDENTIFIER  NULL,
--    @TestRunId UNIQUEIDENTIFIER
--)
--RETURNS @CaseDetails TABLE
--(
--    TestCaseId UNIQUEIDENTIFIER,
--    StatusId UNIQUEIDENTIFIER,
--    CreatedDateTime DATETIME,
--    CreatedByUserId UNIQUEIDENTIFIER
--)
--AS
--BEGIN
    
--    DECLARE @StatusId UNIQUEIDENTIFIER = NULL,@Version  INT 
--     SELECT @Version= VersionNumber FROM TestRunSelectedCase WHERE TestRunId = @TestRunId AND TestCaseId = @TestCaseId 
--     DECLARE @Count INT = 1
--     WHILE(@Count<=@Version)
--     BEGIN
    
--    INSERT INTO @CaseDetails(TestCaseId,StatusId,CreatedDateTime,CreatedByUserId)
--     SELECT TestCaseId,StatusId,CreatedDateTime,CreatedByUserId FROM TestRunSelectedCase 
--     WHERE TestCaseId = @TestCaseId AND TestRunId = @TestRunId AND VersionNumber = @Count AND StatusId <> @StatusId
--     GROUP BY TestCaseId,StatusId,CreatedDateTime,CreatedByUserId
    
--     SET @StatusId = (SELECT StatusId FROM TestRunSelectedCase WHERE VersionNumber = @Count AND TestCaseId = @TestCaseId AND TestRunId = @TestRunId )
    
    
--    SET @Count= @Count + 1
--     END
--    RETURN
--END




