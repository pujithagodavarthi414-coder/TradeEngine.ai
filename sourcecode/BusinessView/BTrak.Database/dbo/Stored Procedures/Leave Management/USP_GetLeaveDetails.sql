--EXEC [USP_GetLeaveDetails] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308'  
CREATE PROCEDURE [dbo].[USP_GetLeaveDetails]
(
 @DateFrom DATETIME = NULL,
 @DateTo DATETIME = NULL,
 @LeaveTypeId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER
)
AS
BEGIN

DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
	BEGIN

	IF (@DateFrom IS NULL) SET @DateFrom = (SELECT DateFrom FROM [dbo].[Ufn_GetFinancialYearDatesForleaves] (@OperationsPerformedBy,NULL))
			
	IF (@DateTo IS NULL) 
	BEGIN
	
		SET @DateTo = (SELECT DateTo FROM [dbo].[Ufn_GetFinancialYearDatesForleaves] (@OperationsPerformedBy,NULL))

		IF(@DateFrom > @DateTo) SET @DateTo = @DateFrom

	END

	SELECT LeaveFrequencyId
	      ,DateFrom
		  ,DateTo
		  ,LT.LeaveTypeName
		  ,LeavesTaken
		  ,ActualBalance
		  ,EffectiveBalance
		  ,CarryForwardLeaves
		  ,IsCarryForward
		  ,IsPaid
	       FROM(SELECT LeaveFrequencyId
				      ,DateFrom
				  	  ,DateTo
				  	  ,LeaveTypeId
				  	  ,LeavesTaken
				  	  ,IsCarryForward
				  	  ,ISNULL(TotalLeaves,0) AS ActualBalance
				  	  ,CarryForwardLeaves
				  	  ,ISNULL(LeaveCount,0) - ISNULL(LeavesTaken,0) AS EffectiveBalance
				  	  ,IsPaid
				  FROM [dbo].[Ufn_GetLeavesReportOfAnUser](ISNULL(@UserId,@OperationsPerformedBy),NULL,@DateFrom,@DateTo)
				  WHERE (DateFrom BETWEEN @DateFrom AND @DateTo) 
				     OR (DateTo BETWEEN @DateFrom AND @DateTo)
				     OR (@DateFrom BETWEEN DateFrom AND DateTo)
				     OR (@DateTo BETWEEN DateFrom AND DateTo)
					 ) T
				  JOIN LeaveType LT ON LT.Id = T.LeaveTypeId
				  ORDER BY LeaveTypeName,DateFrom
	END
END