-------------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-01-06 00:00:00.000'
-- Purpose      To Get The foodorders by applying different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SearchFoodOrders_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@Date = '2019-11-01',@PageSize = 100,@SearchText='17'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SearchFoodOrders_New]
(
    @FoodOrderId UNIQUEIDENTIFIER = NULL,
    @SearchText  NVARCHAR(250) = NULL,
    @Amount MONEY = NULL,
    @CurrencyId UNIQUEIDENTIFIER = NULL,
    @OrderedDateTime DATETIME = NULL,
    @ClaimedByUserId UNIQUEIDENTIFIER = NULL,
    @StatusId UNIQUEIDENTIFIER = NULL,
    @Date DATETIME = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(100) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @EntityId UNIQUEIDENTIFIER = NULL,
	@IsRecent BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN

        DECLARE @StartDate DATETIME

        DECLARE @EndDate DATETIME

		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

		IF(@IsRecent = 1)
		BEGIN

		   SET @Date = GETDATE()

		   SELECT @EndDate = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Date), CAST(@Date AS DATE))

		   SELECT @StartDate = DATEADD(dd, -(DATEPART(dw, @EndDate)-1), CAST(@EndDate AS DATE))

		END
		ELSE IF (@Date IS NOT NULL)
		BEGIN

		   SET @StartDate = DATEADD(month, DATEDIFF(month, 0, @Date), 0)

           SET @EndDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))

		END

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
        IF(@FoodOrderId = '00000000-0000-0000-0000-000000000000') SET @FoodOrderId = NULL
        
        IF(@ClaimedByUserId = '00000000-0000-0000-0000-000000000000') SET @ClaimedByUserId = NULL
       
        IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET @CurrencyId = NULL
        
        IF(@StatusId = '00000000-0000-0000-0000-000000000000') SET @StatusId = NULL
        
        IF(@PageNumber IS NULL) SET @PageNumber = 1
        
        IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM FoodOrder WHERE InActiveDateTime IS NULL)
        
		IF(@PageSize = 0) SET @PageSize = 10

        IF(@SearchText = '') SET @SearchText = NULL

		SET @SearchText = LTRIM(RTRIM(@SearchText))
        
        SET @SearchText = '%' + @SearchText + '%'
                            SELECT *,TotalCount = COUNT(1) OVER() 
                            FROM (
                                         SELECT FO.Id AS FoodOrderId,
                                                FO.CompanyId,
                                                FO.FoodItemName,
                                                FO.Amount,
                                                FO.CurrencyId,
                                                FO.Comment,
                                                FO.ClaimedByUserId,
                                                U.FirstName + ' ' + ISNULL(U.SurName,'') AS ClaimedByUserName,
                                                U.ProfileImage AS ClaimedByUserProfileImage,
                                                FO.FoodOrderStatusId,
                                                FOS.[Status],
                                                FO.StatusSetByUserId,
                                                U1.FirstName + ' ' + ISNULL(U1.SurName,'') AS StatusSetByUserName,
                                                U1.ProfileImage AS StatusSetByUserProfileImage,                             
                                                FO.OrderedDateTime,
                                                FO.StatusSetDateTime,
                                                FO.Reason,
                                                FO.CreatedDateTime,
                                                FO.CreatedByUserId,
							                	   FO.[TimeStamp],
							                	   C.CurrencyName,
							                	   C.Symbol,
                                                EmployeesName = STUFF(( SELECT ',' + Convert(nvarchar(50),U.FirstName+' '+ISNULL(U.SurName,''))[text()]
                                                                 FROM FoodOrderUser FOU 
                                                                 INNER JOIN [User] U ON U.Id = FOU.UserId -- AND U.InActiveDateTime IS Null
                                                                 INNER JOIN FoodOrder FO1 ON FO1.Id = FOU.OrderId
                                                                 WHERE FO1.Id = FO.Id
                                                                 FOR XML PATH(''), TYPE).value('.','NVARCHAR(2000)'),1,1,''),
                                                EmployeesCount = (SELECT COUNT(1) FROM FoodOrderUser WHERE OrderId = FO.Id),
                                                Receipts = STUFF(( SELECT  ',' + Convert(nvarchar(1000),F.FilePath)[text()]
                                                                 FROM [UploadFile] F 
                                                                 INNER JOIN FoodOrder FO2 ON FO2.Id = F.ReferenceId 
                                                                 WHERE FO2.Id = FO.Id
                                                                 FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
                                           FROM [FoodOrder] FO
                                                INNER JOIN [User] U ON U.Id = FO.ClaimedByUserId AND U.InActiveDateTime IS NULL
                                                INNER JOIN [Employee] E ON E.UserId = U.Id 
	                                            INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                                       AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	                            	   AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                                           AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                                                INNER JOIN [FoodOrderStatus] FOS ON FOS.Id = FO.FoodOrderStatusId AND FOS.InActiveDateTime IS NULL
                                                LEFT JOIN [Currency] C ON C.Id = FO.CurrencyId AND C.InActiveDateTime IS NULL
							                	LEFT JOIN [User] U1 ON U1.Id = FO.StatusSetByUserId  AND U.InActiveDateTime IS NULL 
                                          WHERE FO.CompanyId = @CompanyId 
                                      )T
                                      WHERE (@FoodOrderId IS NULL OR T.FoodOrderId = @FoodOrderId)
                                   AND (@CurrencyId IS NULL OR T.CurrencyId = @CurrencyId)
                                   AND (@SearchText IS NULL OR T.FoodItemName LIKE @SearchText
                                                            OR T.ClaimedByUserName LIKE @SearchText
                                                            OR T.StatusSetByUserName LIKE @SearchText
                                                            OR T.EmployeesCount LIKE @SearchText
                                                            OR CONVERT(DATE,T.OrderedDateTime) LIKE @SearchText
															OR LEFT((SUBSTRING(CONVERT(VARCHAR, StatusSetDateTime, 106),1,2) + '-' + SUBSTRING(CONVERT(VARCHAR, StatusSetDateTime, 106),4,3)+ '-'+ CONVERT(VARCHAR,DATEPART(YEAR,StatusSetDateTime))+ ' ' +
                                                               LTRIM(RIGHT(CONVERT(VARCHAR(20), DATEADD(MINUTE,330,StatusSetDateTime), 100), 7))), len((SUBSTRING(CONVERT(VARCHAR, StatusSetDateTime, 106),1,2) + '-' + SUBSTRING(CONVERT(VARCHAR, StatusSetDateTime, 106),4,3)+ '-'+ CONVERT(VARCHAR,DATEPART(YEAR,StatusSetDateTime))+ ' ' +
                                                               LTRIM(RIGHT(CONVERT(VARCHAR(20), DATEADD(MINUTE,330,StatusSetDateTime), 100), 7))))-2)  LIKE @SearchText
															OR (SUBSTRING(CONVERT(VARCHAR, T.OrderedDateTime, 106),1,2) + '-'
                                                                + SUBSTRING(CONVERT(VARCHAR, T.OrderedDateTime, 106),4,3) + '-'
                                                                + CONVERT(VARCHAR,DATEPART(YEAR,T.OrderedDateTime)) LIKE @SearchText) 
															OR (CONVERT(VARCHAR,DATEPART(DAY,T.OrderedDateTime)) +  '-' + SUBSTRING(CONVERT(VARCHAR, T.OrderedDateTime, 106),4,3) +  '-' + CONVERT(VARCHAR,DATEPART(YEAR,T.OrderedDateTime)) LIKE @SearchText)
                                                            OR T.Amount LIKE @SearchText
                                                            OR T.[Status] LIKE @SearchText
                                                            OR T.Reason LIKE @SearchText
                                                            OR T.Comment LIKE @SearchText)
                                   AND (@Amount IS NULL OR T.Amount = @Amount)
                                   AND (@OrderedDateTime IS NULL OR T.OrderedDateTime = @OrderedDateTime)
                                   AND (@ClaimedByUserId IS NULL OR T.ClaimedByUserId = @ClaimedByUserId)
                                   AND (@StatusId IS NULL OR T.FoodOrderStatusId = @StatusId)
                                   AND (@Date IS NULL OR (T.OrderedDateTime BETWEEN @StartDate AND @EndDate))
                            ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'DESC') THEN
                         CASE  WHEN(@SortBy IS NULL OR @SortBy = 'OrderedDateTime') THEN T.OrderedDateTime
                               WHEN(@SortBy = 'Comment') THEN T.Comment
                               WHEN(@SortBy = 'StatusSetByUserName') THEN T.StatusSetByUserName
                               WHEN(@SortBy = 'ClaimedByUserName') THEN T.ClaimedByUserName
                               WHEN(@SortBy = 'Status') THEN T.[Status]
                               WHEN(@SortBy = 'Reason') THEN T.Reason
                               WHEN(@SortBy = 'FoodItemName') THEN T.FoodItemName
                               WHEN(@SortBy = 'Amount') THEN T.Amount
                               WHEN (@SortBy = 'EmployeesCount') THEN T.EmployeesCount
                               WHEN (@SortBy = 'EmployeesName') THEN T.EmployeesName
                               WHEN @SortBy = 'statusSetDateTime' THEN Cast(T.statusSetDateTime as sql_variant)
                               WHEN @SortBy = 'OrderedDateTime' THEN Cast(T.OrderedDateTime as sql_variant)
                               WHEN @SortBy = 'CreatedDateTime' THEN Cast(T.CreatedDateTime as sql_variant)
                               END 
                      END DESC,
                     CASE WHEN @SortDirection = 'ASC' THEN
                         CASE  WHEN(@SortBy IS NULL OR @SortBy = 'OrderedDateTime') THEN T.OrderedDateTime
                               WHEN(@SortBy = 'Comment') THEN T.Comment
                               WHEN(@SortBy = 'StatusSetByUserName') THEN T.StatusSetByUserName
                               WHEN(@SortBy = 'ClaimedByUserName') THEN T.ClaimedByUserName
                               WHEN(@SortBy = 'Status') THEN T.[Status]
                               WHEN(@SortBy = 'Reason') THEN T.Reason
                               WHEN(@SortBy = 'FoodItemName') THEN T.FoodItemName
                               WHEN(@SortBy = 'Amount') THEN T.Amount
                               WHEN(@SortBy = 'EmployeesCount') THEN T.EmployeesCount
                               WHEN(@SortBy = 'EmployeesName') THEN T.EmployeesName
                               WHEN @SortBy = 'statusSetDateTime' THEN Cast(T.statusSetDateTime as sql_variant)
                               WHEN @SortBy = 'OrderedDateTime' THEN Cast(T.OrderedDateTime as sql_variant)
                               WHEN @SortBy = 'CreatedDateTime' THEN Cast(T.CreatedDateTime as sql_variant)
                               END 
                             END ASC
                            OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                            
                            FETCH NEXT @PageSize ROWS ONLY

	END
	ELSE
	BEGIN

		 RAISERROR (@HavePermission,10, 1)

	END
    END TRY
    BEGIN CATCH
       THROW
    END CATCH
END
GO