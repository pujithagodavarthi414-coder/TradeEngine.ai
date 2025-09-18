---------------------------------------------------------------------------
-- Author       Gududhuru Raghavendra
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get the Spent Time Details From joining Date
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetSpentTimeDetails] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetSpentTimeDetails]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = 1;--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN	  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
		   IF(@UserId IS NULL)
		   BEGIN
				SET @UserId = @OperationsPerformedBy;
		   END
		   
		   DECLARE @DateFrom DATE = (SELECT ISNULL(J.JoinedDate,U.RegisteredDateTime)
										 FROM  Employee E
										 INNER JOIN [User] U ON U.Id = E.UserId AND U.Id = @UserId
										 LEFT JOIN [Job] J ON J.EmployeeId = E.Id
										 WHERE J.InActiveDateTime IS NULL)
		  IF(DATEDIFF(YEAR,@DateFrom,GETDATE()) > 5) SET @DateFrom = DATEADD(YEAR,-5,GETDATE())

		   SELECT T.[Date]
		          ,CASE WHEN Tim.SpentWithoutBreaks = -1 THEN -1 ELSE ISNULL(Tim.SpentWithoutBreaks,0) - ISNULL(P.BreakInMinutes,0) END AS SpentTime 
		         --,ISNULL(Tim.SpentWithoutBreaks,0) - ISNULL(SUM(P.BreakInMinutes),0) AS SpentTime 
		  FROM (SELECT DATEADD(DAY,NUMBER,@DateFrom) AS [Date] 
				 FROM Master..SPT_VALUES where [type] =  'P' and number <= DATEDIFF(DAY,@DateFrom,GETDATE())) T
           LEFT JOIN (
           SELECT CONVERT(DATE,[Date]) AS [Date],CASE WHEN OutTime IS NULL THEN -1 ELSE DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),ISNULL(SWITCHOFFSET(OutTime, '+00:00'),GETDATE())) - DATEDIFF(MINUTE,ISNULL(SWITCHOFFSET(LunchBreakStartTime, '+00:00'),GETDATE()),ISNULL(SWITCHOFFSET(LunchBreakEndTime, '+00:00'),GETDATE())) END AS SpentWithoutBreaks 
		   FROM TimeSheet WHERE UserId = @UserId) Tim  ON Tim.[Date] = T.[Date]
		   LEFT JOIN (
           SELECT CONVERT(DATE,[Date]) AS [Date],SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)) AS BreakInMinutes 
		   FROM UserBreak WHERE UserId = @UserId GROUP BY [Date]) P ON P.[Date] = T.[Date]
           --GROUP BY T.[Date],Tim.SpentWithoutBreaks,P.BreakInMinutes

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
