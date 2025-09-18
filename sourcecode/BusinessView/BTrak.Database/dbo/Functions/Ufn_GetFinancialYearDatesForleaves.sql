--SELECT [dbo].[Ufn_GetFinancialYearDatesForleaves]
CREATE FUNCTION [dbo].[Ufn_GetFinancialYearDatesForleaves]
(
	@UserId UNIQUEIDENTIFIER,
    @Year INT = NULL
)
RETURNS @Daterange TABLE
(
	DateFrom DATE,
	DateTo DATE
)
AS
BEGIN

	DECLARE @JoinedDate DATETIME,@FromMonth INT,@ToMonth INT,@DateFrom DATETIME,@DateTo DATETIME

      IF(@Year IS NULL) SET @Year = DATEPART(YEAR,GETDATE())

	  SELECT @FromMonth = FYC.FromMonth,@ToMonth = FYC.ToMonth
                 FROM Employee E 
				 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                 JOIN Job J ON J.EmployeeId = E.Id AND E.UserId = @UserId 
                 JOIN Branch B ON B.Id = EB.BranchId
                 JOIN FinancialYearConfigurations FYC ON FYC.CountryId = B.CountryId AND FYC.FinancialYearTypeId = 'C8DAB3F6-3EC3-4F77-B71C-0A1B06D154AF'--(Financial configuration type Leaves)
                  AND ((FYC.ActiveTo IS NULL AND FYC.ActiveFrom < GETDATE()) 
                   OR (FYC.ActiveTo IS NOT NULL AND (GETDATE() BETWEEN FYC.ActiveFrom AND FYC.ActiveTo)))

		SELECT @JoinedDate = JoinedDate
                 FROM Employee E 
				 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                 JOIN Job J ON J.EmployeeId = E.Id AND E.UserId = @UserId 
                 JOIN Branch B ON B.Id = EB.BranchId

         SELECT @FromMonth = ISNULL(@FromMonth,1), @ToMonth = ISNULL(@ToMonth,12)

          IF(@FromMonth IS NOT NULL AND @ToMonth IS NOT NULL)
          BEGIN
              
              IF(@ToMonth > @FromMonth)
              BEGIN
                   
                   SET @DateFrom = (SELECT DATEADD(YEAR,DATEDIFF(YEAR,0,'01-01-' + CONVERT(NVARCHAR(10),@Year)),DATEADD(MONTH,@FromMonth - 1,0)))

                   SET @DateTo = (SELECT DATEADD(DAY,-1,DATEADD(YEAR,DATEDIFF(YEAR,0,'01-01-' + CONVERT(NVARCHAR(10),@Year)),DATEADD(MONTH,@ToMonth,0))))

              END
              ELSE 
              BEGIN

                    SET @DateFrom = (SELECT DATEADD(YEAR,DATEDIFF(YEAR,0,'01-01-' + CONVERT(NVARCHAR(10),@Year)),DATEADD(MONTH,@FromMonth - 1,0)))
                    
                    SET @DateTo = (SELECT DATEADD(DAY,-1,DATEADD(YEAR,DATEDIFF(YEAR,0,'01-01-' + CONVERT(NVARCHAR(10),@Year)) + 1,DATEADD(MONTH,@ToMonth,0))))

              END
					
			IF(@DateFrom < @JoinedDate AND @JoinedDate IS NOT NULL) SET @DateFrom = @JoinedDate

            IF(@DateTo < @DateFrom) SET @DateTo = @DateFrom

	      END

            INSERT @Daterange
	        SELECT @DateFrom, @DateTo

    RETURN
END

