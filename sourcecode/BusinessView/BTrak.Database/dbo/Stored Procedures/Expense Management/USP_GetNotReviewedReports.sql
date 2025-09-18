--CREATE PROC [dbo].[USP_GetNotReviewedReports] 
--(
--    @Page AS INT,
--    @Pagesize AS INT,
--	@UserId uniqueidentifier
--)
--AS
--BEGIN


--DECLARE @StatusDetails TABLE
--(
--	StatusSetToUserId uniqueidentifier,
--	[Name] varchar(500),
--	ReportingOptionId uniqueidentifier,
--	MasterValue varchar(100),
--	ReportId uniqueidentifier,
--	ReportName varchar(800),
--	DisplayName VARCHAR(800),
--	ShowPopup VARCHAR(10),
--	ProfileImage VARCHAR(800),
--	TotalNotReviewedReports INT
--)

--INSERT INTO @StatusDetails(StatusSetToUserId,[Name],ReportingOptionId,MasterValue,ReportId,ReportName,DisplayName,ProfileImage)
-- SELECT StatusSetToUserId,U.[FirstName] + ' ' + U.SurName,SRCD.StatusReportingOptionId,MasterValue,SRC1.Id,SRC1.ReportText, SRC1.ReportText+' '+
--   STUFF((SELECT DISTINCT ', ' +  SRO.[Option]
--          FROM  StatusReportingConfiguration SRC JOIN StatusReportingConfigurationDetails SRCD ON SRC.Id = SRCD.StatusReportingConfigurationId 
--                JOIN StatusReportingOption SRO ON SRO.Id = SRCD.StatusReportingOptionId WHERE SRCD.StatusReportingStatusId =  '54C11970-7D19-4202-9FD5-DF72ED28FC44'
--          and SRC1.id = SRC.id
--         FOR XML PATH('')), 1, 2, ''),U.ProfileImage

--FROM  StatusReportingConfiguration SRC1 JOIN StatusReportingConfigurationDetails SRCD ON SRC1.Id = SRCD.StatusReportingConfigurationId 
--             JOIN MasterTable MT ON MT.Id = SRCD.StatusReportingOptionId 
--			 JOIN [User] U WITH (NOLOCK) ON U.id = SRC1.StatusSetToUserId
--			 WHERE SRCD.StatusReportingStatusId =  '54C11970-7D19-4202-9FD5-DF72ED28FC44' 

--			 UPDATE @StatusDetails SET ShowPopup = CASE WHEN MasterValue = DATENAME(WEEKDAY,GETUTCDATE()) THEN 'Yes' ELSE 'No' END

--UPDATE @StatusDetails SET ShowPopup = 'Yes' WHERE MasterValue = 'Every Working Day' 
--      AND DATENAME(WEEKDAY,GETUTCDATE()) <> 'Sunday' AND CONVERT(DATE,GETUTCDATE()) NOT IN (SELECT [Date] FROM Holiday)

--DECLARE @date DATETIME, @lastDate DATETIME, @lastWeekDay DATETIME

--SET @date=GETUTCDATE()
--SET @lastDate = (SELECT DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @date) + 1, 0)))

--DECLARE @dayOfWeek INT = (SELECT DATEDIFF(dd, 0, @lastDate) % 7)

--SET @lastWeekDay = (SELECT CASE WHEN @dayOfWeek = 6 THEN DATEADD(dd, -2, @lastDate) ELSE @lastDate END)

--UPDATE @StatusDetails SET ShowPopup = CASE WHEN CONVERT(DATE,GETUTCDATE()) = @lastWeekDay THEN 'Yes' ELSE 'No' END WHERE MasterValue = 'Last Working Day Of The Month' 

--DECLARE @StatusDetails1 TABLE
--(
--	StatusSetToUserId uniqueidentifier,
--	[Name] varchar(500),
--	ReportId uniqueidentifier,
--	DisplayName VARCHAR(800),
--	ProfileImage VARCHAR(800)
--)


--INSERT INTO @StatusDetails1(StatusSetToUserId,[Name],ReportId,DisplayName,ProfileImage)
--SELECT StatusSetToUserId,[Name],ReportId,DisplayName,ProfileImage  FROM @StatusDetails WHERE ShowPopup = 'Yes' 
--AND ReportId IN (SELECT StatusReportingConfigurationId FROM StatusReporting WHERE CONVERT(DATE,CreatedDateTime) = CONVERT(Date,GETUTCDATE()) AND IsSubmitted =1 AND  IsReviewed = 0)
--GROUP BY StatusSetToUserId,[Name],ReportId,DisplayName,ProfileImage
--UNION 
--SELECT StatusSetToUserId,U.[FirstName] + ' ' + U.SurName,SRC1.Id, SRC1.ReportText+' '+
--   STUFF((SELECT DISTINCT ', ' +  SRO.[Option]
--          FROM  StatusReportingConfiguration SRC JOIN StatusReportingConfigurationDetails SRCD ON SRC.Id = SRCD.StatusReportingConfigurationId 
--             JOIN StatusReportingOption SRO ON SRO.Id = SRCD.StatusReportingOptionId WHERE SRCD.StatusReportingStatusId =  '54C11970-7D19-4202-9FD5-DF72ED28FC44'
--          and SRC1.id = SRC.id
--         FOR XML PATH('')), 1, 2, ''),U.ProfileImage
--FROM  StatusReportingConfiguration SRC1 JOIN StatusReportingConfigurationDetails SRCD ON SRC1.Id = SRCD.StatusReportingConfigurationId 
--             JOIN StatusReportingOption SRO ON SRO.Id = SRCD.StatusReportingOptionId 
--			 JOIN [User] U ON U.id = SRC1.StatusSetToUserId
--			 JOIN [StatusReporting] SR ON SR.StatusReportingConfigurationId = SRC1.Id
--			 WHERE SRCD.StatusReportingStatusId =  '54C11970-7D19-4202-9FD5-DF72ED28FC44' AND IsSubmitted =1 AND IsReviewed = 0
----GROUP BY StatusSetToUserId,U.[Name] + ' ' + U.SurName,SRC1.Id, SRC1.ReportText, MT.MasterValue,U.ProfileImage

--SELECT *,TotalNotReviewedReports = COUNT(*) OVER() FROM @StatusDetails1

--END

----select * from [User]
----exec [dbo].[USP_GetNotReviewedReports]  1,10,'127133F1-4427-4149-9DD6-B02E0E036972'

----select * from StatusReportingConfiguration

----select * from StatusReportingConfigurationDetails

----select * from [File]

----select * from StatusReporting

----select * from StatusReportingAttachment

---- select * from StatusReportingOption