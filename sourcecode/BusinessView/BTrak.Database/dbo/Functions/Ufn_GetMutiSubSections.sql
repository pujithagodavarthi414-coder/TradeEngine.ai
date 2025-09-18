-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-28 00:00:00.000'
-- Purpose      To Get Sections And Subsections upto n levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--SELECT * FROM [dbo].[Ufn_GetMutiSubSections]('4A4DED0A-581E-4295-BC57-F578E277BB29')

CREATE FUNCTION Ufn_GetMutiSubSections
(
    @SectionId UNIQUEIDENTIFIER
)
  RETURNS @Temp table
  (
  RowNo INT IDENTITY(1,1),
  SectionId UNIQUEIDENTIFIER,
  ParentSectionId  UNIQUEIDENTIFIER,
  SectionName NVARCHAR(250),
  OriginalName  NVARCHAR(250),
  CreatedDateTime DATETIME,
  [Description] NVARCHAR(MAX),
  Id UNIQUEIDENTIFIER,
  TestSuiteId UNIQUEIDENTIFIER
  )
  AS
  BEGIN
  
  DECLARE @Temp1 TABLE
  (
  RowNo INT IDENTITY(1,1),
  SectionId UNIQUEIDENTIFIER
  )

             INSERT INTO @Temp(SectionId,SectionName,OriginalName,CreatedDateTime,[Description],TestSuiteId)
		     SELECT Id,SectionName,SectionName,CreatedDateTime,[Description],TestSuiteId FROM TestSuiteSection WHERE Id = @SectionId  AND InActiveDateTime IS NULL

		     INSERT INTO @Temp1(SectionId)
		     SELECT Id FROM TestSuiteSection WHERE ParentSectionId = @SectionId  AND InActiveDateTime IS NULL ORDER BY CreatedDateTime

		     DECLARE @Count INT = 1 

		     DECLARE @PaerentSectionId UNIQUEIDENTIFIER


		     WHILE(@Count<=(SELECT MAX(RowNo) FROM @Temp1))
			 BEGIN

			 SET @PaerentSectionId = (SELECT SectionId FROM @Temp1 WHERE RowNo = @Count)

			 INSERT INTO @Temp(SectionId,ParentSectionId,SectionName,OriginalName,CreatedDateTime,[Description],TestSuiteId)
		     SELECT Id,ParentSectionId,' '+SectionName,SectionName,CreatedDateTime,[Description],TestSuiteId FROM TestSuiteSection WHERE Id = @PaerentSectionId AND InActiveDateTime IS NULL ORDER BY CreatedDateTime

			 INSERT INTO @Temp(SectionId,ParentSectionId,SectionName,OriginalName,CreatedDateTime,[Description],TestSuiteId)
		     SELECT Id,ParentSectionId,'  '+SectionName,SectionName,CreatedDateTime,[Description],TestSuiteId FROM TestSuiteSection WHERE ParentSectionId = @PaerentSectionId  AND InActiveDateTime IS NULL ORDER BY CreatedDateTime

			 SET @Count = @Count + 1

			 END

  RETURN
END
GO