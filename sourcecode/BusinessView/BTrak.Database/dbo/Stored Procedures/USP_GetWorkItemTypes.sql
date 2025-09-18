-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-24 00:00:00.000'
-- Purpose      To Get the work items
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetWorkItemTypes] @CompanyName= 'Snovasys Software Solutions',@WorkItemTypeName='Bug'

CREATE PROCEDURE [dbo].[USP_GetWorkItemTypes]
(
  @CompanyName NVARCHAR(250) = NULL,
  @WorkItemTypeName NVARCHAR(250) = NULL
)
AS
BEGIN
     SET NOCOUNT ON
	 BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		   
        SELECT UST.Id UserStoryTypeId,
		       UST.UserStoryTypeName,
			   UST.ShortName UserStoryTypeShortName
		FROM UserStoryType UST INNER JOIN Company C ON C.Id = UST.CompanyId AND UST.InActiveDateTime IS NULL
		 WHERE C.CompanyName = @CompanyName AND UST.UserStoryTypeName = @WorkItemTypeName
		
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO
