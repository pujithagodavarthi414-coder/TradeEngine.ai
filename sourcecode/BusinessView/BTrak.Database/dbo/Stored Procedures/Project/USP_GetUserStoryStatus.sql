-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-08 00:00:00.000'
-- Purpose      To Get the WorkFlows By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoryStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetUserStoryStatus]
(
  @TaskStatusId  UNIQUEIDENTIFIER = NULL,
  @TaskStatusName  NVARCHAR(250) = NULL,
  @UserStoryStatusId  UNIQUEIDENTIFIER = NULL,
  @StatusName  NVARCHAR(250) = NULL,
  @StatusColor NVARCHAR(30) = NULL,
  @IsArchived BIT = NULL,
  @ArchivedDateTime DATETIME = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	  SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	    IF (@UserStoryStatusId = '00000000-0000-0000-0000-000000000000') SET @UserStoryStatusId = NULL
	    IF(@StatusName = '') SET @StatusName = NULL
        IF(@StatusColor = '') SET @StatusColor = NULL
		IF(@IsArchived IS NULL) SET @IsArchived = 0
	    SELECT USS.Id AS UserStoryStatusId,
		       USS.[Status] AS UserStoryStatusName,
			   USS.StatusHexValue AS UserStoryStatusColor,
			   USS.TaskStatusId,
			   TS.TaskStatusName,
			   USS.IsArchived,
			   USS.ArchivedDateTime,
			   USS.CompanyId,
			   USS.CreatedByUserId,
			   USS.CreatedDateTime,
			   USS.UpdatedByUserId,
			   USS.UpdatedDateTime,
			   USS.[TimeStamp],	
			   USS.LookUpKey,
			   CASE WHEN USS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
			   TotalCount = COUNT(1) OVER()
        FROM [dbo].[UserStoryStatus] USS WITH (NOLOCK)
		JOIN [dbo].[TaskStatus] TS ON USS.TaskStatusId = TS.Id AND (USS.CompanyId = @CompanyId)
	    WHERE ((@UserStoryStatusId IS NULL OR USS.Id = @UserStoryStatusId))
		      AND (@StatusName IS NULL OR USS.[Status] = @StatusName)
		      AND (@StatusColor IS NULL OR USS.StatusHexValue = @StatusColor)
			  AND ((@IsArchived = 0 AND InActiveDateTime IS NULL) OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
			  AND (@TaskStatusId IS NULL OR USS.TaskStatusId = @TaskStatusId)
			  AND (@TaskStatusName IS NULL OR TS.TaskStatusName = @TaskStatusName)
		ORDER BY TS.[Order]
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
GO