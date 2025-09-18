-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-28 00:00:00.000'
-- Purpose      To Get UserStory UniqueName
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- SELECT [dbo].[Ufn_GetUserStoryUniqueName](N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',N'4afeb444-e826-4f95-ac41-2175e36a0c16')
-------------------------------------------------------------------------------
CREATE FUNCTION Ufn_GetUserStoryUniqueName
(
   @UserStoryTypeId UNIQUEIDENTIFIER,
   @CompanyId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(250)
AS
BEGIN
  DECLARE @UniqueName NVARCHAR(100) = (SELECT ShortName FROM UserStoryType WHERE Id = @UserStoryTypeId AND CompanyId = @CompanyId)
  DECLARE @MaxNumber INT = (SELECT MAX(CAST(SUBSTRING(UserStoryUniqueName,LEN(@Uniquename) + 2,LEN(UserStoryUniqueName)) AS INT)) 
                            FROM UserStory WHERE UserStoryUniqueName IS NOT NULL AND UserStoryTypeId = @UserStoryTypeId)
  SET @UniqueName = @UniqueName + '-' +  CAST(ISNULL(@MaxNumber,0) + 1 AS NVARCHAR(250))
RETURN @UniqueName
END
GO