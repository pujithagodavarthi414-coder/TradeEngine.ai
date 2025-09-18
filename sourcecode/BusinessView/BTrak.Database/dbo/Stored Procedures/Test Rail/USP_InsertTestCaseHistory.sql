-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-08-27 00:00:00.000'
-- Purpose      To save the testcase history
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_InsertTestCaseHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FieldName='Status',@NewValue='Test'

CREATE PROCEDURE [dbo].[USP_InsertTestCaseHistory]
(
  @TestCaseId UNIQUEIDENTIFIER = NULL,
  @StepId UNIQUEIDENTIFIER = NULL,
  @TestRunId UNIQUEIDENTIFIER = NULL,
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @ConfigurationId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(250) = NULL,
  @NewValue NVARCHAR(250) = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @FilePath NVARCHAR(1000) = NULL,
  @Description NVARCHAR(800) = NULL,
  @IsFromUpload BIT = NULL,
  @ReferenceId UNIQUEIDENTIFIER = NULL,
  @CreatedDateTime DATETIME  = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        DECLARE @TestCaseHistoryId UNIQUEIDENTIFIER = NEWID()
        
        IF(@FieldName = 'Status' AND @OldValue IS NULL)
        BEGIN
       
	    SET @OldValue =  (SELECT NewValue FROM(SELECT Rowno = ROW_NUMBER() OVER (ORDER BY CreatedDateTime DESC) ,NewValue FROM TestCaseHistory WHERE FieldName = 'Status' AND ((TestCaseId = @TestCaseId AND TestRunId = @TestRunId) OR (StepId = @StepId  AND TestRunId = @TestRunId)))T WHERE T.Rowno = 1)
       
	   END
        INSERT INTO [dbo].[TestCaseHistory](
                    [Id],
                    [TestCaseId],
                    [TestRunId],
					[UserStoryId],
                    [StepId],
                    [OldValue],
                    [NewValue],
                    [FieldName],
					[FilePath],
					[ReferenceId],
					[ConfigurationId],
                    [Description],
                    CreatedDateTime,
                    CreatedByUserId)
             SELECT @TestCaseHistoryId,
                    @TestCaseId,
                    @TestRunId,
					@UserStoryId,
                    @StepId,
                    @OldValue,
                    @NewValue,
                    @FieldName,
					@FilePath,
					@ReferenceId,
					@ConfigurationId,
                    @Description,
                    CASE WHEN @IsFromUpload = 1 THEN @CreatedDateTime ELSE SYSDATETIMEOFFSET() END,
                    @OperationsPerformedBy

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO




