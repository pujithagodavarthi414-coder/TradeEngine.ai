-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Salary Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeSalaryDetails] @OperationsPerformedBy='873A35E6-64FC-4655-803B-03B15B6CBC02'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeSalaryDetails]
(
   @EmployeeSalaryDetailId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @IsArchived BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          IF (@SortDirection = NULL) SET @SortDirection = 'ASC'
          IF (@SortBy = NULL) SET @SortBy = 'SalaryComponent'
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          IF(@SearchText = '') SET @SearchText = NULL
          SET @SearchText = '%'+ LTRIM(RTRIM(@SearchText))+'%'
          SELECT E.Id EmployeeId,
                 ES.Id EmployeeSalaryDetailId,
                 U.FirstName,
                 U.SurName,
                 U.UserName Email,
                 ES.SalaryPayGradeId PayGradeId,                
                 ES.SalaryComponent,
                 ES.SalaryPayFrequencyId PayFrequencyId,
                 ES.CurrencyId,
                 ES.Amount,
				 ES.NetPayAmount,
                 ES.Comments,
                 ES.IsAddedDepositDetails,
                 ES.ActiveFrom StartDate,
                 ES.PaymentMethodId,
                 ES.SalaryParticularsFileId,
                 ES.ActiveTo EndDate,
                 PG.PayGradeName,
                 PM.PaymentMethodName,
                 PF.PayFrequencyName,
				 EPTC.PayrollTemplateId,
				 EPTC.PayrollName,
                 F.[FileName],
                 C.CurrencyName,
				 EMS.IsPermanent,
                 ES.[TimeStamp],
                 U.FirstName + ' ' + U.SurName UserName,
                 CASE WHEN ES.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				 EPTC.TaxCalculationTypeId,
                 TCT.TaxCalculationTypeName,
                 TotalCount = COUNT(1) OVER()
          FROM  [dbo].EmployeeSalary ES WITH (NOLOCK)
                JOIN Employee E ON E.Id = ES.EmployeeId  AND E.InactiveDateTime IS NULL
                JOIN [User] U ON U.Id = E.UserId  AND U.InactiveDateTime IS NULL
				LEFT JOIN Job AS J ON J.EmployeeId = E.Id AND J.InActiveDateTime IS NULL
	            LEFT JOIN EmploymentStatus EMS ON J.EmploymentStatusId =EMS.Id AND EMS.InActiveDateTime IS NULL
                LEFT JOIN PaymentMethod PM ON PM.Id = ES.PaymentMethodId  AND PM.InactiveDateTime IS NULL
                LEFT JOIN PayGrade PG ON PG.Id = ES.SalaryPayGradeId  AND PG.InactiveDateTime IS NULL
                LEFT JOIN PayFrequency PF ON PF.Id = ES.SalaryPayFrequencyId
                LEFT JOIN [File] F ON F.Id = ES.SalaryParticularsFileId 
                LEFT JOIN Currency C ON C.Id = ES.CurrencyId AND C.InactiveDateTime IS NULL
				LEFT JOIN (select EPC.SalaryId, EPC.PayrollTemplateId, PT.PayrollName, EPC.EmployeeId,EPC.TaxCalculationTypeId from EmployeepayrollConfiguration EPC
				           JOIN PayrollTemplate AS PT ON PT.Id = EPC.PayrollTemplateId) AS EPTC ON EPTC.SalaryId = ES.Id AND EPTC.EmployeeId = E.Id
				LEFT JOIN TaxCalculationType TCT ON TCT.Id = EPTC.TaxCalculationTypeId
          WHERE  (@EmployeeSalaryDetailId IS NULL OR ES.Id = @EmployeeSalaryDetailId)
               AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
			   AND U.CompanyId = @CompanyId
               AND (@SearchText IS NULL 
					OR (ES.SalaryComponent LIKE @SearchText)
					OR (PF.PayFrequencyName LIKE @SearchText)
					OR (C.CurrencyName LIKE @SearchText)
					OR (ES.Amount LIKE @SearchText)
					OR (ES.Comments LIKE @SearchText)
					OR (PG.PayGradeName LIKE @SearchText)
					OR (ES.Comments LIKE @SearchText)
					OR (EPTC.PayrollName LIKE @SearchText)
					OR (ES.NetPayAmount LIKE @SearchText)
					OR (SUBSTRING(CONVERT(VARCHAR, ES.ActiveFrom, 106),1,2) + '-'
                                                  + SUBSTRING(CONVERT(VARCHAR, ES.ActiveFrom, 106),4,3) + '-'
                                                  + CONVERT(VARCHAR,DATEPART(YEAR,ES.ActiveFrom)) LIKE @SearchText)
				    OR (SUBSTRING(CONVERT(VARCHAR, ES.ActiveTo, 106),1,2) + '-'
                                                  + SUBSTRING(CONVERT(VARCHAR, ES.ActiveTo, 106),4,3) + '-'
                                                  + CONVERT(VARCHAR,DATEPART(YEAR,ES.ActiveTo)) LIKE @SearchText))
               AND (@IsArchived IS NULL OR (@IsArchived = 1 AND ES.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND ES.InActiveDateTime IS NULL))
          ORDER BY
             CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'SalaryComponent')              THEN  CAST(ES.SalaryComponent AS SQL_VARIANT)
                              WHEN(@SortBy = 'PayFrequencyName')             THEN  PF.PayFrequencyName
                              WHEN(@SortBy = 'CurrencyName')                 THEN  C.CurrencyName
                              WHEN(@SortBy = 'Amount')                       THEN  ES.Amount
                              WHEN(@SortBy = 'Comments')                     THEN  ES.Comments
                              WHEN(@SortBy = 'ShowDirectDepositDetails')     THEN  ES.IsAddedDepositDetails
							  WHEN(@SortBy = 'PayGradeName')                 THEN  PG.PayGradeName
							  WHEN(@SortBy = 'StartDate')                    THEN  ES.ActiveFrom
							  WHEN(@SortBy = 'EndDate')                      THEN  ES.ActiveTo
							  WHEN(@SortBy = 'PayrollName')                  THEN  EPTC.PayrollName
							  WHEN(@SortBy = 'NetPayAmount')                 THEN  ES.NetPayAmount
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'SalaryComponent')              THEN  CAST(ES.SalaryComponent AS SQL_VARIANT)
                              WHEN(@SortBy = 'PayFrequencyName')             THEN  PF.PayFrequencyName
                              WHEN(@SortBy = 'CurrencyName')                 THEN  C.CurrencyName
                              WHEN(@SortBy = 'Amount')                       THEN  ES.Amount
                              WHEN(@SortBy = 'Comments')                     THEN  ES.Comments
                              WHEN(@SortBy = 'ShowDirectDepositDetails')     THEN  ES.IsAddedDepositDetails
							  WHEN(@SortBy = 'PayGradeName')                 THEN  PG.PayGradeName
							  WHEN(@SortBy = 'StartDate')                    THEN  ES.ActiveFrom
							  WHEN(@SortBy = 'EndDate')                      THEN  ES.ActiveTo
							  WHEN(@SortBy = 'PayrollName')                  THEN  EPTC.PayrollName
							  WHEN(@SortBy = 'NetPayAmount')                 THEN  ES.NetPayAmount
                          END
                      END DESC
          OFFSET ((@PageNo - 1) * @PageSize) ROWS
          FETCH NEXT @PageSize ROWS ONLY
        END
        ELSE
          
          RAISERROR(@HavePermission,11,1)
     END TRY  
     BEGIN CATCH 
        
           THROW
    END CATCH
END