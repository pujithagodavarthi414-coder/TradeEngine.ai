---------------------------------------------------------------------------
-- Author       Gududhuru Raghavendra
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get the Total Break Time Details From joining Date
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetBreakTimings] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetBreakTimings]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  =  1;--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
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

		 -- IF(DATEDIFF(YEAR,@DateFrom,GETDATE()) > 5) SET @DateFrom = DATEADD(YEAR,-5,GETDATE())
		  CREATE TABLE #Temp
		  (
		  [Date] DATETIME 
		  )
		      ;WITH CTE AS
              (
                SELECT @DateFrom DateValue
                UNION ALL
                SELECT  DATEADD(DAY,1,DateValue)
                FROM    CTE   
                WHERE   CAST(DATEADD(DAY,1,DateValue) AS date) <= CAST(GETDATE() AS date)
              )
			  INSERT INTO #Temp(Date)
              SELECT  DateValue FROM    CTE OPTION (MAXRECURSION 0)


		   SELECT T.[Date]
		   ,CASE WHEN BreakInner.[Date] IS NOT NULL THEN -1 ELSE ISNULL(P.BreakInMinutes,0) END AS BreakInMinutes
		   --,ISNULL(SUM(P.BreakInMinutes),0) AS BreakInMinutes 
		   FROM (SELECT CAST([Date] AS date) [Date] FROM #Temp) T
		   LEFT JOIN (
		   SELECT CONVERT(DATE,[Date]) AS [Date],SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, '+00:00'),SWITCHOFFSET(BreakOut, '+00:00'))) AS BreakInMinutes 
		   FROM UserBreak WHERE UserId = @UserId GROUP BY CAST([Date] AS date)) P ON CAST(P.[Date] AS date) = T.[Date]
		   LEFT JOIN (SELECT CONVERT(DATE,[Date]) AS [Date]
		   FROM UserBreak WHERE UserId = @UserId AND BreakOut IS NULL GROUP BY [Date]) AS BreakInner ON BreakInner.[Date] = T.[Date]
		   --GROUP BY T.[Date]

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
GO