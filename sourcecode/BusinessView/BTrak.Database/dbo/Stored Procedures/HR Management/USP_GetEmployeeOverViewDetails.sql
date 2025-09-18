-------------------------------------------------------------------------------
-- Author   Ranadheer Rana
-- Created      '2019-06-03 00:00:00.000'
-- Purpose      To get the employee overview details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC USP_GetEmployeeOverViewDetails @EmployeeId = '30F6A3DD-D686-4F55-A3FC-473E5ED76976',@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036972'

------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_GetEmployeeOverViewDetails
(
 @EmployeeId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
      IF(@HavePermission = '1')
	  BEGIN
		
		 IF(@EmployeeId IS NULL)
          BEGIN

             RAISERROR(50011,16,1,'Employee')

          END
          ELSE
          BEGIN
			
			  DECLARE @DateFrom DATETIME = (SELECT DATEADD(M,DATEDIFF(M,0,GETDATE()),0)) 

              DECLARE @DateTo DATETIME = (SELECT DATEADD(M, DATEDIFF(M, 0, GETDATE()) + 1, -1))

			  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			  DECLARE @IsPossible BIT =  CASE WHEN (SELECT COUNT(1) FROM Employee WHERE Id = @EmployeeId AND InActiveDateTime IS NULL)>0 THEN 1 ELSE 0 END

              IF(@IsPossible = 1)
              BEGIN


				 SELECT E.Id EmployeeId,
                        U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName ,
                        U.MobileNo PhoneNumber,
                        U.ProfileImage ProfileImage,
                        U.UserName Emailid,
                        U1.CreatedDateTime DateOfJoininmg ,
                        B.Id BranchId,
                        B.BranchName,
                        B.CompanyId,
						ISNULL(Credit.Credit,0) - ISNULL(Debit.Debit,0) AS CanteenCredit,
						ISNULL(Spent.SpentTimeInHrs,0) AS SpentTimeInHrs,
						LunchLateCount.LunchCount AS LunchLateDaysCount,
						Mrng.MrngCnt AS MorningLateDaysCount,
					    LuANDMrng.LuMrngCnt AS MorningAndLunchLateDaysCount,
						LAInner.LeavesTaken AS ApprovedLeaves,
						LeaveAllowance.NoOfLeaves - LAInner.LeavesTaken AS RemainingLeaves,
						ISNULL(P.ProductivityIndex,0) as Productivity
                        FROM Employee E
						 JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
						 JOIN [EmployeeBranch] EB ON EB.EmployeeId = E.Id
						 JOIN [Branch] B ON B.Id = EB.BranchId 
						 JOIN [User] U1 ON U.Id = U1.Id AND U1.Id = U1.Id
						 LEFT JOIN(SELECT U.Id AS UserId,SUM(UCC.Amount) Credit FROM UserCanteenCredit UCC 
                                                                                        JOIN [User] U ON U.Id = UCC.CreditedToUserId AND U.InactiveDateTime IS NULL
                                                                                        JOIN Employee E ON E.UserId = U.Id AND E.InactiveDateTime IS NULL
						                                                               WHERE E.Id = @EmployeeId 
						                                                               Group By U.Id)Credit  ON U.Id = Credit.UserId
				         LEFT JOIN (SELECT U.Id AS UserId,SUM(CFI.PRICE *  UPCFI.Quantity) AS Debit FROM CanteenFoodItem CFI 
								                                                                            JOIN [User] U ON U.CompanyId = CFI.CompanyId AND U.InactiveDateTime IS NULL 
                                                                                                            JOIN UserPurchasedCanteenFoodItem UPCFI ON UPCFI.UserId = U.Id 
                                                                                                            JOIN Employee E ON E.UserId = U.Id  AND E.InactiveDateTime IS NULL
																			                                WHERE E.Id = @EmployeeId 
																			                                GROUP BY U.Id)Debit  ON Debit.UserId = U.Id
						LEFT JOIN (SELECT  U.Id AS UserId,SUM((DATEDIFF(MINUTE,SWITCHOFFSET(TS.InTime, '+00:00'),SWITCHOFFSET(TS.OutTime, '+00:00'))))/60.00 AS SpentTimeInHrs FROM  TimeSheet TS 
                                                                                        JOIN [User] U  ON TS.UserId = U.Id  AND U.InactiveDateTime IS NULL
                                                                                        JOIN [Employee] E ON E.UserId = U.Id  AND E.InactiveDateTime IS NULL
                                                                                        WHERE DATEPART(Month,TS.[Date]) = datepart(Month,GETDATE()) 
                                                                                        GROUP BY U.Id) Spent ON Spent.UserId = U.Id
						LEFT JOIN (SELECT E.Id AS Employee,LA.NoOfLeaves FROM LeaveAllowance LA 
						                                                         JOIN EmployeeLeaveAllowance ELA ON LA.Id = ELA.LeaveAllowanceId 
														                         JOIN Employee E ON E.Id = ELA.EmployeeId AND E.InactiveDateTime IS NULL 
														                         WHERE E.Id = @EmployeeId
																				   ) TL ON TL.Employee = E.Id
				        LEFT JOIN (SELECT TS.UserId,COUNT(1) AS [LunchCount] FROM TimeSheet TS 
						                                                     JOIN [User] U ON U.Id = TS.UserId  AND U.InActiveDateTime IS NULL
						                                                     JOIN Employee E ON E.UserId = U.Id  AND E.InActiveDateTime IS NULL
															                 WHERE DATEDIFF(Minute,SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'),SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')) > 70 
															                 AND U.Id = U.Id 
																			 GROUP BY TS.UserId) LunchLateCount ON U.Id = LunchLateCount.UserId
						LEFT JOIN (SELECT TS.UserId,COUNT(1) AS MrngCnt FROM TimeSheet TS 
                                                                                  JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
                                                                                  JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
                                                                                  JOIN EmployeeShift ES ON ES.EmployeeId = E.Id  AND ES.ActiveFrom <= CONVERT(DATE,TS.[Date]) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,TS.[Date]))
                                                                                  JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
																				  JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date]))  
																				  LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ST.Id  
                                                                                  WHERE E.Id = @EmployeeId
												                                    AND DATEDIFF(MINUTE,CONVERT(time,SWITCHOFFSET(TS.InTime, '+00:00'),108),ISNULL(SE.Deadline,SW.Deadline)) > 0
													                                GROUP BY TS.UserId,TS.[Date]) Mrng ON Mrng.UserId = U.Id
						LEFT JOIN (SELECT TS.UserId,COUNT(1) AS LuMrngCnt FROM TimeSheet TS 
                                                                                  JOIN [User] U ON U.Id = TS.UserId  AND U.InActiveDateTime IS NULL
                                                                                  JOIN Employee E ON E.UserId = U.Id  AND E.InActiveDateTime IS NULL
                                                                                  JOIN EmployeeShift ES ON ES.EmployeeId = E.Id   AND ES.ActiveFrom <=CONVERT(DATE,TS.[Date]) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,TS.[Date]))
                                                                                  JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
																				  JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date])) 
																				  LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ST.Id AND SE.InActiveDateTime IS NULL AND SE.ExceptionDate = TS.[Date]
                                                                                  WHERE E.Id = @EmployeeId
												                                    AND DATEDIFF(MINUTE,CONVERT(time,SWITCHOFFSET(TS.InTime, '+00:00'),108),ISNULL(SE.Deadline,SW.Deadline)) > 0
																					AND DATEDIFF(Minute,SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'),SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')) > 70 
													                                GROUP BY TS.UserId,TS.[Date]) LuANDMrng ON LuANDMrng.UserId = U.Id
					    LEFT JOIN (SELECT UserId,ProductivityIndex FROM [dbo].[Ufn_ProductivityIndexForDevelopers_New](@DateFrom,@DateTo,@OperationsPerformedBy,@CompanyId)) P ON P.UserId = U.Id
						LEFT JOIN (SELECT UserId,
		                  SUM(DATEDIFF(DAY,LeaveDateFrom,LeaveDateTo)+1) LeavesTaken 
		                  FROM LeaveApplication LA
						  JOIN LeaveType LT WITH (NOLOCK) ON LT.Id = LA.LeaveTypeId
						  LEFT JOIN LeaveStatus LS WITH (NOLOCK) ON LS.Id = LA.OverallLeaveStatusId 
                          WHERE (LS.IsApproved = 1 OR LA.OverallLeaveStatusId = (SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved') OR LA.OverallLeaveStatusId IS NULL)
		       		      AND LeaveDateFrom BETWEEN @DateFrom AND @DateTo
						  --AND (LT.IsSickLeave = 1 OR LT.IsCasualLeave = 1)
		       		      AND (IsDeleted = 0 OR IsDeleted IS NULL)
                          GROUP BY UserId) LAInner ON LAInner.UserId = U.Id
						LEFT JOIN (SELECT ELA.EmployeeId,LA.NoOfLeaves FROM LeaveAllowance LA 
                                                                       JOIN EmployeeLeaveAllowance ELA ON LA.Id = ELA.LeaveAllowanceId  
                                                                       JOIN Employee E ON E.Id = ELA.EmployeeId AND E.InActiveDateTime IS NULL 
                                                                       WHERE  LA.[Year] = DATEPART(Year,@DateFrom)) LeaveAllowance ON LeaveAllowance.EmployeeId = E.Id
						WHERE E.Id = @EmployeeId
						  AND U.CompanyId = @CompanyId
						  AND E.InactiveDateTime IS NULL
						  AND U.IsActive = 1

                       GROUP BY E.Id ,U.FirstName + ' ' + ISNULL(U.SurName,'') ,U.MobileNo,
                                  U.ProfileImage,U.UserName,U1.CreatedDateTime ,B.Id,B.BranchName,B.CompanyId,
                                  ISNULL(Credit.Credit,0) - ISNULL(Debit.Debit,0) ,ISNULL(Spent.SpentTimeInHrs,0) ,LunchLateCount.LunchCount,
                                   Mrng.MrngCnt ,LuANDMrng.LuMrngCnt ,P.ProductivityIndex,LAInner.LeavesTaken,LeaveAllowance.NoOfLeaves - LAInner.LeavesTaken

				END 
                ELSE
					RAISERROR( 'EmployeeDetailsAreNotExisted',11,1)

			END
		 END
         ELSE
			RAISERROR(@HavePermission,11,1)

		  END TRY
          BEGIN CATCH

           THROW

          END CATCH
END 
GO 
