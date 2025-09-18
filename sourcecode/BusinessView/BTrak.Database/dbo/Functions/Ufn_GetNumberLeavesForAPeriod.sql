CREATE FUNCTION [dbo].[Ufn_GetNumberLeavesForAPeriod]
(
	@LeaveDateFrom DATE,
	@LeaveDateTo DATE,
	@FromLeaveSessionId UNIQUEIDENTIFIER,
	@ToLeaveSessionId UNIQUEIDENTIFIER
)
RETURNS FLOAT
AS
BEGIN

	DECLARE @SecondHalfId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE IsSecondHalf = 1 )

	DECLARE @FullDay UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE IsFullDay = 1 )

    DECLARE @NumberOfDays FLOAT = (SELECT IIF(DATEDIFF(DAY,@LeaveDateFrom,@LeaveDateTo)>=0,DATEDIFF(DAY,@LeaveDateFrom,@LeaveDateTo)-1,0) 
	                                    + CASE WHEN @LeaveDateTo = @LeaveDateTo THEN CASE WHEN @FromLeaveSessionId = @ToLeaveSessionId AND @FromLeaveSessionId <> @FullDay THEN 0.5
	                                                                            WHEN @FromLeaveSessionId = @ToLeaveSessionId AND @FromLeaveSessionId = @FullDay THEN 1
																			    WHEN @FromLeaveSessionId <> @ToLeaveSessionId AND @FromLeaveSessionId <> @FullDay THEN 1 
																		   END
																		   ELSE CASE WHEN @FromLeaveSessionId = @ToLeaveSessionId AND @FromLeaveSessionId <> @FullDay THEN 1.5
	                                                                                 WHEN @FromLeaveSessionId = @ToLeaveSessionId AND @FromLeaveSessionId = @FullDay THEN 2
																					 WHEN @FromLeaveSessionId <> @ToLeaveSessionId AND @FromLeaveSessionId <> @FullDay 
																					                                               AND @FromLeaveSessionId = @SecondHalfId THEN 1
																				ELSE 2
																		   END
										  END)

	RETURN @NumberOfDays
END
