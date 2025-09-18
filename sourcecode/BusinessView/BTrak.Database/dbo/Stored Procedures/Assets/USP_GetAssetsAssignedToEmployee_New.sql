CREATE PROCEDURE [dbo].[USP_GetAssetsAssignedToEmployee_New]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER ,
	@UserId UNIQUEIDENTIFIER = NULL,
	@BranchId UNIQUEIDENTIFIER = NULL,
	@TypeOfAsset NVARCHAR(250) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	  
	  IF (@HavePermission = '1')
	  BEGIN

       IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL;

       IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL;

       IF(@TypeOfAsset = '') SET @TypeOfAsset = NULL

       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

       SELECT AAE.AssignedToEmployeeId AS EmployeeId,
              (U.FirstName+' '+ ISNULL(U.SurName,'')) AS EmployeeName ,
			  A.AssetName,
			  P.ProductName,
			  AAE.AssignedDateFrom,
			  CONVERT(nvarchar(30), AAE.AssignedDateFrom, 106) AS AssignedDate,
			  U2.FirstName+' '+ISNULL(U2.SurName,'') AS ApprovedBy,
			  B.BranchName AS BranchName
       FROM [AssetAssignedToEmployee] AS AAE
       INNER JOIN [USER] AS U ON U.Id = AAE.AssignedToEmployeeId
	   INNER JOIN [User] AS U2 ON U2.Id = AAE.ApprovedByUserId
       INNER JOIN Asset AS A ON A.Id = AAE.AssetId
	   INNER JOIN ProductDetails AS PD ON PD.Id = A.ProductDetailsId
	   INNER JOIN Product AS P ON P.Id = PD.ProductId
       INNER JOIN Employee AS E ON E.UserId = U.Id
       INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.ID
	   INNER JOIN Branch B ON B.Id = EB.BranchId
       WHERE (@UserId IS NULL OR AAE.AssignedToEmployeeId = @UserId)
             AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
             AND (@TypeOfAsset IS NULL OR (A.AssetName LIKE '%'+ LOWER(@TypeOfAsset)+'%'))
             AND U.CompanyId = @CompanyId

	 END
     ELSE
	 BEGIN
    
	  RAISERROR(@HavePermission,11,1)
     
	 END
   END TRY
   BEGIN CATCH

       THROW

   END CATCH
END
GO