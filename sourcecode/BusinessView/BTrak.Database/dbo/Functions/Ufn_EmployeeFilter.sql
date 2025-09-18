CREATE FUNCTION [dbo].[Ufn_EmployeeFilter]
(
 @BranchId UNIQUEIDENTIFIER = NULL,
 @CompanyId UNIQUEIDENTIFIER,
 @ActiveFrom DATETIME = NULL,
 @ActiveTo DATETIME = NULL,
 @IsArchived BIT = NULL
)
RETURNS TABLE AS RETURN
(
	SELECT E.Id AS EmployeeId,U.Id AS UserId FROM Employee E
   INNER JOIN [User] U ON U.Id = E.UserId 
   WHERE E.BranchId = @BranchId
     AND U.CompanyId = @CompanyId
     AND ((@ActiveFrom IS NULL OR U.RegisteredDateTime <= @ActiveFrom)
      OR (@ActiveTo IS NULL OR U.LastConnection >= @ActiveTo)
      OR (U.RegisteredDateTime <= @ActiveFrom AND U.LastConnection >= @ActiveTo))
     AND (@IsArchived IS NULL 
      OR (@IsArchived = 0 AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL)
      OR (@IsArchived = 1 AND U.InActiveDateTime IS NOT NULL AND E.InActiveDateTime IS NOT NULL))
)
