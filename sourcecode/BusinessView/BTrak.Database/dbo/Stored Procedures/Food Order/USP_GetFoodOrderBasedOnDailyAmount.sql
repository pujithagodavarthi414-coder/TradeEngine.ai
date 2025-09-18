-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-26 00:00:00.000'
-- Purpose      To get daily food Order expenses for a month
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetFoodOrderBasedOnDailyAmount] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@Date = '2019-03-11 00:00:00.000'
----------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_GetFoodOrderBasedOnDailyAmount
(
 @Date DATETIME = NULL,
 @EntityId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

    SET NOCOUNT ON  
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
            
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		    IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
           
            IF (@Date IS NULL) SET @Date = GETDATE()            
            
            DECLARE @RejectedStatus UNIQUEIDENTIFIER = (SELECT Id FROM FoodOrderStatus WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND ISNULL(IsRejected,0) = 1)
            
			DECLARE @DateFrom DATETIME = DATEADD(M,DATEDIFF(M,0,@Date),0) 
            
			DECLARE @DateTo DATETIME = DATEADD(D,-1,DATEADD(M,(DATEDIFF(M,0,@Date)+1),0)) 
            
			CREATE TABLE #Dates(
                                MonthDate DATETIME 
                               )

            INSERT INTO #Dates (MonthDate)
            SELECT DATEADD(DAY,NUMBER,@DateFrom)
			FROM Master..SPT_VALUES
			WHERE Type = 'P'
			AND NUMBER <= DATEDIFF(DAY,@DateFrom,@DateTo)
            
            SELECT  Temp.MonthDate AS OrderedDateTime,
                    ISNULL(SUM(Amount),0) AS amount
                    FROM #Dates Temp 
					     LEFT JOIN 
						 (SELECT FI.Amount,CONVERT(DATE,FI.OrderedDateTime) AS OrderedDateTime FROM FoodOrder FI  
                         INNER JOIN [User] U ON U.Id = FI.ClaimedByUserId  AND U.InActiveDateTime IS NULL
						           AND FI.InActiveDateTime IS NULL
								   AND FI.CompanyId = @CompanyId
								   AND FI.FoodOrderStatusId <> @RejectedStatus
                         INNER JOIN [Employee] E ON E.UserId = U.Id 
	                     INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                			    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                    AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
						) T ON Temp.MonthDate = T.OrderedDateTime

                    GROUP BY Temp.MonthDate

        END
        ELSE
            
            RAISERROR(@HavePermission,11,1)
    
	END TRY
    BEGIN CATCH
      
        THROW

    END CATCH

END
GO